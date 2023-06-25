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
    
    // check if the qr code exist
    func eventExists(atPath path: String, completion: @escaping (Bool) -> Void) {
        let qrCode = path.split(separator: "_")
        
        print("checking qr code: \(qrCode)")
        
        // activate the event
        if(qrCode[1] == "event"){
            
            print("activating event")
            
            let documentRef = db.collection("event").document(String(qrCode[0]))
            
            documentRef.getDocument { (document, error) in
                if let error = error {
                    print("Error getting document: \(error)")
                    completion(false)
                } else if let document = document, document.exists {
                    // Document exists, print its data
                    // print("Document data: \(document.data() ?? [:])")
                    self.addCheckPoint(eventCode: String(qrCode[0]), checkPointData: document.data()!["check_point"] as! [Dictionary<String, Any>])
                    completion(true)
                } else {
                    // Document does not exist
                    completion(false)
                }
            }
        } else if (qrCode[1] == "checkpoint") {
            print("activating checkpoint")
            
            let collectionRef = db.collection("participant")
            let uid = Firebase.Auth.auth().currentUser!.uid
            print(uid)
            print(qrCode[0])
            let query = collectionRef
                .whereField("event_code", isEqualTo: qrCode[0])
                .whereField("uid", isEqualTo: uid)
            query.getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching documents: \(error)")
                    completion(false)
                } else {
                    if let document = snapshot?.documents.first {
                        print("try updating checkpoint")
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
                                            print("Checkpoint activated")
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
    
    // add the checkpoints
    func addCheckPoint(eventCode code: String, checkPointData checkpoints: [Dictionary<String, Any>]) {
        let collectionRef = db.collection("participant")
        let uid = Firebase.Auth.auth().currentUser?.uid
        let query = collectionRef.whereField("event_code", isEqualTo: code)
                                 .whereField("uid", isEqualTo: uid!)
        
        query.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error)")
            } else {
                if let snapshot = snapshot, !snapshot.isEmpty {
                    // Document already exists for this event and user
                    print("Document already exists")
                } else {
                    // Document does not exist, add new document
                    let documentRef = collectionRef.document()
                    
                    let data: [String: Any] = [
                        "current_score": 0,
                        "event_code": code,
                        "date": Date(),
                        "uid": uid!,
                        "last_update": Date()
                    ]
                    
                    documentRef.setData(data) { error in
                        if let error = error {
                            print("Error adding document: \(error)")
                        } else {
                            print("Document added successfully")
                            
                            // Add subcollection to new document
                            let subcollectionRef = documentRef.collection("checkpoints")
                            for checkpoint in checkpoints {
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
    
    func getCheckpointData(completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let uid = Firebase.Auth.auth().currentUser?.uid
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        let query = db.collection("participant")
                      .whereField("date", isGreaterThanOrEqualTo: Timestamp(date: startOfDay))
                      .whereField("date", isLessThan: Timestamp(date: endOfDay))
                      .whereField("uid", isEqualTo: uid!)
        query.getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let document = snapshot?.documents.first else {
                let error = NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Document not found"])
                completion(.failure(error))
                return
            }

            let participantData = document.data()
            let checkpointRef = self.db.collection("participant").document(document.documentID).collection("checkpoints")
            checkpointRef.getDocuments { (snapshot, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                var checkpointDataArray: [[String: Any]] = []
                for document in snapshot!.documents {
                    let checkpointData = document.data()
                    checkpointDataArray.append(checkpointData)
                }

                var data = participantData
                data["checkpoints"] = checkpointDataArray
                completion(.success(data))
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
