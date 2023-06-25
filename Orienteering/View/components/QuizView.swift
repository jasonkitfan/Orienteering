//
//  QuizView.swift
//  Orienteering
//
//  Created by Kit Fan Cheung on 25/6/2023.
//

import SwiftUI

struct QuizView: View {
    let item: CheckpointInfo
    @State private var currentQuestion = 0
    @State private var selectedAnswer: Bool?
    @State private var totalScore = 0
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("\(item.questionSet?[currentQuestion]["question"] as? String ?? "")")
                .font(.system(size: 20))
                .multilineTextAlignment(.center)
                .padding()
            HStack {
                Button(action: {
                    selectedAnswer = true
                    let isCorrect = selectedAnswer == item.questionSet![currentQuestion]["answer"] as? Bool
                    totalScore += isCorrect ? 1 : 0
                    advanceToNextQuestion()
                }) {
                    Text("True")
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .disabled(selectedAnswer != nil)
                .padding(.trailing, 10)
                Button(action: {
                    selectedAnswer = false
                    let isCorrect = selectedAnswer == item.questionSet![currentQuestion]["answer"] as? Bool
                    totalScore += isCorrect ? 1 : 0
                    advanceToNextQuestion()
                }) {
                    Text("False")
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .disabled(selectedAnswer != nil)
                .padding(.leading, 10)
            }
            .padding(.top, 20)
        }
        .navigationBarTitle("Quiz")
    }
    
    func advanceToNextQuestion() {
        selectedAnswer = nil
        if currentQuestion < (item.questionSet?.count ?? 0) - 1 {
            currentQuestion += 1
        } else {
            let finalScore = item.point / item.questionSet!.count * totalScore
            print("current score: \(finalScore)")
            let manager = FirestoreManager()
            manager.updateScore(ActivityTitle: item.title, Score: finalScore)
            presentationMode.wrappedValue.dismiss()
        }
    }
}

//struct QuizView_Previews: PreviewProvider {
//    static var previews: some View {
//        QuizView()
//    }
//}
