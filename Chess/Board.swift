//
//  File.swift
//  Chess
//
//  Created by Devin Leamy on 2020-03-19.
//  Copyright © 2020 Devin Leamy. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class Board {
	var board: [[Piece]] = Array(repeating: Array(repeating: Piece(currentRow: -1, currentCol: -1, side: Side.Blank, type: Pieces.Blank), count: 8), count: 8)
	var turn: Side
	var userChessBoard: [[UIButton]]
	var currentBottom = Side.White
	var verticalStackView: UIStackView
	var lastMove: [Int] = []
	var lastPieceToMove: Piece!
	var theme: Theme = Theme.Rustic
	var movesPlayed = 0
	var tileSelected: Bool = false
	var selectedTile: [Int] = [-1, -1]
	var audioPlayer = AVAudioPlayer()
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
	
	func makeMove(oldRow: Int, oldCol: Int, row: Int, col: Int, white: Team, black: Team, uiViewController: UIViewController) -> Void {
		var pieceBeingMoved = board[oldRow][oldCol]
		if !pieceBeingMoved.getNextMoves().contains([row, col]) {
			print("You are trying to make an invalid move")
			return
		}
		var moveType : MoveType = MoveType.Normal
		if pieceBeingMoved.getType() == Pieces.King {
			(pieceBeingMoved as! King).setCanCastle(canCastle: false)
		}
		movesPlayed += 1
		pieceBeingMoved.setPosition(currentRow: row, currentCol: col)
		
		if board[row][col].getType() != Pieces.Blank {
			moveType = MoveType.Capture
		}
		board[oldRow][oldCol] = Blank(currentRow: -1, currentCol: -1, side: Side.Blank, type: Pieces.Blank)
		if board[row][col].getType() != Pieces.Blank {
			let typeOfPieceCaptured = board[row][col].getType()
			if turn == Side.White {
				white.capturedPiece(piece: typeOfPieceCaptured)
			} else {
				black.capturedPiece(piece: typeOfPieceCaptured)
			}
		} else if pieceBeingMoved.getType() == Pieces.Pawn {
			if abs(oldCol - col) == 1 {
				//Therefore enpassent was performed
				if turn == Side.White {
					white.capturedPiece(piece: Pieces.Pawn)
				} else {
					black.capturedPiece(piece: Pieces.Pawn)
				}
				board[oldRow][col] = Blank(currentRow: -1, currentCol: -1, side: Side.Blank, type: Pieces.Blank)
				userChessBoard[oldRow][col].setImage(BLANK_IMAGE, for: UIControl.State.normal)
			}
		}
		board[row][col] = pieceBeingMoved
		lastMove = [oldRow, oldCol, row, col]
		lastPieceToMove = board[row][col]
		
		
		if pieceBeingMoved.getType() == Pieces.Rook {
			(pieceBeingMoved as! Rook).setCanCastle(canCastle: false)
		} else if pieceBeingMoved.getType() == Pieces.King {
			(pieceBeingMoved as! King).setCanCastle(canCastle: false)
			if abs(oldCol - col) == 2 {
				//Castled
				if col > oldCol {
					//King side
					let rookBeingMoved = (board[row][7] as! Rook)
					rookBeingMoved.setPosition(currentRow: row, currentCol: col-1)
					rookBeingMoved.setCanCastle(canCastle: false)
					board[row][col-1] = rookBeingMoved
					board[row][7] = Blank(currentRow: -1, currentCol: -1, side: Side.Blank, type: Pieces.Blank)
					//Draw the rook in its new position
					userChessBoard[row][col-1].setImage(getImageFor(piece: rookBeingMoved), for: UIControl.State.normal)
					userChessBoard[row][7].setImage(BLANK_IMAGE, for: UIControl.State.normal)
				} else {
					//Queen side
					let rookBeingMoved = (board[row][0] as! Rook)
					rookBeingMoved.setPosition(currentRow: row, currentCol: col+1)
					rookBeingMoved.setCanCastle(canCastle: false)
					board[row][col+1] = rookBeingMoved
					board[row][0] = Blank(currentRow: -1, currentCol: -1, side: Side.Blank, type: Pieces.Blank)
					//Draw the rook in its new position
					userChessBoard[row][col+1].setImage(getImageFor(piece: rookBeingMoved), for: UIControl.State.normal)
					userChessBoard[row][0].setImage(BLANK_IMAGE, for: UIControl.State.normal)
				}
			}
		} else if pieceBeingMoved.getType() == Pieces.Pawn {
			if abs(row - oldRow) == 2 {
				(pieceBeingMoved as! Pawn).setMovedTwice(movedTwice: true)
			} else if row == 0 || row == 7 {
				pieceBeingMoved = Queen(currentRow: row, currentCol: col,  side: pieceBeingMoved.getSide(), type: Pieces.Queen)
				board[row][col] = pieceBeingMoved
				board[row][col].setNextMoves(board: self)
			}
		}
		userChessBoard[row][col].setImage(getImageFor(piece: pieceBeingMoved), for: UIControl.State.normal)
		userChessBoard[oldRow][oldCol].setImage(BLANK_IMAGE, for: UIControl.State.normal)
		changeTurn()
		if selectedGameMode == GameMode.LocalMultiplayer {
			flipBoard(bottom: getTurn())
		}
		let king = getKing(side: getTurn())! as! King //King is not found app will crash
		let kingRow = king.getPosition()[0]
		let kingCol = king.getPosition()[1]
		if king.isInCheck(gameBoard: self) {
			userChessBoard[kingRow][kingCol].setBackgroundImage(RED_TILE_IMAGE, for: UIControl.State.normal)
			moveType = MoveType.Check
		}
		if selectedGameMode == GameMode.BluetoothMultiplayer {
			let viewController = (uiViewController as! ViewController)
			viewController.sendMove(move: [oldRow, oldCol, row, col])
		}
		switch moveType {
			case MoveType.Capture:
				playSound(fileName: PIECE_CAPTURED_SOUND)
			case MoveType.Normal:
				playSound(fileName: GENERIC_MOVE_SOUND)
			case MoveType.Check:
				playSound(fileName: PUT_IN_CHECK_SOUND)
		}
	}
	
	func isOnBoard(_ row: Int, _ col: Int) -> Bool {
		if row >= 8 || row < 0 || col >= 8 || col < 0 {
			return false
		}
		return true
	}
	
	
	func updateBoard(game: Game, viewController: ViewController) {
		redrawboard()
		
		if game.gameIsOver() {
			let gameResultInfo = game.getGameResult()
			
			let alert = UIAlertController(title: "GameOver", message: (gameResultInfo[0] as! String), preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
				viewController.dismiss(animated: true, completion: nil)
				//ADD: Disconnect the player from the bluetooth host or, if host, stop hosting
				viewController.restartGame()
			}))
			viewController.present(alert, animated: true, completion: nil)
			print(gameResultInfo[0])
		}
		
		if game.white.score > game.black.score {
			game.white.teamScorelbl.text = "+\(game.white.score - game.black.score)"
			game.black.teamScorelbl.text = ""
		} else if game.white.score < game.black.score {
			game.white.teamScorelbl.text = ""
			game.black.teamScorelbl.text = "+\(game.black.score - game.white.score)"
		} else {
			game.white.teamScorelbl.text = ""
			game.black.teamScorelbl.text = ""
		}
		
		//Tints the tiles that can be traveled to
		if tileSelected {
			let pieceSelected = board[selectedTile[0]][selectedTile[1]]
			for move in pieceSelected.getNextMoves() {
				if move.count == 0 {continue}
				if theme == Theme.Rustic {
					userChessBoard[move[0]][move[1]].setBackgroundImage(POSSIBLE_MOVES_TILE_IMAGE, for: UIControl.State.normal)
				} else {
					userChessBoard[move[0]][move[1]].backgroundColor = UIColor.lightGray
				}
			}
		}
		
		
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
	
	func playSound(fileName : String) -> Void {
		let path = Bundle.main.path(forResource: fileName, ofType: nil)!
		let url = URL(fileURLWithPath: path)
		
		
		do {
		    //create your audioPlayer in your parent class as a property
			audioPlayer = try AVAudioPlayer(contentsOf: url)
			audioPlayer.play()
		} catch {
			print("ERROR: Unable to play made move sound")
		}
	}
}
