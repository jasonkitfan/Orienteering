//
//  CheckpointView.swift
//  Orienteering
//
//  Created by Kit Fan Cheung on 15/6/2023.
//

import SwiftUI

struct CheckpointView: View {
    @State private var expandedItem: UUID?
    @State private var checkpointItems = [CheckpointItem]()

    
    private func getCheckpoints() {
        let firestoreManager = FirestoreManager()
        firestoreManager.getCheckpointData { result in
            switch result {
            case .success(let data):
                // Use the retrieved document data here
                print("checkpoint data: \(data["checkpoints"]!)")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    let items = [
        CheckpointItem(title: "Item 1", description: "Description for item 1", hasImage: true),
        CheckpointItem(title: "Item 2", description: "Description for item 2", hasImage: false),
        CheckpointItem(title: "Item 3", description: "Description for item 3", hasImage: false),
        CheckpointItem(title: "Item 4", description: "Description for item 4", hasImage: true),
    ]

    var body: some View {
        VStack {
            List(items) { item in
                switch item.hasImage {
                case true:
                    ImageItemView(item: item, expandedItem: $expandedItem)
                case false:
                    TextItemView(item: item, expandedItem: $expandedItem)
                }
            }
        }.onAppear{
            getCheckpoints()
        }
    }
}

struct TextItemView: View {
    let item: CheckpointItem
    @Binding var expandedItem: UUID?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(item.title)
                .font(.headline)
            if expandedItem == item.id {
                Text(item.description)
            }
        }
        .padding()
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.5)) {
                if expandedItem == item.id {
                    expandedItem = nil
                } else {
                    expandedItem = item.id
                }
            }
        }
    }
}

struct ImageItemView: View {
    let item: CheckpointItem
    @Binding var expandedItem: UUID?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(item.title)
                .font(.headline)
            if expandedItem == item.id {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                Text(item.description)
            }
        }
        .padding()
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.5)) {
                if expandedItem == item.id {
                    expandedItem = nil
                } else {
                    expandedItem = item.id
                }
            }
        }
    }
}

struct CheckpointView_Previews: PreviewProvider {
    static var previews: some View {
        CheckpointView()
    }
}
