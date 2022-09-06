//
//  ChallengeCheckViewController+Keyboard.swift
//  Challenge
//
//  Created by 문효재 on 2022/09/05.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Keyboard
extension ChallengeCheckViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        hideKeyboard()
    }
    
    private func hideKeyboard() {
        self.commentField.inputArea.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                return
        }
        
        scrollView.do {
          $0.contentInset.bottom = keyboardFrame.size.height
          $0.scrollRectToVisible(commentHeaderLabel.frame, animated: true)
        }
    }

    @objc func keyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
}
