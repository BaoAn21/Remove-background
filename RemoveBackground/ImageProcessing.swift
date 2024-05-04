//
//  ConvertImage.swift
//  RemoveBackground
//
//  Created by Trần Ân on 3/5/24.
//

import Foundation
import SwiftUI
import CoreImage
import Vision


// Create CIImage from UIImage

func applyFromMaskToImage(maskImage: CIImage, to image: CIImage) -> CIImage {
    let filter = CIFilter.blendWithMask()
    filter.inputImage = image
    filter.maskImage = maskImage
    filter.backgroundImage = CIImage.empty()
    return filter.outputImage!
}

func renderFromCItoUI(ciImage: CIImage) -> UIImage {
    guard let cgImage = CIContext(options: nil).createCGImage(ciImage, from: ciImage.extent) else {
        fatalError("Failed to render CGImage")
    }
    return UIImage(cgImage: cgImage)
}


func createMaskFromImage(fromImage: UIImage) -> CIImage? {
    guard let image = CIImage(image: fromImage) else {
        print("Can not create CI Image")
        return nil
    }
    
    let handler = VNImageRequestHandler(ciImage: image)
    let request = VNGenerateForegroundInstanceMaskRequest()
    
    do {
        try handler.perform([request])
    } catch {
        print(error)
        return nil
    }
    
    guard let result = request.results?.first else {
        print("No object found")
        return nil
    }
    
    do {
        let maskPixelBuffer = try result.generateScaledMaskForImage(forInstances: result.allInstances, from: handler)
        return CIImage(cvImageBuffer: maskPixelBuffer)
    } catch {
        print(error)
        return nil
    }
}


