//
//  AppFont.swift
//  CommonUI
//
//  Created by Allie Kim on 2022/07/10.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit

public typealias AppFont = CommonUIFontFamily

extension AppFont {

    // TODO: - 브랜드 로고 폰트 사이즈 추가

    /// 12px
    public static var caption: UIFont {
        return UIFont(font: AppFont.Pretendard.regular, size: 12)!
    }

    /// 12px
    public static var captionBold: UIFont {
        return UIFont(font: AppFont.Pretendard.bold, size: 12)!
    }

    /// 14px
    public static var body2: UIFont {
        return UIFont(font: AppFont.Pretendard.regular, size: 14)!
    }

    /// 14px
    public static var body2Bold: UIFont {
        return UIFont(font: AppFont.Pretendard.bold, size: 14)!
    }

    /// 16px
    public static var body1: UIFont {
        return UIFont(font: AppFont.Pretendard.regular, size: 16)!
    }

    /// 16px
    public static var body1Bold: UIFont {
        return UIFont(font: AppFont.Pretendard.bold, size: 16)!
    }

    /// 20px
    public static var subtitle: UIFont {
        return UIFont(font: AppFont.Pretendard.regular, size: 20)!
    }

    /// 20px
    public static var subtitleBold: UIFont {
        return UIFont(font: AppFont.Pretendard.bold, size: 20)!
    }

    /// 24px
    public static var title2: UIFont {
        return UIFont(font: AppFont.Pretendard.regular, size: 24)!
    }

    /// 24px
    public static var title2Bold: UIFont {
        return UIFont(font: AppFont.Pretendard.bold, size: 24)!
    }

    /// 28px
    public static var title1: UIFont {
        return UIFont(font: AppFont.Pretendard.regular, size: 28)!
    }


    /// 28px
    public static var title1Bold: UIFont {
        return UIFont(font: AppFont.Pretendard.bold, size: 28)!
    }

    /// 32px
    public static var largeTitle: UIFont {
        return UIFont(font: AppFont.Pretendard.regular, size: 32)!
    }

    /// 32px
    public static var largeTitleBold: UIFont {
        return UIFont(font: AppFont.Pretendard.bold, size: 32)!
    }
}
