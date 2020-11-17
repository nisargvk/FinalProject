//
//  ImagePicker.swift
//  meetups
//
//  Created by Mac on 08.11.2020.
//

import Foundation
import SwiftUI

struct ImagePicker : UIViewControllerRepresentable {
    class ImagePickerCordinator : NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
        @Binding var isShown: Bool
        @Binding var isSelected: Bool
        @Binding var image: UIImage?
        
        init(isShown: Binding<Bool>, isSelected: Binding<Bool>, image: Binding<UIImage?>) {
            self._isShown = isShown
            self._isSelected = isSelected
            self._image = image
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            isShown = false
            isSelected = true
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isShown = false
        }
    }
    
    @Binding var isShown: Bool
    @Binding var isSelected: Bool
    @Binding var image: UIImage?
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {}
    
    func makeCoordinator() -> ImagePickerCordinator {
        return ImagePickerCordinator(isShown: $isShown, isSelected: $isSelected, image: $image)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()

        picker.delegate = context.coordinator

        return picker
    }
}
