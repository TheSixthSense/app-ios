//
//  ChallengeCheckViewController+Image.swift
//  Challenge
//
//  Created by 문효재 on 2022/09/05.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import PhotosUI

// MARK: - Camera
extension ChallengeCheckViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            imageRelay.accept(image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ChallengeCheckViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let itemProvider = results.first?.itemProvider,
              itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
        
        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
            DispatchQueue.main.async {
                guard let image = image as? UIImage else { return }
                self?.imageRelay.accept(image)
            }
        }
    }
}
