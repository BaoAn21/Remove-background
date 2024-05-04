//
//  ContentView.swift
//  RemoveBackground
//
//  Created by Trần Ân on 3/5/24.
//

import SwiftUI
import Vision
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var image = UIImage.cat
    @State private var isLoading: Bool = false
    private var oriImage: UIImage = UIImage.cat
    
    var body: some View {
            VStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
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

    // MARK: - Private
    private func createMask() {
        guard let processedImage = createMaskFromImage(fromImage: image) else {
            print("error creat mask")
            return
        }
        let image = renderFromCItoUI(ciImage: processedImage)
        self.image = image
    }
    
    private func createSticker() {
        guard let createCIimage = CIImage(image: image) else {
            print("Can not create CI Image")
            return
        }
        guard let processedImage = createMaskFromImage(fromImage: image) else {
            print("error creat mask")
            return
        }
        let image = applyFromMaskToImage(maskImage: processedImage, to: createCIimage)
        self.image = renderFromCItoUI(ciImage: image)
    }
}

#Preview {
    ContentView()
}
