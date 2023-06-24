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
        let documentRef = db.collection("event").document(path)
        
        documentRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting document: \(error)")
                completion(false)
            } else if let document = document, document.exists {
                // Document exists, print its data
                print("Document data: \(document.data() ?? [:])")
                self.addCheckPoint(eventCode: path, checkPointData: document.data()!["check_point"] as! [Dictionary<String, Any>])
                completion(true)
            } else {
                // Document does not exist
                completion(false)
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
    
}
