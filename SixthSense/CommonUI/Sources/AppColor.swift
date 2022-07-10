//
//  AppColor.swift
//  CommonUI
//
//  Created by Allie Kim on 2022/07/10.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit

public typealias AppColor = UIColor

extension AppColor {

    // MARK: - Main Color: Green

    public static var main: AppColor {
        return #colorLiteral(red: 0.4078431427, green: 0.7333333492, blue: 0.4941176176, alpha: 1)
    }

    public static var green100: AppColor {
        return #colorLiteral(red: 0.850980401, green: 0.9411764741, blue: 0.8745098114, alpha: 1)
    }

    public static var green300: AppColor {
        return #colorLiteral(red: 0.631372549, green: 0.8470588235, blue: 0.6862745098, alpha: 1)
    }

    public static var green700: AppColor {
        return #colorLiteral(red: 0.2941176471, green: 0.5529411765, blue: 0.3607843137, alpha: 1)
    }

    // MARK: - Sub Color: Brown

    public static var sub100: AppColor {
        return #colorLiteral(red: 0.9882352941, green: 0.9843137255, blue: 0.9568627451, alpha: 1)
    }

    public static var sub300: AppColor {
        return #colorLiteral(red: 0.9607843137, green: 0.9490196078, blue: 0.8431372549, alpha: 1)
    }

    public static var sub500: AppColor {
        return #colorLiteral(red: 0.8745098039, green: 0.862745098, blue: 0.768627451, alpha: 1)
    }

    public static var sub700: AppColor {
        return #colorLiteral(red: 0.6117647059, green: 0.6, blue: 0.5215686275, alpha: 1)
    }

    // MARK: - Sub Color 2

    public static var yellow500: AppColor {
        return #colorLiteral(red: 1, green: 0.8745098039, blue: 0.4941176471, alpha: 1)
    }

    public static var orange500: AppColor {
        return #colorLiteral(red: 0.9725490196, green: 0.6588235294, blue: 0.3294117647, alpha: 1)
    }

    public static var red500: AppColor {
        return #colorLiteral(red: 0.9647058824, green: 0.3215686275, blue: 0.3215686275, alpha: 1)
    }

    static var purple500: AppColor {
        return #colorLiteral(red: 0.5725490196, green: 0.3411764706, blue: 0.862745098, alpha: 1)
    }

    public static var blue500: AppColor {
        return #colorLiteral(red: 0.2549019608, green: 0.431372549, blue: 0.7568627451, alpha: 1)
    }

    // MARK: - System gray

    public static var systemGray100: AppColor {
        return #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.968627451, alpha: 1)
    }

    public static var systemGray300: AppColor {
        return #colorLiteral(red: 0.8862745098, green: 0.8901960784, blue: 0.8745098039, alpha: 1)
    }

    public static var systemGray500: AppColor {
        return #colorLiteral(red: 0.6352941176, green: 0.6392156863, blue: 0.6235294118, alpha: 1)
    }

    public static var systemGray700: AppColor {
        return #colorLiteral(red: 0.4196078431, green: 0.4196078431, blue: 0.4117647059, alpha: 1)
    }

    public static var systemGray900: AppColor {
        return #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2705882353, alpha: 1)
    }

    public static var black: AppColor {
        return #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1)
    }
}

