//
//  UITableView+.swift
//  SixthSense
//
//  Created by Allie Kim on 2022/07/03.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit

extension UITableView {
    /// cell 등록
    func register<T: UITableViewCell>(
        cellType: T.Type,
        bundle: Bundle? = nil
    ) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellReuseIdentifier: className)
    }

    /// cell 여러개 등록
    func register<T: UITableViewCell>(
        cellTypes: [T.Type],
        bundle: Bundle? = nil
    ) {
        cellTypes.forEach { register(cellType: $0, bundle: bundle) }
    }

    /// cell 가져오기
    func dequeueReusableCell<T: UITableViewCell>(
        with type: T.Type,
        for indexPath: IndexPath
    ) -> T {
        return self.dequeueReusableCell(withIdentifier: type.className, for: indexPath) as! T
    }
}
