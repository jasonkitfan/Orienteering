//
//  CheckpointLocationModel.swift
//  Orienteering
//
//  Created by Kit Fan Cheung on 25/6/2023.
//

import Foundation

struct CheckpointItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let hasImage: Bool
}

struct CheckpointLocation {
    let title: String
    let latitude: Double
    let longitude: Double
}
