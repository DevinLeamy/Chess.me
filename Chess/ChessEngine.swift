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
	func getBestMove(board: Board) -> [Int]{
		let moves = getMoves(board: board)
		if moves.count == 0 {
			return [-1, -1]
		}
		return moves[Int.random(in: 0..<moves.count)]
	}
	
	func makeMove(board: Board, viewController: ViewController) {
		let move = getBestMove(board: board)
		if move.count == 4 {
			board.makeMove(oldRow: move[0], oldCol: move[1], row: move[2], col: move[3], white: viewController.GAME.white, black: viewController.GAME.black, uiViewController: viewController)
			board.updateBoard(game: viewController.GAME, viewController: viewController)
		}
	}
	
	
}
