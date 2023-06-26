//
//  NumberInputView.swift
//  Orienteering
//
//  Created by Kit Fan Cheung on 25/6/2023.
//

import SwiftUI

struct NumberInputView: View {
    @Binding var item: CheckpointInfo
    @Environment(\.presentationMode) var presentationMode
    @State private var number: Int = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(item.title)
                .font(.title)
                .foregroundColor(.blue)
            Text(item.description)
                .font(.headline)
                .foregroundColor(.gray)
            TextField("Enter a whole number", value: $number, formatter: NumberFormatter(), onEditingChanged: { _ in }, onCommit: {})
                .keyboardType(.numberPad)
                .font(.title2)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
            Button(action: {
                print("Your answer is \(number)")
                let manager = FirestoreManager()
                manager.updateScore(ActivityTitle: item.title, Score: number == item.answer ? item.point: 0)
                item.completed = true
                self.presentationMode.wrappedValue.dismiss() // Dismiss the view
            }) {
                Text("Submit")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
            }
            if number == 0 {
                Text("Please enter a number")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 5)
        .padding()
    }
}

//struct NumberInputView_Previews: PreviewProvider {
//    static var previews: some View {
//        NumberInputView()
//    }
//}
