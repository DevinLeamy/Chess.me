//
//  ChessEngine.swift
//  Chess
//
//  Created by Devin Leamy on 2020-03-26.
//  Copyright © 2020 Devin Leamy. All rights reserved.
//

import Foundation
import UIKit

class ChessEngine {
	func getMoves(board: Board) -> [[Int]]{
		var moves: [[Int]] = []
		for i in 0..<8 {
			for j in 0..<8 {
				if board.board[i][j].getType() != Pieces.Blank && board.board[i][j].getSide() == board.getTurn() {
					board.board[i][j].setNextMoves(board: board)
					for move in board.board[i][j].getNextMoves() {
						if move.count == 0 {continue}
						moves.append([i, j, move[0], move[1]])
					}
				}
			}
		}
		return moves
	}
	func getBestMove(board: Board) -> [Int] {
		let moves = getMoves(board: board)
		if moves.count == 0 {
			return [-1, -1]
		}
		var best = moves[0]
		var bestVal = 0
		for move in moves {
			var boardCopy = getCopyOfBoard(board)
			boardCopy =  makeFieldingMove(move: move, board: &boardCopy)
			let eval = getBoardValuation(board: boardCopy)
			if eval < bestVal {
				bestVal = eval
				best = move
			}
		}
		
		return best
	}
	
	func makeMove(board: Board, viewController: ViewController) {
		let move = getBestMove(board: board)
		if move.count == 4 {
			board.makeMove(oldRow: move[0], oldCol: move[1], row: move[2], col: move[3], white: viewController.GAME.white, black: viewController.GAME.black, uiViewController: viewController)
			board.updateBoard(game: viewController.GAME, viewController: viewController)
		}
	}
	
	func getCopyOfBoard(_ board: Board) -> [[Piece]] {
		var newBoard : [[Piece]] = []
		for i in 0..<8 {
			var row : [Piece] = []
			for j in 0..<8 {
				row.append(copyPiece(board.board[i][j]))
			}
			newBoard.append(row)
		}
		return newBoard
	}
	
	func copyPiece(_ piece: Piece) -> Piece {
		let row = piece.getPosition()[0]
		let col = piece.getPosition()[1]
		let side = piece.getSide()
		let type = piece.getType()
		switch piece.getType() {
			case Pieces.Bishop:
				return Bishop(currentRow: row, currentCol: col, side: side, type: type)
			case Pieces.Knight:
				return Knight(currentRow: row, currentCol: col, side: side, type: type)
			case Pieces.Queen:
				return Queen(currentRow: row, currentCol: col, side: side, type: type)
			case Pieces.Blank:
				return Blank(currentRow: row, currentCol: col, side: side, type: type)
			case Pieces.Rook:
				return Rook(currentRow: row, currentCol: col, side: side, type: type)
			case Pieces.Pawn:
				return Pawn(currentRow: row, currentCol: col, side: side, type: type)
			case Pieces.King:
				return King(currentRow: row, currentCol: col, side: side, type: type)
		}
	}
	func makeFieldingMove(move: [Int],  board: inout [[Piece]]) -> [[Piece]] {
		let row = move[0]
		let col = move[1]
		let dRow = move[2]
		let dCol = move[3]
		board[dRow][dCol] = board[row][col]
		board[dRow][dCol].setPosition(currentRow: dRow, currentCol: dCol)
		board[dRow][dCol] = Blank(currentRow: -1, currentCol: -1, side: Side.Black, type: Pieces.Blank)
		return board
	}
	
	
	func getBoardValuation(board: [[Piece]]) -> Int {
		var value = 0
		for i in 0..<8 {
			for j in 0..<8 {
				value += getPieceValue(piece: board[i][j].getType(), side: board[i][j].getSide())
			}
		}
		return value
	}
	
	func getPieceValue(piece: Pieces, side: Side) -> Int {
		var value = -1
		switch piece {
			case Pieces.Knight:
				value = 30
			case Pieces.Pawn:
				value = 10
				
			case Pieces.Rook:
				value = 50
			
			case Pieces.Queen:
				value = 90
				
			case Pieces.King:
				value = 900
			case Pieces.Bishop:
				value = 30
			default:
				value = 0
		}
		if side == Side.Black {
			value  *= -1
		}
		return value
		
	}
}
