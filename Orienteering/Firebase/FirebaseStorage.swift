//
//  FirebaseStorage.swift
//  Orienteering
//
//  Created by Kit Fan Cheung on 25/6/2023.
//

import FirebaseStorage
import SwiftUI

class FirebaseStorageManager {
    func submitImage(Image image: UIImage?, completion: @escaping ((Result<URL, Error>) -> Void)) {
        guard let selectedImage = image else {
            completion(.failure(NSError(domain: "com.yourdomain.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "No image selected"])))
            return
        }
        
        let storageRef = Storage.storage().reference()
        let imagesRef = storageRef.child("images")
        let imageName = UUID().uuidString
        let imageRef = imagesRef.child("\(imageName).jpg")
        
        if let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            imageRef.putData(imageData, metadata: metadata) { (metadata, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                // Get download URL of uploaded image
                imageRef.downloadURL { (url, error) in
                    if let url = url {
                        // Shorten the URL using the TinyURL API
                        let tinyURLAPIEndpoint = "https://tinyurl.com/api-create.php?"
                        let queryParameters = "url=\(url.absoluteString)"
                        let tinyURLAPIURL = URL(string: "\(tinyURLAPIEndpoint)\(queryParameters)")
                        if let tinyURL = try? String(contentsOf: tinyURLAPIURL!) {
                            let shortenedURL = URL(string: tinyURL)
                            completion(.success(shortenedURL!))
                        } else {
                            completion(.failure(NSError(domain: "com.yourdomain.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error shortening URL"])))
                        }
                    } else if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.failure(NSError(domain: "com.yourdomain.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
                    }
                }
            }
        } else {
            completion(.failure(NSError(domain: "com.yourdomain.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error converting image to data"])))
        }
    }
}
