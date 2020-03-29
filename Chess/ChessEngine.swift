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
	var viewController : ViewController
	// Boards need to fliped for black pieces
	let kingBoard = [
		[-3.0, -4,0, -4,0, -5.0, -5.0, -4.0, -4.0, -3.0],
		[-3.0, -4,0, -4,0, -5.0, -5.0, -4.0, -4.0, -3.0],
		[-3.0, -4,0, -4,0, -5.0, -5.0, -4.0, -4.0, -3.0],
		[-3.0, -4,0, -4,0, -5.0, -5.0, -4.0, -4.0, -3.0],
		[-2.0, -3,0, -3,0, -4.0, -4.0, -3.0, -3.0, -2.0],
		[-1.0, -2,0, -2,0, -2.0, -2.0, -2.0, -2.0, -1.0],
		[ 2.0,  2.0,  0.0,  0.0,  0.0,  0.0,  2.0,  2.0],
		[ 2.0,  3.0,  1.0,  0.0,  0.0,  1.0,  3.0,  2.0]
	]
	let rookBoard = [
		[ 0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0],
		[ 0.5,  1.0,  1.0,  1.0,  1.0,  1.0,  1.0,  0.5],
		[-0.5,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, -0.5],
		[-0.5,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, -0.5],
		[-0.5,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, -0.5],
		[-0.5,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, -0.5],
		[-0.5,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, -0.5],
		[-1.0,  0.0,  0.5,  1.0,  1.0,  0.5,  0.0, -1.0] // ORIGINAL: 	[ 0.0,  0.0,  0.0,  0.5,  0.5,  0.0,  0.0,  0.0]
	]
	
	let knightBoard = [
		[-5.0, -4.0, -3.0, -3.0, -3.0, -3.0, -4.0, -5.0],
		[-4.0, -2.0,  0.0,  0.0,  0.0,  0.0, -2.0, -4.0],
		[-3.0,  0.0,  1.0,  1.5,  1.5,  1.0,  0.0, -3.0],
		[-3.0,  0.5,  1.5,  2.0,  2.0,  1.5,  0.5, -3.0],
		[-3.0,  0.0,  1.5,  2.0,  2.0,  1.5,  0.0, -3.0],
		[-3.0,  0.5,  1.0,  1.5,  1.5,  1.0,  0.5, -3.0],
		[-4.0, -2.0,  0.0,  0.5,  0.5,  0.0, -2.0, -4.0],
		[-5.0, -4.0, -3.0, -3.0, -3.0, -3.0, -4.0, -5.0]
	]
	
	let queenBoard = [
		[-2.0, -1.0, -1.0, -0.5, -0.5, -1.0, -1.0, -2.0],
		[-1.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, -1.0],
		[-1.0,  0.0,  0.5,  0.5,  0.5,  0.5,  0.0, -1.0],
		[-0.5,  0.0,  0.5,  0.5,  0.5,  0.5,  0.0, -0.5],
		[ 0.0,  0.0,  0.5,  0.5,  0.5,  0.5,  0.0, -0.5],
		[-1.0,  0.5,  0.5,  0.5,  0.5,  0.5,  0.0, -1.0],
		[-1.0,  0.0,  0.5,  0.0,  0.0,  0.0,  0.0, -1.0],
		[-2.0, -1.0, -1.0, -0.5, -0.5, -1.0, -1.0, -2.0]
	]
	
	let bishopBoard = [
		[-2.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -2.0],
		[-1.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, -1.0],
		[-1.0,  0.0,  0.5,  1.0,  1.0,  0.5,  0.0, -1.0],
		[-1.0,  0.5,  0.5,  1.0,  1.0,  0.5,  0.5, -1.0],
		[-1.0,  0.0,  1.0,  1.0,  1.0,  1.0,  0.0, -1.0],
		[-1.0,  1.0,  1.0,  1.0,  1.0,  1.0,  1.0, -1.0],
		[-1.0,  0.5,  0.0,  0.0,  0.0,  0.0,  0.5, -1.0],
		[-2.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -2.0]
	]
	
	let pawnBoard = [
		[ 0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0],
		[ 5.0,  5.0,  5.0,  5.0,  5.0,  5.0,  5.0,  5.0],
		[ 1.0,  1.0,  2.0,  3.0,  3.0,  2.0,  1.0,  1.0],
		[ 0.5,  0.5,  1.0,  2.5,  2.5,  1.0,  0.5,  0.5],
		[ 0.0,  0.0,  0.0,  2.0,  2.0,  0.0,  0.0,  0.0],
		[ 0.5, -0.5, -1.0,  0.0,  0.0, -1.0, -0.5,  0.5],
		[ 0.5,  1.0,  1.0,  0.0, -2.0, -2.0,  1.0,  0.5],
		[ 0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0]
	]
	
	
	
	
	init(viewController: ViewController) {
		self.viewController = viewController
	}
	
	func getMoves(board: Board, side: Side) -> [[Int]]{
		var moves: [[Int]] = []
		for i in 0..<8 {
			for j in 0..<8 {
				if board.board[i][j].getType() != Pieces.Blank && board.board[i][j].getSide() == side {
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
	func getBestMove(board: Board, depth: Int, currentDepth: Int, maximizingPlayer: Bool, alpha: Double, beta: Double) -> [Double] {
		if currentDepth == depth {
			return [-1, -1, -1, -1, getBoardValuation(board: board.board)]
		}
		
		var newAlpha = alpha
		var newBeta = beta
		var bestVal : Double
		var moves : [[Int]]
		var bestMoves : [[Int]]
		if maximizingPlayer {
			bestVal = -10000
			moves = getMoves(board: board, side: Side.White)
			if moves.count == 0 {
				return [-1, -1, -1, -1, bestVal]
			}
			bestMoves = [moves[0]]
			for move in moves {
				var boardCopy = getCopyOfBoard(board)
				boardCopy =  makeFieldingMove(move: move, board: &boardCopy)
				let newBoard = Board(userChessBoard: getCopyOfBoard(&board.userChessBoard), verticalStackView: viewController.verticalStackView)
				newBoard.board = boardCopy
				let eval = getBestMove(board: newBoard, depth: depth, currentDepth: currentDepth + 1, maximizingPlayer: !maximizingPlayer, alpha: newAlpha, beta: newBeta)[4]
				if eval == bestVal {
					bestMoves.append(move)
				} else if eval > bestVal {
					bestVal = eval
					bestMoves = [move]
				}
				newAlpha = max(newAlpha, bestVal)
				
				if newBeta <= newAlpha {
					break
				}
			}
		} else {
			bestVal = 10000.0
			moves = getMoves(board: board, side: Side.Black)
			if moves.count == 0 {
				return [-1, -1, -1, -1, bestVal]
			}
			bestMoves = [moves[0]]
			for move in moves {
				var boardCopy = getCopyOfBoard(board)
				boardCopy =  makeFieldingMove(move: move, board: &boardCopy)
				let newBoard = Board(userChessBoard: getCopyOfBoard(&board.userChessBoard), verticalStackView: viewController.verticalStackView)
				newBoard.board = boardCopy
				let eval = getBestMove(board: newBoard, depth: depth, currentDepth: currentDepth + 1, maximizingPlayer: !maximizingPlayer, alpha: alpha, beta: beta)[4]
				if eval == bestVal {
					bestMoves.append(move)
				} else if eval < bestVal {
					bestVal = eval
					bestMoves = [move]
				}
				newBeta = min(newBeta, bestVal)
				if newBeta <= newAlpha {
					break
				}
			}
		}
	
//		print("Current Depth: \(currentDepth) Evaluation: \(bestVal) Minimize: \(getMin)")
		var best : [Double] = bestMoves[Int.random(in: 0..<bestMoves.count)].map{ Double($0) }
		best.append(bestVal)
		return best
	}
	func makeMove(board: Board, viewController: ViewController) {
		let alpha = -100000.0
		let beta = 100000.0
		var move = getBestMove(board: board, depth: 3, currentDepth: 0, maximizingPlayer: false, alpha: alpha, beta: beta)
		move.remove(at: 4)
		if move.count == 4 && move[0] != -1 {
			board.makeMove(oldRow: Int(move[0]), oldCol: Int(move[1]), row: Int(move[2]), col: Int(move[3]), white: viewController.GAME.white, black: viewController.GAME.black, uiViewController: viewController)
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
	
	func getCopyOfBoard(_ board: inout [[UIButton]]) -> [[UIButton]] {
		return board
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
		board[row][col] = Blank(currentRow: -1, currentCol: -1, side: Side.Black, type: Pieces.Blank)
		return board
	}
	
	
	func getBoardValuation(board: [[Piece]]) -> Double {
		var value = 0.0
		for i in 0..<8 {
			for j in 0..<8 {
				value += getPieceValue(piece: board[i][j], side: board[i][j].getSide())
			}
		}
		return value
	}
	
	func getPieceValue(piece: Piece, side: Side) -> Double {
		var value = -1.0
		let row = piece.getPosition()[0]
		let col = piece.getPosition()[1]
		if side == Side.Black {
			switch piece.getType() {
				case Pieces.Knight:
					value = -30
					value += -1 * knightBoard[7-row][col]
				case Pieces.Pawn:
					value = -10
					value += -1 * pawnBoard[7-row][col]
				case Pieces.Rook:
					value = -50
					value += -1 * rookBoard[7-row][col]
				case Pieces.Queen:
					value = -90
					value += -1 * queenBoard[7-row][col]
				case Pieces.King:
					value = -900
					value += -1 * kingBoard[7-row][col]
				case Pieces.Bishop:
					value = -30
					value += -1 * bishopBoard[7-row][col]
				default:
					value = 0
			}
		} else {
			switch piece.getType() {
				case Pieces.Knight:
					value = 30
					value += knightBoard[row][col]
				case Pieces.Pawn:
					value = 10
					value += pawnBoard[row][col]
				case Pieces.Rook:
					value = 50
					value += rookBoard[row][col]
				case Pieces.Queen:
					value = 90
					value += queenBoard[row][col]
				case Pieces.King:
					value = 900
					value += kingBoard[row][col]
				case Pieces.Bishop:
					value = 30
					value += bishopBoard[row][col]
				default:
					value = 0
			}
		}
		return value
	}
}
