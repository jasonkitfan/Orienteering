//
//  SupportView.swift
//  Orienteering
//
//  Created by Kit Fan Cheung on 15/6/2023.
//

import SwiftUI

struct SupportView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Need Help?")
                .font(.title)
                .fontWeight(.bold)
            
            Text("If you are feeling lost or have questions about how to play, please refer to the following resources:")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "book.circle.fill")
                        .foregroundColor(.blue)
                        .font(.system(size: 24))
                    Text("Game Rules")
                        .fontWeight(.bold)
                    Spacer()
                    Image(systemName: "arrow.forward.circle")
                        .foregroundColor(.gray)
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "questionmark.circle.fill")
                        .foregroundColor(.orange)
                        .font(.system(size: 24))
                    Text("FAQs")
                        .fontWeight(.bold)
                    Spacer()
                    Image(systemName: "arrow.forward.circle")
                        .foregroundColor(.gray)
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "message.circle.fill")
                        .foregroundColor(.green)
                        .font(.system(size: 24))
                    Text("Contact Support")
                        .fontWeight(.bold)
                    Spacer()
                    Image(systemName: "arrow.forward.circle")
                        .foregroundColor(.gray)
                }
            }
            
            Text("If you have an injury or emergency, please follow these steps before contacting staff:")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("1. Stop playing immediately.")
                Text("2. Assess the injury or emergency.")
                Text("3. If necessary, call 999 or seek medical attention.")
                Text("4. Alert a staff member as soon as possible.")
            }
            Spacer()
        }
        .padding(16)
    }
}

struct SupportView_Previews: PreviewProvider {
    static var previews: some View {
        SupportView()
    }
}
