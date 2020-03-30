//
//  File.swift
//  Chess
//
//  Created by Devin Leamy on 2020-03-19.
//  Copyright © 2020 Devin Leamy. All rights reserved.
//

import Foundation

class Knight: Piece {
	override init(currentRow: Int, currentCol: Int, side: Side, type: Pieces) {
		super.init(currentRow: currentRow, currentCol: currentCol, side: side, type: type)
	}
	override func setNextMoves(board: Board) {
		let row = position[0]
		let col = position[1]
		if (isValidMove(oldRow: row, oldCol: col, newRow: row-2, newCol: col-1, side: self.side, board: board)) {
			nextMoves.append([row-2, col-1])
		}
		if (isValidMove(oldRow: row, oldCol: col, newRow: row-2, newCol: col+1, side: self.side, board: board)) {
			nextMoves.append([row-2, col+1])
		}
		if (isValidMove(oldRow: row, oldCol: col, newRow: row+2, newCol: col-1, side: self.side, board: board)) {
			nextMoves.append([row+2, col-1])
		}
		if (isValidMove(oldRow: row, oldCol: col, newRow: row+2, newCol: col+1, side: self.side, board: board)) {
			nextMoves.append([row+2, col+1])
		}
		if (isValidMove(oldRow: row, oldCol: col, newRow: row-1, newCol: col-2, side: self.side, board: board)) {
			nextMoves.append([row-1, col-2])
		}
		if (isValidMove(oldRow: row, oldCol: col, newRow: row-1, newCol: col+2, side: self.side, board: board)) {
			nextMoves.append([row-1, col+2])
		}
		if (isValidMove(oldRow: row, oldCol: col, newRow: row+1, newCol: col-2, side: self.side, board: board)) {
			nextMoves.append([row+1, col-2])
		}
		if (isValidMove(oldRow: row, oldCol: col, newRow: row+1, newCol: col+2, side: self.side, board: board)) {
			nextMoves.append([row+1, col+2])
		}
		nextMoves = uniq(source: nextMoves)
	}
}
