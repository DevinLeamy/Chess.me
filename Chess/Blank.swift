//
//  Blank.swift
//  Chess
//
//  Created by Devin Leamy on 2020-03-19.
//  Copyright © 2020 Devin Leamy. All rights reserved.
//

import Foundation

class Blank: Piece {
	override init(currentRow: Int, currentCol: Int, side: Side, type: Pieces) {
		super.init(currentRow: currentRow, currentCol: currentCol, side: side, type: type)
	}
}

