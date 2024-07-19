//
//  ContentView.swift
//  RemoveBackground
//
//  Created by Trần Ân on 3/5/24.
//

import SwiftUI
import Vision
import CoreImage.CIFilterBuiltins
import PhotosUI

struct ContentView: View {
//    @State private var image = UIImage.cat
//    @State private var isLoading: Bool = false
    @State private var oriImage: UIImage?
//
//    var body: some View {
            
    @State private var avatarItem: PhotosPickerItem?
    @State private var image: UIImage? // Change to UIImage

    var body: some View {
        VStack {
            PhotosPicker("Select avatar", selection: $avatarItem, matching: .images)

            if let avatarImage = image { // Display if available
                Image(uiImage: avatarImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 500, height: 500)
            }
            
            VStack {
                VStack {
                    HStack {
                        Button("Create mask") {
                            createMask()
                        }
                        Button("Create a sticker") {
                            createSticker()
                        }
                    }
                    Button("Return to original") {
                        image = oriImage
                    }
                }
                
            }
            .padding()
        }
        .onChange(of: avatarItem) { newItem in // Update for newItem
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    self.image = image
                    self.oriImage = image
                } else {
                    print("Failed")
                }
            }
        }
    }
    

    // MARK: - Private
    private func createMask() {
        if (image != nil) {
            guard let processedImage = createMaskFromImage(fromImage: image!) else {
                print("error creat mask")
                return
            }
            let finalimage = renderFromCItoUI(ciImage: processedImage)
            self.image = finalimage
        }
        
    }
    
    private func createSticker() {
        if (image != nil) {
            guard let createCIimage = CIImage(image: image!) else {
                print("Can not create CI Image")
                return
            }
            guard let processedImage = createMaskFromImage(fromImage: image!) else {
                print("error creat mask")
                return
            }
            let image = applyFromMaskToImage(maskImage: processedImage, to: createCIimage)
            self.image = renderFromCItoUI(ciImage: image)
        }
        
    }
}

#Preview {
    ContentView()
}
