//
//  Bishop.swift
//  Chess
//
//  Created by Devin Leamy on 2020-03-19.
//  Copyright © 2020 Devin Leamy. All rights reserved.
//

import Foundation

class Bishop: Piece {
	override init(currentRow: Int, currentCol: Int, side: Side, type: Pieces) {
		super.init(currentRow: currentRow, currentCol: currentCol, side: side, type: type)
	}
	override func setNextMoves(board: Board) {
		let row = position[0]
		let col = position[1]
		for i in 1...9 {
			if isValidMove(oldRow: row, oldCol: col, newRow: row+i, newCol: col+i, side: self.side, board: board) {
				nextMoves.append([row+i, col+i])
				if board.board[row+i][col+i].getType() != Pieces.Blank {
					break
				}
			}  else if board.isOnBoard(row+i, col+i) {
				if board.board[row+i][col+i].getType() != Pieces.Blank {
					break
				}
			} else {
				break
			}
		}
		for i in 1...9 {
			if isValidMove(oldRow: row, oldCol: col, newRow: row-i, newCol: col-i, side: self.side, board: board) {
				nextMoves.append([row-i, col-i])
				if board.board[row-i][col-i].getType() != Pieces.Blank {
					break
				}
			} else if board.isOnBoard(row-i, col-i) {
				if board.board[row-i][col-i].getType() != Pieces.Blank {
					break
				}
			} else {
				break
			}
		}
		
		for i in 1...9 {
			if isValidMove(oldRow: row, oldCol: col, newRow: row+i, newCol: col-i, side: self.side, board: board) {
				nextMoves.append([row+i, col-i])
				if board.board[row+i][col-i].getType() != Pieces.Blank {
					break
				}
			} else if board.isOnBoard(row+i, col-i) {
				if board.board[row+i][col-i].getType() != Pieces.Blank {
					break
				}
			} else {
				break
			}
		}
		for i in 1...9 {
			if isValidMove(oldRow: row, oldCol: col, newRow: row-i, newCol: col+i, side: self.side, board: board) {
				nextMoves.append([row-i, col+i])
				if board.board[row-i][col+i].getType() != Pieces.Blank {
					break
				}
			} else if board.isOnBoard(row-i, col+i) {
				if board.board[row-i][col+i].getType() != Pieces.Blank {
					break
				}
			} else {
				break
			}
		}
	}
}

