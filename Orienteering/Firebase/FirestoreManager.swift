//
//  FirestoreManager.swift
//  Orienteering
//
//  Created by Kit Fan Cheung on 24/6/2023.
//

import Firebase

class FirestoreManager {
    
    static let shared = FirestoreManager()
    
    private let db = Firestore.firestore()
    
    // Method to check if a QR code exists in the database and activate the corresponding event or checkpoint
    func eventExists(atPath path: String, completion: @escaping (Bool) -> Void) {
        
        let qrCode = path.split(separator: "_")
        
        if(qrCode[1] == "event"){
            // If the QR code is for an event, fetch the event document and call addCheckPoint method to add checkpoints
            
            // Get reference to the event document
            let documentRef = db.collection("event").document(String(qrCode[0]))
            
            // Fetch event document
            documentRef.getDocument { (document, error) in
                if let error = error {
                    print("Error getting document: \(error)")
                    completion(false)
                } else if let document = document, document.exists {
                    // If document exists and has data, call addCheckPoint method to add checkpoints for the event
                    self.addCheckPoint(eventCode: String(qrCode[0]), checkPointData: document.data()!["check_point"] as! [Dictionary<String, Any>])
                    completion(true)
                } else {
                    completion(false)
                }
            }
        } else if (qrCode[1] == "checkpoint") {
            // If the QR code is for a checkpoint, fetch the participant document and update the activated field for the corresponding checkpoint
            
            // Get reference to the participant collection
            let collectionRef = db.collection("participant")
            let uid = Firebase.Auth.auth().currentUser!.uid
            
            // Query for participant document that matches the event code and user ID
            let query = collectionRef
                .whereField("event_code", isEqualTo: qrCode[0])
                .whereField("uid", isEqualTo: uid)
            
            // Fetch participant document
            query.getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching documents: \(error)")
                    completion(false)
                } else {
                    if let document = snapshot?.documents.first {
                        // If document exists and has data, get reference to the checkpoints subcollection and update the activated field for the corresponding checkpoint
                        collectionRef
                            .document(document.documentID)
                            .collection("checkpoints")
                            .whereField("title", isEqualTo: qrCode[2])
                            .getDocuments() { (snapshot, error) in
                                if let error = error {
                                    print("Error fetching checkpoint document: \(error)")
                                    completion(false)
                                } else if let document = snapshot?.documents.first {
                                    document.reference.updateData([
                                        "activated": true
                                    ]) { (error) in
                                        if let error = error {
                                            print("Error updating checkpoint: \(error)")
                                            completion(false)
                                        } else {
                                            completion(true)
                                        }
                                    }
                                } else {
                                    print("No matching checkpoints found")
                                    completion(false)
                                }
                            }
                    } else {
                        print("No documents found")
                        completion(false)
                    }
                }
            }
        }
    }
    
    // Method to add new participant document with checkpoints to the database
    func addCheckPoint(eventCode code: String, checkPointData checkpoints: [Dictionary<String, Any>]) {
        let collectionRef = db.collection("participant")
        let uid = Firebase.Auth.auth().currentUser?.uid
        
        // Query for participant document that matches the event code and user ID
        let query = collectionRef.whereField("event_code", isEqualTo: code)
                                 .whereField("uid", isEqualTo: uid!)
        
        // Fetch participant document
        query.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error)")
            } else {
                if let snapshot = snapshot, !snapshot.isEmpty {
                    // Document already exists for this event and user
                    print("Document already exists")
                } else {
                    // Document does not exist, add new document and checkpoints subcollection
                    
                    // Get reference to a new participant document
                    let documentRef = collectionRef.document()
                    
                    // Set data for the document
                    let data: [String: Any] = [
                        "current_score": 0,
                        "event_code": code,
                        "date": Date(),
                        "uid": uid!,
                        "last_update": Date()
                    ]
                    
                    // Add the document to the collection
                    documentRef.setData(data) { error in
                        if let error = error {
                            print("Error adding document: \(error)")
                        } else {
                            print("Document added successfully")
                            
                            // Add subcollection to new document
                            let subcollectionRef = documentRef.collection("checkpoints")
                            for checkpoint in checkpoints {
                                // Add a new document for each checkpoint in the subcollection
                                subcollectionRef.addDocument(data: checkpoint) { error in
                                    if let error = error {
                                        print("Error adding checkpoint document: \(error)")
                                    } else {
                                        print("Checkpoint document added successfully")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Method to get data for all checkpoints completed by the user for the current day
    func getCheckpointData(completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let uid = Firebase.Auth.auth().currentUser?.uid
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        let collectionRef = db.collection("participant")
        
        // Query for participant documents that match the user ID and have a last_update field between the start and end of the current day
        let query = collectionRef.whereField("uid", isEqualTo: uid!)
                                 .whereField("last_update", isGreaterThan: startOfDay)
                                 .whereField("last_update", isLessThan: endOfDay)
        
        // Fetch participant documents
        query.getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                var checkpointData = [String: Any]()
                for document in snapshot!.documents {
                    for checkpoint in document.data()["checkpoints"] as! [[String: Any]] {
                        if checkpoint["activated"] as! Bool {
                            // If checkpoint is activated, add its points to the checkpointData dictionary
                            let title = checkpoint["title"] as! String
                            let points = checkpoint["points"] as! Int
                            if let existingPoints = checkpointData[title] as? Int {
                                checkpointData[title] = existingPoints + points
                            } else {
                                checkpointData[title] = points
                            }
                        }
                    }
                }
                completion(.success(checkpointData))
            }
        }
    }
    
    func updateScore(ActivityTitle title: String, Score score: Int){
        let uid = Firebase.Auth.auth().currentUser?.uid
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        let query = db.collection("participant")
                      .whereField("date", isGreaterThanOrEqualTo: Timestamp(date: startOfDay))
                      .whereField("date", isLessThan: Timestamp(date: endOfDay))
                      .whereField("uid", isEqualTo: uid!)
        
        query.getDocuments { (querySnapshot, error) in
             if let error = error {
                 print("Error updating score: \(error.localizedDescription)")
                 return
             }
             
             guard let querySnapshot = querySnapshot else {
                 print("No documents found for the query")
                 return
             }
             
            if let document = querySnapshot.documents.first {
                let documentID = document.documentID
                
                // Retrieve the current score from the document
                var currentScore = document.data()["current_score"] as? Int ?? 0
                
                // Add the new score to the current score
                currentScore += score
                
                // Update the score field in the document
                document.reference.updateData(["current_score": currentScore, "last_update": Date()]) { (error) in
                    if let error = error {
                        print("Error updating score in document \(documentID): \(error.localizedDescription)")
                    } else {
                        print("Score updated successfully in document \(documentID)")
                    }
                }
                
                // Update the data in the checkpoints subcollection document
                self.db.collection("participant")
                    .document(documentID)
                    .collection("checkpoints")
                    .whereField("title", isEqualTo: title)
                    .getDocuments() { (querySnapshot, error) in
                        if let error = error {
                            print("Error retrieving checkpoints document: \(error.localizedDescription)")
                            return
                        }
                        
                        guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty else {
                            print("No checkpoints document found")
                            return
                        }
                        
                        let document = querySnapshot.documents[0]
                        let documentID = document.documentID
                        
                        document.reference.updateData([
                            "completed": true
                        ]) { (error) in
                            if let error = error {
                                print("Error updating checkpoints document \(documentID): \(error.localizedDescription)")
                            } else {
                                print("Checkpoints document updated successfully")
                            }
                        }
                    }
            } else {
                print("No documents found for the query")
            }
         }
    }
}
