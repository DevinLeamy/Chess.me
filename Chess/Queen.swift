//
//  Queen.swift
//  Chess
//
//  Created by Devin Leamy on 2020-03-19.
//  Copyright © 2020 Devin Leamy. All rights reserved.
//

import Foundation

class Queen: Piece {
	override init(currentRow: Int, currentCol: Int, side: Side, type: Pieces) {
		super.init(currentRow: currentRow, currentCol: currentCol, side: side, type: type)
	}
	override func setNextMoves(board: Board) {
		let row = position[0]
		let col = position[1]
		//Diagonal moves
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
		//Horizontal and vertical moves
		for i in row+1..<8 {
			if isValidMove(oldRow: row, oldCol: col, newRow: i, newCol: col, side: self.side, board: board) {
				nextMoves.append([i, col])
				if board.board[i][col].getType() != Pieces.Blank {
					break
				}
			} else if board.isOnBoard(i, col) {
				if board.board[i][col].getType() != Pieces.Blank {
					break
				}
			} else {
				break
			}
		}
		for i in stride(from: row-1, through: 0, by: -1) {
			if isValidMove(oldRow: row, oldCol: col, newRow: i, newCol: col, side: self.side, board: board) {
				nextMoves.append([i, col])
				if board.board[i][col].getType() != Pieces.Blank {
					break
				}
			} else if board.isOnBoard(i, col) {
				if board.board[i][col].getType() != Pieces.Blank {
					break
				}
			} else {
				break
			}
		}
		
		for i in col+1..<8 {
			if isValidMove(oldRow: row, oldCol: col, newRow: row, newCol: i, side: self.side, board: board) {
				nextMoves.append([row, i])
				if board.board[row][i].getType() != Pieces.Blank {
					break
				}
			} else if board.isOnBoard(row, i) {
				if board.board[row][i].getType() != Pieces.Blank {
					break
				}
			} else {
				break
			}
		}
		for i in stride(from: col-1, through: 0, by: -1) {
			if isValidMove(oldRow: row, oldCol: col, newRow: row, newCol: i, side: self.side, board: board) {
				nextMoves.append([row, i])
				if board.board[row][i].getType() != Pieces.Blank {
					break
				}
			} else if board.isOnBoard(row, i) {
				if board.board[row][i].getType() != Pieces.Blank {
					break
				}
			} else {
				break
			}
		}
	}
}

