//
//  UICollectionView+.swift
//  Home
//
//  Created by 문효재 on 2022/08/04.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import UIKit

//open func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String)
extension UICollectionView {
    func register(_ cellClass: AnyClass) {
        register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass))
    }

    func dequeue(_ cellClass: AnyClass, for indexPath: IndexPath) -> UICollectionViewCell {
        return dequeueReusableCell(withReuseIdentifier: String(describing: cellClass), for: indexPath)
    }
}

extension UITableView {
    func register(_ cellClass: AnyClass) {
        register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
    }

    func dequeue(_ cellClass: AnyClass, for indexPath: IndexPath) -> UITableViewCell {
        return dequeueReusableCell(withIdentifier: String(describing: cellClass), for: indexPath)
    }
}
