//
//  CheckpointRowInfo.swift
//  Orienteering
//
//  Created by Kit Fan Cheung on 25/6/2023.
//

import SwiftUI

struct CheckpointRowInfo: View {
    @State var item: CheckpointInfo
    @Binding var expandedItem: UUID?
    
    var body: some View {
        DisclosureGroup(
            isExpanded: Binding<Bool>(
                get: { expandedItem == item.id },
                set: { isExpanded in
                    if isExpanded {
                        expandedItem = item.id
                    } else {
                        expandedItem = nil
                    }
                }
            ),
            content: {
                VStack(alignment: .leading) {
                    Text(item.description)
                        .foregroundColor(Color.gray)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                    HStack {
                        Spacer() // push the button to the right
                        
                        if(item.activated && item.completed != true){
                            NavigationLink(destination: ActivityView(item: $item)) {
                            }.opacity(0.0)
                        }
                        
                        Text(item.completed != true ? "Start": "Completed")
                            .foregroundColor(Color.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(item.completed != true ? item.activated == true  ? Color.blue : Color.gray : Color.gray)
                            .cornerRadius(10)
                    }
                }
            },
            label: {
                Text(item.title)
                    .font(.headline)
                    .foregroundColor(Color.black)
            }
        )
        .padding()
        .contentShape(Rectangle())
    }
}

//struct CheckpointRowInfo_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckpointRowInfo()
//    }
//}
