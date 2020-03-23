//
//  File.swift
//  Chess
//
//  Created by Devin Leamy on 2020-03-19.
//  Copyright © 2020 Devin Leamy. All rights reserved.
//

import Foundation

class Piece {
	var position = [-1, -1]
	var side: Side
	var nextMoves = [[Int]]()
	var type: Pieces
	init(currentRow: Int, currentCol: Int, side: Side, type: Pieces) {
		self.position[0] = currentRow
		self.position[1] = currentCol
		self.side = side
		self.type = type
	}
	
	func getSide() -> Side {
		return side
	}
	
	func clearNextMoves() -> Void {
		self.nextMoves = [[]]
	}
	//Checks whether a given position is valid
	func isValidMove(oldRow: Int, oldCol: Int, newRow: Int, newCol: Int, side: Side, board: Board) -> Bool {
		if (newRow >= 8 || newRow < 0 || newCol >= 8 || newCol < 0) {
			return false
		} else if (board.board[newRow][newCol].getSide() == side) {
			return false
		}
		let kingAsPiece = board.getKing(side: self.side)
		var legal = true
		if let king = kingAsPiece as? King {
			let pieceBeingMoved = board.board[oldRow][oldCol]
			let pieceAtNewPosition = board.board[newRow][newCol]
			
			//Make move
			pieceBeingMoved.setPosition(currentRow: newRow, currentCol: newCol)
			board.board[newRow][newCol] = pieceBeingMoved
			board.board[oldRow][oldCol] = Blank(currentRow: -1, currentCol: -1, side: Side.Blank, type: Pieces.Blank)
				
			//Check if still in check
			if king.isInCheck(gameBoard: board) {
				legal = false
			}
			//Move back
			pieceBeingMoved.setPosition(currentRow: oldRow, currentCol: oldCol)
			board.board[oldRow][oldCol] = pieceBeingMoved
			board.board[newRow][newCol] = pieceAtNewPosition
		}
		return legal
	}
	
	func setNextMoves(board: Board) {
		return
	}
	
	func getNextMoves() -> [[Int]] {
		return nextMoves
	}
	
	func getType() -> Pieces {
		return type
	}
	
	func getPosition() -> [Int] {
		return position
	}
	
	func setPosition(currentRow: Int, currentCol: Int) {
		position[0] = currentRow
		position[1] = currentCol
	}
}
