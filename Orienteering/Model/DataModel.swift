//
//  CheckpointLocationModel.swift
//  Orienteering
//
//  Created by Kit Fan Cheung on 25/6/2023.
//

import Foundation

struct CheckpointInfo: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let point: Int
    let format: String
    let activated: Bool
    let answer: Int?
    let questionSet: [[String: Any]]?
    let targetBreed: String?
    var completed: Bool?
}

struct CheckpointLocation {
    let title: String
    let latitude: Double
    let longitude: Double
    let point: Int
}
