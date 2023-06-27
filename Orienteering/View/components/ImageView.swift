//
//  ImageView.swift
//  Orienteering
//
//  Created by Kit Fan Cheung on 25/6/2023.
//

import SwiftUI

struct ImageView: View {
    @Binding var item: CheckpointInfo
    @State private var image: UIImage?
    @State private var isShowingImagePicker = false
    @Environment(\.presentationMode) var presentationMode
    @State private var isSubmitting = false
    @State private var refreshId = UUID() // Add a refresh identifier

    var body: some View {
        NavigationView {
            Group {
                if let image = image {
                    VStack {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                        Button(action: {
                            Task {
                                await submitImage()
                            }
                        }) {
                            if isSubmitting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 50)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                            } else {
                                Text("Submit")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.top, 10)
                    }
                } else {
                    VStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.5))
                            .aspectRatio(contentMode: .fit)
                            .padding()
                        NavigationLink(destination: ImagePicker(image: $image), isActive: $isShowingImagePicker) {
                            Text("Select Image")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.top, 10)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 5)
            .navigationBarTitle("Breed: \(item.targetBreed ?? "unknown")")
            .id(refreshId) // Use the refresh identifier
        }
    }
    
    func submitImage() async {
        guard let selectedImage = image else {
            return
        }
        isSubmitting = true
        let manager = FirebaseStorageManager()
        manager.submitImage(Image: selectedImage) { result in
            switch result {
            case .success(let url):
                // Use the URL of the uploaded image
                print("Image uploaded successfully. URL: \(url)")
                let zyla = ZylaCatBreedIdentification()
                zyla.identifyCatWithImageUrl(imageUrl: url) { responseDict in
                    if let responseDict = responseDict {
                        // Do something with the cat breed identification data
                        print(responseDict)
                        let labelArray = responseDict.map { $0["label"] as! String } // Extract label values from responseDict
                        let labelsString = labelArray.joined(separator: " ") // Join label values into a single string separated by spaces
                        print(labelsString) // Output: "Siamese cat, Siamese Egyptian cat tabby, tabby cat lynx, catamount Persian cat"
                      
                        let cat = item.targetBreed
                        let isCorrectCat = labelsString.lowercased().contains(cat!.lowercased()) // Check if cat is present in labelsString (case-insensitive)
                        print(isCorrectCat) // Output: true
                        
                        let manager = FirestoreManager()
                        manager.updateScore(ActivityTitle: item.title, Score: isCorrectCat ? item.point : 0)
                    } else {
                        // Handle the error
                        print("Error: Unable to identify cat breed")
                    }
                    exitView()
                }
            case .failure(let error):
                // Handle the error
                print("Error uploading image: \(error.localizedDescription)")
                exitView()
            }
        }
    }
    
    func exitView(){
        DispatchQueue.main.async {
            isSubmitting = false
            refreshId = UUID() // Update the refresh identifier
            item.completed = true
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

//struct ImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageView()
//    }
//}
