//
//  AppFont.swift
//  CommonUI
//
//  Created by Allie Kim on 2022/07/10.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

public typealias AppFont = CommonUIFontFamily

extension AppFont {

    public static var bold: CommonUIFontConvertible {
        return AppFont.Pretendard.bold
    }

    public static var regular: CommonUIFontConvertible {
        return AppFont.Pretendard.regular
    }
}
