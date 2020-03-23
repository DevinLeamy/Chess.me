//
//  Game.swift
//  Chess
//
//  Created by Devin Leamy on 2020-03-19.
//  Copyright © 2020 Devin Leamy. All rights reserved.
//

import Foundation
import UIKit

class Game {
	var white: Team
	var black: Team
	var gameState = GameState.InProgress
	var gameResult = GameResult.Undecided
	var tied = GameTied.Undecided
	var won = GameWon.Undecided
	var board: Board
	
	init(white: Team, black: Team, board: Board) {
		self.white = white
		self.black = black
		self.board = board
	}
	func getGameBoard() -> Board {
		return board
	}
	
	func getWhite() -> Team {
		return white
	}
	
	func getBlack() -> Team {
		return black
	}
	
	//Game result...., Enum of game result
	func getGameResult() -> [Any] {
		if gameState != GameState.Finished {
			return ["The game is still inprogress"]
		} else {
			if (gameResult == GameResult.Tied) {
				switch tied {
					case GameTied.InsufficientMaterial:
						return ["Game tied by insufficient material", gameResult]
					case GameTied.StaleMate:
						return ["Game tied by stalemate", gameResult]
					case GameTied.Undecided:
						return ["Error", gameResult]
				}
			} else {
				var winner: String
				if (gameResult == GameResult.BlackWon) {
					winner = "Black"
				} else {
					winner = "White"
				}
				switch won {
					case GameWon.CheckMate:
						return ["\(winner) won by checkmate", gameResult]
					case GameWon.Resignation:
						return ["\(winner) won by resignation", gameResult]
					case GameWon.TimeOut:
						return ["\(winner) won on time", gameResult]
					case GameWon.Undecided:
						return ["Error", gameResult]
				}
			}
		}
	}
	func gameIsOver() -> Bool {
		//Case: Won by checkmate -> Ex. Black king is in check and cannot get out of check
		if let king = board.getKing(side: board.getTurn()) as? King {
			var foundValidMove = true
			if king.isInCheck(gameBoard: board) {
				foundValidMove = false
				for i in 0..<8 {
					for j in 0..<8 {
						if (board.board[i][j].getSide() == board.getTurn()) {
							for move in board.board[i][j].getNextMoves() {
								if move.count == 0 {continue} //If there were no moves
								let row = i
								let col = j
								let newRow = move[0]
								let newCol = move[1]
								let pieceBeingMoved = board.board[row][col]
								let pieceAtNewPosition = board.board[newRow][newCol]
								
								//Make move
								pieceBeingMoved.setPosition(currentRow: newRow, currentCol: newCol)
								board.board[newRow][newCol] = pieceBeingMoved
								board.board[row][col] = Blank(currentRow: -1, currentCol: -1, side: Side.Blank, type: Pieces.Blank)
								
								
								//Check if still in check
								if !king.isInCheck(gameBoard: board) {
									foundValidMove = true
								
								}
								//Move back
								pieceBeingMoved.setPosition(currentRow: row, currentCol: col)
								board.board[row][col] = pieceBeingMoved
								board.board[newRow][newCol] = pieceAtNewPosition
							}
						}
					}
				}
			}
 			if !foundValidMove {
				gameState = GameState.Finished
				won = GameWon.CheckMate
				return true
			}
		}
		//Case: Won by resignation [Feature not yet implemented]
		//Case: Won by timeout [Feature not yet implemented]
		
		//Case: Draw by slatemate -> Ex. It is white's move and they have no valid moves
		var foundValidMove = false
		for i in 0..<8 {
			for j in 0..<8 {
				if board.board[i][j].getSide() == board.getTurn() {
					if board.board[i][j].getNextMoves() != [[]] {
						foundValidMove = true
					}
				}
			}
		}
		if !foundValidMove {
			gameState = GameState.Finished
			tied = GameTied.StaleMate
			return true
		}
		//Case: Draw by insufficient material -> Player's have one or two piece(s) neither of which are a pawn, rook or queen
		var whitePieceCount = 0
		var blackPieceCount = 0
		var foundPRQ = false //Pawn.Rook.Queen
		for i in 0..<8 {
			for j in 0..<8 {
				let currentPiece = board.board[i][j]
				if currentPiece.getSide() == Side.White {
					whitePieceCount += 1
				} else {
					blackPieceCount += 1
				}
				if currentPiece is Rook || currentPiece is Queen || currentPiece is Pawn {
					foundPRQ = true
				}
			}
		}
		if !foundPRQ && whitePieceCount < 3 && blackPieceCount < 3 {
			gameState = GameState.Finished
			tied = GameTied.InsufficientMaterial
			return true
		}
		//Case: Draw by three-fold repetition of moves
		
		
		
		
		
		return false //Game is not over
	}
}
