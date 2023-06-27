//
//  Zyla.swift
//  Orienteering
//
//  Created by Kit Fan Cheung on 26/6/2023.
//

import SwiftUI

struct ZylaCatBreedIdentification {
    
    // Identifies a cat's breed using the specified image URL and calls the completion handler with the results.
    func identifyCatWithImageUrl(imageUrl: URL, completionHandler: @escaping (([[String: Any]]?) -> Void)) {
        let url = URL(string: zylaEndPoint)!
        
        // Create a new POST request with the Zyla API endpoint URL and set the request headers.
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(zylaApiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create a dictionary with the image URL as a parameter and set it as the request body.
        let parameters = ["url": imageUrl.absoluteString]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        // Send the request using URLSession.shared.dataTask() and process the response in the closure.
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP response status code: \(httpResponse.statusCode)")
            }
            
            // If response data is received, attempt to parse it as JSON and extract the "results" array. Call the completion handler with the results array or nil if an error occurs.
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let dictionary = json as? [String: Any], let results = dictionary["results"] as? [[String: Any]] {
                    completionHandler(results)
                } else {
                    completionHandler(nil)
                }
            // If an error occurs, print an error message to the console and call the completion handler with nil to indicate an error.
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
                completionHandler(nil)
            } else {
                print("Unexpected error")
                completionHandler(nil)
            }
        }.resume()
    }
}
