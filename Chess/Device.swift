//
//  Device.swift
//  Chess
//
//  Created by Devin Leamy on 2020-04-04.
//  Copyright © 2020 Devin Leamy. All rights reserved.
//

import Foundation
import UIKit

class Device {
	
	static let baseWidth : CGFloat = 414 //Width in points of Iphone 11 screen
	static let baseHeight : CGFloat = 896 //Hight in points of Iphone 11 screen

	static var widthRatio: CGFloat {
		return UIScreen.main.bounds.width / baseWidth
	}
	
	static var heightRatio : CGFloat {
		return UIScreen.main.bounds.height / baseHeight
	}
}

extension CGFloat {
	var adjustedWidth: CGFloat {
		return self * Device.widthRatio
	}
	var adjustedHeight: CGFloat {
		return self * Device.heightRatio
	}
}
extension Double {
	var adjustedWidth: CGFloat {
		return CGFloat(self) * Device.widthRatio
	}
	var adjustedHeight: CGFloat {
		return CGFloat(self) * Device.heightRatio
	}
}
extension Int {
	var adjustedWidth: CGFloat {
		return CGFloat(self) * Device.widthRatio
	}
	var adjustedHeight: CGFloat {
		return CGFloat(self) * Device.heightRatio
	}
}
