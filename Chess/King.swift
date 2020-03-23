//
//  King.swift
//  Chess
//
//  Created by Devin Leamy on 2020-03-19.
//  Copyright © 2020 Devin Leamy. All rights reserved.
//

import Foundation

class King: Piece {
	var canCastle = true
	override init(currentRow: Int, currentCol: Int, side: Side, type: Pieces) {
		super.init(currentRow: currentRow, currentCol: currentCol, side: side, type: type)
	}
	override func setNextMoves(board: Board) {
		let row = position[0]
		let col = position[1]
		if (isValidMove(oldRow: row, oldCol: col, newRow: row+1, newCol: col, side: self.side, board: board)) {
			nextMoves.append([row+1, col])
		}
		if (isValidMove(oldRow: row, oldCol: col, newRow: row-1, newCol: col, side: self.side, board: board)) {
			nextMoves.append([row-1, col])
		}
		if (isValidMove(oldRow: row, oldCol: col, newRow: row, newCol: col+1, side: self.side, board: board)) {
			nextMoves.append([row, col+1])
		}
		if (isValidMove(oldRow: row, oldCol: col, newRow: row, newCol: col-1, side: self.side, board: board)) {
			nextMoves.append([row, col-1])
		}
		
		if (isValidMove(oldRow: row, oldCol: col, newRow: row+1, newCol: col+1, side: self.side, board: board)) {
			nextMoves.append([row+1, col+1])
		}
		if (isValidMove(oldRow: row, oldCol: col, newRow: row-1, newCol: col+1, side: self.side, board: board)) {
			nextMoves.append([row-1, col+1])
		}
		if (isValidMove(oldRow: row, oldCol: col, newRow: row-1, newCol: col-1, side: self.side, board: board)) {
			nextMoves.append([row-1, col-1])
		}
		if (isValidMove(oldRow: row, oldCol: col, newRow: row+1, newCol: col-1, side: self.side, board: board)) {
			nextMoves.append([row+1, col-1])
		}
		//Checking if you can castle in the most brutal way
		//Could use loop to improve
		if canCastle && !isInCheck(gameBoard: board) {
			//King side
			if isValidMove(oldRow: row, oldCol: col, newRow: row, newCol: col+1, side: self.side, board: board) && board.board[row][col+1].getType() == Pieces.Blank {
				if isValidMove(oldRow: row, oldCol: col, newRow: row, newCol: col+2, side: self.side, board: board) && board.board[row][col+2].getType() == Pieces.Blank{
					if board.board[row][col+3].getType() == Pieces.Rook {
						if (board.board[row][col+3] as! Rook).getCanCastle() && board.board[row][col+3].getSide() == self.side {
							nextMoves.append([row, col+2])
						}
					}
				}
			}
			//Queen side
			if isValidMove(oldRow: row, oldCol: col, newRow: row, newCol: col-1, side: self.side, board: board) && board.board[row][col-1].getType() == Pieces.Blank {
				if isValidMove(oldRow: row, oldCol: col, newRow: row, newCol: col-2, side: self.side, board: board) && board.board[row][col-2].getType() == Pieces.Blank{
					if isValidMove(oldRow: row, oldCol: col, newRow: row, newCol: col-3, side: self.side, board: board) && board.board[row][col-3].getType() == Pieces.Blank {
						if board.board[row][col-4].getType() == Pieces.Rook {
							if (board.board[row][col-4] as! Rook).getCanCastle() && board.board[row][col-4].getSide() == self.side {
								nextMoves.append([row, col-2])
							}
						}
					}
				}
			}
			
		}
	}
	func getCanCastle() -> Bool {
		return canCastle
	}
	func setCanCastle(canCastle: Bool) -> Void {
		self.canCastle = canCastle
	}
	
	func isInCheck(gameBoard: Board) -> Bool {
		let row = position[0]
		let col = position[1]
		let kingSide = side
		let board = gameBoard.board
		
		//Check if the king is being attacked by a knight
		if (gameBoard.isOnBoard(row-2, col-1)) {
			let pieceInQuestion = board[row-2][col-1]
			if pieceInQuestion.getType() == Pieces.Knight && pieceInQuestion.getSide() != kingSide {
				return true
			}
		}
		if (gameBoard.isOnBoard(row+2, col-1)) {
			let pieceInQuestion = board[row+2][col-1]
			if pieceInQuestion.getType() == Pieces.Knight && pieceInQuestion.getSide() != kingSide {
				return true
			}
		}
		if (gameBoard.isOnBoard(row-2, col+1)) {
			let pieceInQuestion = board[row-2][col+1]
			if pieceInQuestion.getType() == Pieces.Knight && pieceInQuestion.getSide() != kingSide {
				return true
			}
		}
		if (gameBoard.isOnBoard(row+2, col+1)) {
			let pieceInQuestion = board[row+2][col+1]
			if pieceInQuestion.getType() == Pieces.Knight && pieceInQuestion.getSide() != kingSide {
				return true
			}
		}
		if (gameBoard.isOnBoard(row-1, col-2)) {
			let pieceInQuestion = board[row-1][col-2]
			if pieceInQuestion.getType() == Pieces.Knight && pieceInQuestion.getSide() != kingSide {
				return true
			}
		}
		if (gameBoard.isOnBoard(row+1, col-2)) {
			let pieceInQuestion = board[row+1][col-2]
			if pieceInQuestion.getType() == Pieces.Knight && pieceInQuestion.getSide() != kingSide {
				return true
			}
		}
		if (gameBoard.isOnBoard(row+1, col+2)) {
			let pieceInQuestion = board[row+1][col+2]
			if pieceInQuestion.getType() == Pieces.Knight && pieceInQuestion.getSide() != kingSide {
				return true
			}
		}
		if (gameBoard.isOnBoard(row-1, col+2)) {
			let pieceInQuestion = board[row-1][col+2]
			if pieceInQuestion.getType() == Pieces.Knight && pieceInQuestion.getSide() != kingSide {
				return true
			}
		}
		
		//Check if pawn is attacking king [white pawns move down in row || black pawns move up in row]
		if kingSide == Side.Black {
			if gameBoard.isOnBoard(row+1, col-1) {
				let pieceInQuestion = board[row+1][col-1]
				if pieceInQuestion.getType() == Pieces.Pawn && pieceInQuestion.getSide() != kingSide {
					return true
				}
			}
			if gameBoard.isOnBoard(row+1, col+1) {
				let pieceInQuestion = board[row+1][col+1]
				if pieceInQuestion.getType() == Pieces.Pawn && pieceInQuestion.getSide() != kingSide {
					return true
				}
			}
		} else {
			if gameBoard.isOnBoard(row-1, col-1) {
				let pieceInQuestion = board[row-1][col-1]
				if pieceInQuestion.getType() == Pieces.Pawn && pieceInQuestion.getSide() != kingSide {
					return true
				}
			}
			if gameBoard.isOnBoard(row-1, col+1) {
				let pieceInQuestion = board[row-1][col+1]
				if pieceInQuestion.getType() == Pieces.Pawn && pieceInQuestion.getSide() != kingSide {
					return true
				}
			}
		}
		//Check if rook or queen is attacking king
		for i in row+1..<8 {
			let pieceInQuestion = board[i][col]
			if (pieceInQuestion.getType() != Pieces.Blank) {
				if (pieceInQuestion.getSide() != kingSide) {
					if pieceInQuestion.getType() == Pieces.Rook || pieceInQuestion.getType() == Pieces.Queen {
						return true
					}
				}
				break
			}
		}
		for i in stride(from: row-1, through: 0, by: -1) {
			let pieceInQuestion = board[i][col]
			if (pieceInQuestion.getType() != Pieces.Blank) {
				if (pieceInQuestion.getSide() != kingSide) {
					if pieceInQuestion.getType() == Pieces.Rook || pieceInQuestion.getType() == Pieces.Queen {
						return true
					}
				}
				break
			}
		}
		
		for i in col+1..<8 {
			let pieceInQuestion = board[row][i]
			if (pieceInQuestion.getType() != Pieces.Blank) {
				if (pieceInQuestion.getSide() != kingSide) {
					if pieceInQuestion.getType() == Pieces.Rook || pieceInQuestion.getType() == Pieces.Queen {
						return true
					}
				}
				break
			}
		}
		for i in stride(from: col-1, through: 0, by: -1) {
			let pieceInQuestion = board[row][i]
			if (pieceInQuestion.getType() != Pieces.Blank) {
				if (pieceInQuestion.getSide() != kingSide) {
					if pieceInQuestion.getType() == Pieces.Rook || pieceInQuestion.getType() == Pieces.Queen {
						return true
					}
				}
				break
			}
		}
		//Check if bishop of queen is attacking king
		for i in 1...9 {
			if gameBoard.isOnBoard(row+i, col+i) {
				let pieceInQuestion = board[row+i][col+i]
				if pieceInQuestion.getType() != Pieces.Blank {
					if pieceInQuestion.getSide() != kingSide {
						if pieceInQuestion.getType() == Pieces.Bishop || pieceInQuestion.getType() == Pieces.Queen {
							return true
						}
					}
					break
				}
			} else {
				break
			}
		}
		for i in 1...9 {
			if gameBoard.isOnBoard(row-i, col-i) {
				let pieceInQuestion = board[row-i][col-i]
				if pieceInQuestion.getType() != Pieces.Blank {
					if pieceInQuestion.getSide() != kingSide {
						if pieceInQuestion.getType() == Pieces.Bishop || pieceInQuestion.getType() == Pieces.Queen {
							return true
						}
					}
					break
				}
			} else {
				break
			}
		}
		
		for i in 1...9 {
			if gameBoard.isOnBoard(row+i, col-i) {
				let pieceInQuestion = board[row+i][col-i]
				if pieceInQuestion.getType() != Pieces.Blank {
					if pieceInQuestion.getSide() != kingSide {
						if pieceInQuestion.getType() == Pieces.Bishop || pieceInQuestion.getType() == Pieces.Queen {
							return true
						}
					}
					break
				}
			} else {
				break
			}
		}
		for i in 1...9 {
			if gameBoard.isOnBoard(row-i, col+i) {
				let pieceInQuestion = board[row-i][col+i]
				if pieceInQuestion.getType() != Pieces.Blank {
					if pieceInQuestion.getSide() != kingSide {
						if pieceInQuestion.getType() == Pieces.Bishop || pieceInQuestion.getType() == Pieces.Queen {
							return true
						}
					}
					break
				}
			} else {
				break
			}
		}
		//Not in check
		return false
	}
}
