//
//  CheckpointView.swift
//  Orienteering
//
//  Created by Kit Fan Cheung on 15/6/2023.
//

import SwiftUI
import Combine

struct CheckpointView: View {
    @State private var expandedItem: UUID?
    @State var checkpoints: [CheckpointInfo] = []

    private func getCheckpoints(completion: @escaping () -> Void) {
        let firestoreManager = FirestoreManager()
        firestoreManager.getCheckpointData { result in
            switch result {
            case .success(let data):
                // Use the retrieved document data here
                if let locations = data["checkpoints"] as? [[String: Any]] {
                    var checkpointLocations: [CheckpointInfo] = []
                    for checkpointData in locations {
                        if let title = checkpointData["title"] as? String,
                           let description = checkpointData["description"] as? String,
                           let format = checkpointData["format"] as? String,
                           let activated = checkpointData["activated"] as? Bool,
                           let completed = checkpointData["completed"] as? Bool,
                           let point = checkpointData["point"] as? Int {
                            var answer: Int?
                            var questionSet: [[String: Any]]? = []
                            var targetBreed: String?
                            if(activated == true){
                                if(format == "integer_input_field"){
                                    answer = (checkpointData["answer"] as? Int)!
                                } else if(format == "quiz"){
                                    questionSet = (checkpointData["question_set"] as? [[String: Any]])!
                                } else if(format == "image_recognition"){
                                    targetBreed = checkpointData["targeted_breed"] as? String
                                }
                            }
                            let checkpoint = CheckpointInfo(title: title, description: description, point: point, format: format, activated: activated, answer: answer, questionSet: questionSet, targetBreed: targetBreed, completed: completed)
//                            print(checkpoint)
                            checkpointLocations.append(checkpoint)
                        } else {
                            print("Error: Checkpoint data is missing or invalid")
                        }
                    }
                    self.checkpoints = checkpointLocations
//                    print("final checkpoint: \(checkpoints)")
                    completion() // Call the completion handler once the data is retrieved
                } else {
                    print("Checkpoints not found in data")
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    var body: some View {
        List(checkpoints, id: \.id) { checkpoint in
            CheckpointRowInfo(item: checkpoint, expandedItem: $expandedItem)
            }.onAppear{
            getCheckpoints {
//                for checkpoint in checkpoints {
//                    print("check point view: \(checkpoint)")
//
//                }
            }
            }
    }
}

struct CheckpointView_Previews: PreviewProvider {
    static var previews: some View {
        CheckpointView()
    }
}
