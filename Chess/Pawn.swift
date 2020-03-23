//
//  Pawn.swift
//  Chess
//
//  Created by Devin Leamy on 2020-03-19.
//  Copyright © 2020 Devin Leamy. All rights reserved.
//

import Foundation

class Pawn: Piece {
	var movedTwice = false
	override init(currentRow: Int, currentCol: Int, side: Side, type: Pieces) {
		super.init(currentRow: currentRow, currentCol: currentCol, side: side, type: type)
	}
	override func setNextMoves(board: Board) {
		let row = position[0]
		let col = position[1]
		if (self.getSide() == Side.White) {
			if (isValidMove(oldRow: row, oldCol: col, newRow: row-1, newCol: col, side: self.side, board: board)) {
				if (board.board[row-1][col].getType() == Pieces.Blank) {
					nextMoves.append([row-1, col])
					if (row == 6 && isValidMove(oldRow: row, oldCol: col, newRow: row-2, newCol: col, side: self.side, board: board)) {
						if (board.board[row-2][col].getType() == Pieces.Blank) {
							nextMoves.append([row-2, col])
						}
					}
				}
			}
			if (isValidMove(oldRow: row, oldCol: col, newRow: row-1, newCol: col-1, side: self.side, board: board) && board.board[row-1][col-1].getType() != Pieces.Blank) {
				nextMoves.append([row-1, col-1])
			}
			if (isValidMove(oldRow: row, oldCol: col, newRow: row-1, newCol: col+1, side: self.side, board: board) && board.board[row-1][col+1].getType() != Pieces.Blank) {
				nextMoves.append([row-1, col+1])
			}
			//Checks for enpassant to the left and right
			if board.isOnBoard(row, col-1) && board.isOnBoard(row-1, col-1){
				if board.board[row-1][col-1].getType() == Pieces.Blank {
					if board.board[row][col-1].getType() == Pieces.Pawn && board.board[row][col-1].getSide() != self.side {
						if (board.board[row][col-1] as! Pawn).getMovedTwice() {
							if isValidMove(oldRow: row, oldCol: col, newRow: row-1, newCol: col-1, side: self.side, board: board) {
								nextMoves.append([row-1, col-1])
							}
						}
					}
				}
			}
			if board.isOnBoard(row, col+1) && board.isOnBoard(row-1, col+1){
				if board.board[row-1][col+1].getType() == Pieces.Blank {
					if board.board[row][col+1].getType() == Pieces.Pawn && board.board[row][col+1].getSide() != self.side {
						if (board.board[row][col+1] as! Pawn).getMovedTwice() {
							if isValidMove(oldRow: row, oldCol: col, newRow: row-1, newCol: col+1, side: self.side, board: board) {
								nextMoves.append([row-1, col+1])
							}
						}
					}
				}
			}
			
		} else {
			if (isValidMove(oldRow: row, oldCol: col, newRow: row+1, newCol: col, side: self.side, board: board)) {
				if (board.board[row+1][col].getType() == Pieces.Blank) {
					nextMoves.append([row+1, col])
					if (row == 1 && isValidMove(oldRow: row, oldCol: col, newRow: row+2, newCol: col, side: self.side, board: board)) {
						if (board.board[row+2][col].getType() == Pieces.Blank) {
							nextMoves.append([row+2, col])
						}
					}
				}
			}
			if (isValidMove(oldRow: row, oldCol: col, newRow: row+1, newCol: col-1, side: self.side, board: board) && board.board[row+1][col-1].getType() != Pieces.Blank) {
				nextMoves.append([row+1, col-1])
			}
			if (isValidMove(oldRow: row, oldCol: col, newRow: row+1, newCol: col+1, side: self.side, board: board) && board.board[row+1][col+1].getType() != Pieces.Blank) {
				nextMoves.append([row+1, col+1])
			}
			
			//Checks for enpassant to the left and right
			if board.isOnBoard(row, col-1) && board.isOnBoard(row+1, col-1){
				if board.board[row+1][col-1].getType() == Pieces.Blank {
					if board.board[row][col-1].getType() == Pieces.Pawn && board.board[row][col-1].getSide() != self.side {
						if (board.board[row][col-1] as! Pawn).getMovedTwice() {
							if isValidMove(oldRow: row, oldCol: col, newRow: row+1, newCol: col-1, side: self.side, board: board) {
								nextMoves.append([row+1, col-1])
							}
						}
					}
				}
			}
			if board.isOnBoard(row, col+1) && board.isOnBoard(row+1, col+1){
				if board.board[row+1][col+1].getType() == Pieces.Blank {
					if board.board[row][col+1].getType() == Pieces.Pawn && board.board[row][col+1].getSide() != self.side {
						if (board.board[row][col+1] as! Pawn).getMovedTwice() {
							if isValidMove(oldRow: row, oldCol: col, newRow: row+1, newCol: col+1, side: self.side, board: board) {
								nextMoves.append([row+1, col+1])
							}
						}
					}
				}
			}
		}
	}
	
	func getMovedTwice() -> Bool {
		return movedTwice
	}
	
	func setMovedTwice(movedTwice: Bool) {
		self.movedTwice = movedTwice
	}
}


//White pawns can decrease in row
//Black pawns can increase in row
