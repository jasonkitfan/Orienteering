//
//  Zyla.swift
//  Orienteering
//
//  Created by Kit Fan Cheung on 26/6/2023.
//

import SwiftUI

struct ZylaCatBreedIdentification {
    func identifyCatWithImageUrl(imageUrl: URL, completionHandler: @escaping (([[String: Any]]?) -> Void)) {
        let url = URL(string: zylaEndPoint)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(zylaApiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters = ["url": imageUrl.absoluteString]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP response status code: \(httpResponse.statusCode)")
            }
            
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let dictionary = json as? [String: Any], let results = dictionary["results"] as? [[String: Any]] {
                    // Call the completion handler with just the results array
                    completionHandler(results)
                } else {
                    // Call the completion handler with nil to indicate an error
                    completionHandler(nil)
                }
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
                // Call the completion handler with nil to indicate an error
                completionHandler(nil)
            } else {
                print("Unexpected error")
                // Call the completion handler with nil to indicate an error
                completionHandler(nil)
            }
        }.resume()
    }
}
