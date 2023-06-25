//
//  ImageView.swift
//  Orienteering
//
//  Created by Kit Fan Cheung on 25/6/2023.
//

import SwiftUI

struct ImageView: View {
    @State private var image: UIImage?
    @State private var isShowingImagePicker = false

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
                            submitImage()
                        }) {
                            Text("Submit")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.blue)
                                .cornerRadius(10)
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
            .navigationBarTitle("Image View")
        }
    }
    
    func submitImage() {
        guard let selectedImage = image else {
            return
        }
        // Process the selected image here
        print("Selected image: \(selectedImage)")
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView()
    }
}
