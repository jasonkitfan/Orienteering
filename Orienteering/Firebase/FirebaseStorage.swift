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
        guard let selectedImage = image else { // Check if an image has been selected
            completion(.failure(NSError(domain: "com.yourdomain.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "No image selected"]))) // If no image has been selected, return an error
            return
        }
        
        let storageRef = Storage.storage().reference() // Get a reference to the Firebase Storage
        let imagesRef = storageRef.child("images") // Get a reference to the "images" folder in Firebase Storage
        let imageName = UUID().uuidString // Generate a unique identifier for the image file
        let imageRef = imagesRef.child("\(imageName).jpg") // Create a reference to the image file in Firebase Storage
        
        if let imageData = selectedImage.jpegData(compressionQuality: 0.8) { // Convert the selected image to JPEG data with a compression quality of 0.8
            let metadata = StorageMetadata() // Create metadata for the image
            metadata.contentType = "image/jpeg" // Set the content type of the image
            imageRef.putData(imageData, metadata: metadata) { (metadata, error) in // Upload the image data to Firebase Storage
                if let error = error { // If there is an error, return the error
                    completion(.failure(error))
                    return
                }
                
                // Get download URL of uploaded image
                imageRef.downloadURL { (url, error) in // Get the download URL of the uploaded image
                    if let url = url { // If a URL is returned, shorten it using the TinyURL API
                        let tinyURLAPIEndpoint = "https://tinyurl.com/api-create.php?"
                        let queryParameters = "url=\(url.absoluteString)"
                        let tinyURLAPIURL = URL(string: "\(tinyURLAPIEndpoint)\(queryParameters)")
                        if let tinyURL = try? String(contentsOf: tinyURLAPIURL!) { // If the URL is successfully shortened, return the shortened URL
                            let shortenedURL = URL(string: tinyURL)
                            completion(.success(shortenedURL!))
                        } else { // If there is an error shortening the URL, return an error
                            completion(.failure(NSError(domain: "com.yourdomain.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error shortening URL"])))
                        }
                    } else if let error = error { // If there is an error getting the URL, return the error
                        completion(.failure(error))
                    } else { // If an unknown error occurs, return an error
                        completion(.failure(NSError(domain: "com.yourdomain.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
                    }
                }
            }
        } else { // If there is an error converting the image to data, return an error
            completion(.failure(NSError(domain: "com.yourdomain.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error converting image to data"])))
        }
    }
}
