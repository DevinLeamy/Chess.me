//
//  File.swift
//  Chess
//
//  Created by Devin Leamy on 2020-03-19.
//  Copyright © 2020 Devin Leamy. All rights reserved.
//

import Foundation
import UIKit

class Board {
	var board: [[Piece]] = Array(repeating: Array(repeating: Piece(currentRow: -1, currentCol: -1, side: Side.Blank, type: Pieces.Blank), count: 8), count: 8)
	var turn: Side
	var userChessBoard: [[UIButton]]
	var currentBottom = Side.White
	var verticalStackView: UIStackView
	var lastMove: [Int] = []
	var lastPieceToMove: Piece!
	var theme: Theme = Theme.Rustic
	init(userChessBoard: [[UIButton]], verticalStackView: UIStackView?) {
		if (verticalStackView != nil) {
			self.verticalStackView = verticalStackView!
		} else {
			self.verticalStackView = UIStackView()
		}
		self.userChessBoard = userChessBoard
		//Initialize Pawns
		for i in 0..<8 {
			self.board[1][i] = Pawn(currentRow: 1, currentCol: i, side: Side.Black, type: Pieces.Pawn)
			self.board[6][i] = Pawn(currentRow: 6, currentCol: i, side: Side.White, type: Pieces.Pawn)
		}
		//Initialize Rooks
		self.board[0][0] = Rook(currentRow: 0, currentCol: 0, side: Side.Black, type: Pieces.Rook)
		self.board[0][7] = Rook(currentRow: 0, currentCol: 7, side: Side.Black, type: Pieces.Rook)
		self.board[7][0] = Rook(currentRow: 7, currentCol: 0, side: Side.White, type: Pieces.Rook)
		self.board[7][7] = Rook(currentRow: 7, currentCol: 7, side: Side.White, type: Pieces.Rook)
		//Initialize Knights
		self.board[0][1] = Knight(currentRow: 0, currentCol: 1, side: Side.Black, type: Pieces.Knight)
		self.board[0][6] = Knight(currentRow: 0, currentCol: 6, side: Side.Black, type: Pieces.Knight)
		self.board[7][1] = Knight(currentRow: 7, currentCol: 1, side: Side.White, type: Pieces.Knight)
		self.board[7][6] = Knight(currentRow: 7, currentCol: 6, side: Side.White, type: Pieces.Knight)
		//Initialize Bishops
		self.board[0][2] = Bishop(currentRow: 0, currentCol: 2, side: Side.Black, type: Pieces.Bishop)
		self.board[0][5] = Bishop(currentRow: 0, currentCol: 5, side: Side.Black, type: Pieces.Bishop)
		self.board[7][2] = Bishop(currentRow: 7, currentCol: 2, side: Side.White, type: Pieces.Bishop)
		self.board[7][5] = Bishop(currentRow: 7, currentCol: 5, side: Side.White, type: Pieces.Bishop)
		//Initialize Queens
		self.board[0][3] = Queen(currentRow: 0, currentCol: 3, side: Side.Black, type: Pieces.Queen)
		self.board[7][3] = Queen(currentRow: 7, currentCol: 3, side: Side.White, type: Pieces.Queen)
		//Initialize Kings
		self.board[0][4] = King(currentRow: 0, currentCol: 4, side: Side.Black, type: Pieces.King)
		self.board[7][4] = King(currentRow: 7, currentCol: 4, side: Side.White, type: Pieces.King)
		//Initialize turn
		turn = Side.White
		

	}
	//Makes all of the pieces have 0 set next moves
	func clearNextMoves() -> Void {
		for i in 0..<8 {
			for j in 0..<8 {
				board[i][j].clearNextMoves()
			}
		}
	}
	//Set the next moves of the player who's turn it is to move
	func setNextMoves() -> Void {
		clearNextMoves()
		for i in 0..<8 {
			for j in 0..<8 {
				board[i][j].setNextMoves(board: self)
			}
		}
	}
	
	func isWhiteTurn() -> Bool {
		if (turn == Side.White) {
			return true
		}
		return false
	}
	
	func getTurn() -> Side {
		return turn
	}
	
	func changeTurn() {
		if (turn == Side.White) {
			turn = Side.Black
		} else {
			turn = Side.White
		}
		setNextMoves()
	}
	func getGameBoard() -> [[Piece]] {
		return board
	}
	
	func printBoard() -> Void {
		for i in 0..<8 {
			var line = ""
			for j in 0..<8 {
				let pieceType = board[i][j].getType()
				switch pieceType {
					case Pieces.Knight:
						line += "Kn "
					case Pieces.Bishop:
						line += "B  "
					case Pieces.Rook:
						line += "R  "
					case Pieces.Blank:
						line += "_  "
					case Pieces.King:
						line += "Ki "
					case Pieces.Queen:
						line += "Q  "
					case Pieces.Pawn:
						line += "P  "
				}
			}
			print(line)
		}
	}
	
	func makeMove(oldRow: Int, oldCol: Int, newRow: Int, newCol: Int, white: Team, black: Team, buttonChessBoard: [[UIButton]]) -> Bool {
		let pieceBeingMoved = board[oldRow][oldCol]
		if !pieceBeingMoved.getNextMoves().contains([newRow, newCol]) {
			print("You are trying to make an invalid move")
			return false
		}
		pieceBeingMoved.setPosition(currentRow: newRow, currentCol: newCol)
		board[oldRow][oldCol] = Blank(currentRow: -1, currentCol: -1, side: Side.Blank, type: Pieces.Blank)
		if board[newRow][newCol].getType() != Pieces.Blank {
			let typeOfPieceCaptured = board[newRow][newCol].getType()
			if turn == Side.White {
				white.capturedPiece(piece: typeOfPieceCaptured)
			} else {
				black.capturedPiece(piece: typeOfPieceCaptured)
			}
		} else if pieceBeingMoved.getType() == Pieces.Pawn {
			if abs(oldCol - newCol) == 1 {
				//Therefore enpassent was performed
				if turn == Side.White {
					white.capturedPiece(piece: Pieces.Pawn)
				} else {
					black.capturedPiece(piece: Pieces.Pawn)
				}
				board[oldRow][newCol] = Blank(currentRow: -1, currentCol: -1, side: Side.Blank, type: Pieces.Blank)
				buttonChessBoard[oldRow][newCol].setImage(BLANK_IMAGE, for: UIControl.State.normal)
			}
		}
		board[newRow][newCol] = pieceBeingMoved
		lastMove = [oldRow, oldCol, newRow, newCol]
		lastPieceToMove = board[newRow][newCol]
		return true
	}
	
	func isOnBoard(_ row: Int, _ col: Int) -> Bool {
		if row >= 8 || row < 0 || col >= 8 || col < 0 {
			return false
		}
		return true
	}
	func getImageFor(piece: Piece) -> UIImage {
		if piece.getSide() == Side.Black {
			let pieceType = piece.getType()
			switch pieceType {
				case Pieces.Knight:
					return BLACK_KNIGHT_IMAGE
				case Pieces.Bishop:
					return BLACK_BISHOP_IMAGE
				case Pieces.Rook:
					return BLACK_ROOK_IMAGE
				case Pieces.Blank:
					return BLANK_IMAGE
				case Pieces.King:
					return BLACK_KING_IMAGE
				case Pieces.Queen:
					return BLACK_QUEEN_IMAGE
				case Pieces.Pawn:
					return BLACK_PAWN_IMAGE
			}
		} else {
			let pieceType = piece.getType()
			switch pieceType {
				case Pieces.Knight:
					return WHITE_KNIGHT_IMAGE
				case Pieces.Bishop:
					return WHITE_BISHOP_IMAGE
				case Pieces.Rook:
					return WHITE_ROOK_IMAGE
				case Pieces.Blank:
					return BLANK_IMAGE
				case Pieces.King:
					return WHITE_KING_IMAGE
				case Pieces.Queen:
					return WHITE_QUEEN_IMAGE
				case Pieces.Pawn:
					return WHITE_PAWN_IMAGE
			}
		}
	}
	func flipBoard(bottom: Side) {
		if bottom == Side.Black {
			verticalStackView.transform = CGAffineTransform(rotationAngle: 180/180.0 * CGFloat.pi)
			for i in 0..<8 {
				for j in 0..<8 {
					userChessBoard[i][j].transform = CGAffineTransform(rotationAngle: 180/180.0 * CGFloat.pi)
				}
			}
		} else {
			verticalStackView.transform = CGAffineTransform(rotationAngle: 360/180.0 * CGFloat.pi)
			for i in 0..<8 {
				for j in 0..<8 {
					userChessBoard[i][j].transform = CGAffineTransform(rotationAngle: 360/180.0 * CGFloat.pi)
				}
			}
		}
		currentBottom = bottom
	}
	
	func getKing(side: Side) -> Piece? {
		for i in 0..<8 {
			for j in 0..<8 {
				let currentPiece = board[i][j]
				if currentPiece.getSide() == side && currentPiece is King {
					return currentPiece
				}
			}
		}
		//Could not find the side's king on the board
		print("ERROR: Could not find the side's king on the board")
		return nil
	}
	
	func redrawboard() {
		var isWhite = true
		for i in 0..<8 {
			var current = isWhite
			for j in 0..<8 {
				if current {
					if theme == Theme.Rustic {
						userChessBoard[i][j].setBackgroundImage(WHITE_TILE_IMAGE, for: UIControl.State.normal)
					} else {
						userChessBoard[i][j].backgroundColor = UIColor.white
					}
				} else {
					if theme == Theme.Rustic {
						userChessBoard[i][j].setBackgroundImage(BLACK_TILE_IMAGE, for: UIControl.State.normal)
					} else {
						userChessBoard[i][j].backgroundColor = PINK_COLOR
					}
				}
				userChessBoard[i][j].alpha = 1.0
				current = !current
				if board[i][j].getType() == Pieces.King {
					if let king = board[i][j] as? King {
						if king.isInCheck(gameBoard: self) {
							userChessBoard[i][j].setBackgroundImage(RED_TILE_IMAGE, for: UIControl.State.normal)
						}
					}
				}
			}
			isWhite = !isWhite
		}
		if lastMove.count != 0 {
			drawPathFrom(row: lastMove[0], col: lastMove[1], toRow: lastMove[2], andCol: lastMove[3])
		}
	}
	
	func drawPathFrom(row: Int, col: Int, toRow newRow: Int, andCol newCol: Int) {
		if lastPieceToMove.getType() == Pieces.Knight {
			if theme == Theme.Rustic {
				userChessBoard[row][col].setBackgroundImage(VISITED_TILE_IMAGE, for: UIControl.State.normal)
			} else {
				userChessBoard[row][col].backgroundColor = UIColor.lightGray
			}
		} else {
			var currentRow = row
			var currentCol = col
			repeat {
				if theme == Theme.Rustic {
					userChessBoard[currentRow][currentCol].setBackgroundImage(VISITED_TILE_IMAGE, for: UIControl.State.normal)
				} else {
					userChessBoard[currentRow][currentCol].backgroundColor = UIColor.lightGray
				}
				if currentRow != newRow {
					if currentRow > newRow {
						currentRow -= 1
					} else {
						currentRow += 1
					}
				}
				if currentCol != newCol {
					if currentCol > newCol {
						currentCol -= 1
					} else {
						currentCol += 1
					}
				}
			} while (currentRow != newRow || currentCol != newCol);
		}
	}
}
