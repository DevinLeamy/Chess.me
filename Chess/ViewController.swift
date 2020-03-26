//
//  ViewController.swift
//  Chess
//
//  Created by Devin Leamy on 2020-03-19.
//  Copyright © 2020 Devin Leamy. All rights reserved.
//

import UIKit
import MultipeerConnectivity

let WHITE_TILE_IMAGE = UIImage(named: "LightWoodTile")!
let BLACK_TILE_IMAGE = UIImage(named: "DarkWoodTile(2)")!
let BLACK_KING_IMAGE = UIImage(named: "BlackKing")!
let WHITE_KING_IMAGE = UIImage(named: "WhiteKing")!
let WHITE_QUEEN_IMAGE = UIImage(named: "WhiteQueen")!
let BLACK_QUEEN_IMAGE = UIImage(named: "BlackQueen")!
let WHITE_ROOK_IMAGE = UIImage(named: "WhiteRook")!
let BLACK_ROOK_IMAGE = UIImage(named: "BlackRook")!
let WHITE_KNIGHT_IMAGE = UIImage(named: "WhiteKnight")!
let BLACK_KNIGHT_IMAGE = UIImage(named: "BlackKnight")!
let WHITE_BISHOP_IMAGE = UIImage(named: "WhiteBishop")!
let BLACK_BISHOP_IMAGE = UIImage(named: "BlackBishop")!
let WHITE_PAWN_IMAGE = UIImage(named: "WhitePawn")!
let BLACK_PAWN_IMAGE = UIImage(named: "BlackPawn")!
let BLANK_IMAGE = UIImage(named: "Blank")!
let RED_TILE_IMAGE = UIImage(named: "RedTile")!
let BACKGROUND_IMAGE = UIImage(named: "IntroBackgroundImage(3)")!
let RETRY_LOGO_IMAGE = UIImage(named: "RetryLogo(1)")!
let VISITED_TILE_IMAGE = UIImage(named: "DarkWoodTile(3)")
let FLIPBOARD_LOGO_IMAGE = UIImage(named: "FlipLogo(2)")!

class ViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
	//Outlets
	@IBOutlet var toolBar: UIToolbar!
	@IBOutlet var gameBackgroundView: UIView!
	@IBOutlet var blackScorelbl: UILabel!
	@IBOutlet var whiteScorelbl: UILabel!
	@IBOutlet var verticalStackView: UIStackView!
	var userChessBoard = [[UIButton]]()
	var GAMEBOARD: Board = Board(userChessBoard: [[]], verticalStackView: nil)
	var GAME: Game = Game(white: Team(side: Side.Blank), black: Team(side: Side.Blank), board: Board(userChessBoard: [[]], verticalStackView: nil))
	var WHITE: Team = Team(side: Side.Blank)
	var BLACK: Team = Team(side: Side.Blank)
	var tileSelected = false
	var selectedTile = [-1, -1]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//Gets the buttons from the stackView and transfers them to an array
		getButtonsFromStackView()
	
		gameBackgroundView.layer.contents = (BACKGROUND_IMAGE).cgImage
		GAMEBOARD = Board(userChessBoard: userChessBoard, verticalStackView: verticalStackView)
		GAME = Game(white: Team(side: Side.White), black: Team(side: Side.Black), board: GAMEBOARD)
		WHITE = GAME.getWhite()
		BLACK = GAME.getBlack()
		GAMEBOARD.setNextMoves()
		
		initializeGameBoard()
//		
//		let spacer = UIBarButtonItem(
//			barButtonSystemItem: .flexibleSpace,
//			target: nil,
//			action: nil
//		)
		
		let flipBoardBarBtn = UIBarButtonItem(
			image: FLIPBOARD_LOGO_IMAGE,
			style: UIBarButtonItem.Style.plain,
			target: self,
			action: #selector(flipBoardAction)
		)
		flipBoardBarBtn.tintColor = UIColor.black
		
//		
//		let retryBarBtn = UIBarButtonItem(
//			image: RETRY_LOGO_IMAGE,
//			style: UIBarButtonItem.Style.plain,
//			target: self,
//			action: #selector(restartGame)
//		)
//		retryBarBtn.tintColor = UIColor.black
	
		
		toolBar.items = [
			flipBoardBarBtn
//			,spacer,
//			retryBarBtn
		]
		toolBar.sizeToFit()
		
	}
	func getButtonsFromStackView() -> Void {
		for case let horizontalStackView as UIStackView in verticalStackView.arrangedSubviews {
			var buttonRow = [UIButton]()
			for case let button as UIButton in horizontalStackView.arrangedSubviews {
				buttonRow.append(button)
			}
			userChessBoard.append(buttonRow)
		}
	}
	@objc func tileClicked(_ sender: UIButton) {
		//If the game is over don't allow player to change
		if GAME.gameState == GameState.Finished {
			return
		}
		let position = getPositionByTag(tag: sender.tag)
		let row = position[0]
		let col = position[1]
		let turn = GAMEBOARD.getTurn()
		if GAMEBOARD.board[row][col].getSide() == turn && !tileSelected{
			tileSelected = true
			selectedTile = position
		} else if GAMEBOARD.board[row][col].getSide() != turn && tileSelected{
			
			//Makes sure enpassant can't be performed after it legally could
			for i in 0..<8 {
				for j in 0..<8 {
					if GAMEBOARD.board[i][j].getType() == Pieces.Pawn {
						if GAMEBOARD.board[i][j].getSide() == GAMEBOARD.getTurn() {
							(GAMEBOARD.board[i][j] as! Pawn).setMovedTwice(movedTwice: false)
						}
					}
				}
			}
			
			//One tile has already been selected
			let oldRow = selectedTile[0]
			let oldCol = selectedTile[1]
			var pieceBeingMoved = GAMEBOARD.board[oldRow][oldCol]
			if GAMEBOARD.makeMove(oldRow: oldRow, oldCol: oldCol, newRow: row, newCol: col, white: WHITE, black: BLACK, buttonChessBoard: userChessBoard) {
				if pieceBeingMoved.getType() == Pieces.Rook {
					(pieceBeingMoved as! Rook).setCanCastle(canCastle: false)
				} else if pieceBeingMoved.getType() == Pieces.King {
					(pieceBeingMoved as! King).setCanCastle(canCastle: false)
					if abs(oldCol - col) == 2 {
						//Castled
						if col > oldCol {
							//King side
							let rookBeingMoved = (GAMEBOARD.board[row][7] as! Rook)
							rookBeingMoved.setPosition(currentRow: row, currentCol: col-1)
							rookBeingMoved.setCanCastle(canCastle: false)
							GAMEBOARD.board[row][col-1] = rookBeingMoved
							GAMEBOARD.board[row][7] = Blank(currentRow: -1, currentCol: -1, side: Side.Blank, type: Pieces.Blank)
							//Draw the rook in its new position
							GAMEBOARD.userChessBoard[row][col-1].setImage(GAMEBOARD.getImageFor(piece: rookBeingMoved), for: UIControl.State.normal)
							GAMEBOARD.userChessBoard[row][7].setImage(BLANK_IMAGE, for: UIControl.State.normal)
						} else {
							//Queen side
							let rookBeingMoved = (GAMEBOARD.board[row][0] as! Rook)
							rookBeingMoved.setPosition(currentRow: row, currentCol: col+1)
							rookBeingMoved.setCanCastle(canCastle: false)
							GAMEBOARD.board[row][col+1] = rookBeingMoved
							GAMEBOARD.board[row][0] = Blank(currentRow: -1, currentCol: -1, side: Side.Blank, type: Pieces.Blank)
							//Draw the rook in its new position
							GAMEBOARD.userChessBoard[row][col+1].setImage(GAMEBOARD.getImageFor(piece: rookBeingMoved), for: UIControl.State.normal)
							GAMEBOARD.userChessBoard[row][0].setImage(BLANK_IMAGE, for: UIControl.State.normal)
						}
					}
				} else if pieceBeingMoved.getType() == Pieces.Pawn {
					if abs(row - oldRow) == 2 {
						(pieceBeingMoved as! Pawn).setMovedTwice(movedTwice: true)
					} else if row == 0 || row == 7 {
						pieceBeingMoved = Queen(currentRow: row, currentCol: col,  side: pieceBeingMoved.getSide(), type: Pieces.Queen)
						GAMEBOARD.board[row][col] = pieceBeingMoved
						GAMEBOARD.board[row][col].setNextMoves(board: GAMEBOARD)
					}
				}
				GAMEBOARD.userChessBoard[row][col].setImage(GAMEBOARD.getImageFor(piece: pieceBeingMoved), for: UIControl.State.normal)
				GAMEBOARD.userChessBoard[oldRow][oldCol].setImage(BLANK_IMAGE, for: UIControl.State.normal)
				GAMEBOARD.changeTurn()
				if selectedGameMode == GameMode.LocalMultiplayer {
					GAMEBOARD.flipBoard(bottom: GAMEBOARD.getTurn())
				}
				let king = GAMEBOARD.getKing(side: GAMEBOARD.getTurn())! as! King //King is not found app will crash
				let kingRow = king.getPosition()[0]
				let kingCol = king.getPosition()[1]
				if king.isInCheck(gameBoard: GAMEBOARD) {
					GAMEBOARD.userChessBoard[kingRow][kingCol].setBackgroundImage(RED_TILE_IMAGE, for: UIControl.State.normal)
				}
				
			}
			tileSelected = false
			selectedTile = [-1, -1]
		} else if GAMEBOARD.board[row][col].getSide() == turn {
			tileSelected = true
			selectedTile = position
			let king = GAMEBOARD.getKing(side: GAMEBOARD.getTurn())! as! King //King is not found app will crash
			let kingRow = king.getPosition()[0]
			let kingCol = king.getPosition()[1]
			if king.isInCheck(gameBoard: GAMEBOARD) {
				GAMEBOARD.userChessBoard[kingRow][kingCol].setBackgroundImage(RED_TILE_IMAGE, for: UIControl.State.normal)
			}
		}
		GAMEBOARD.redrawboard()
		
		if GAME.gameIsOver() {
			let gameResultInfo = GAME.getGameResult()
			
			let alert = UIAlertController(title: "GameOver", message: (gameResultInfo[0] as! String), preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
				let storyboard = UIStoryboard(name: "Main", bundle: nil)
				let secondVC = storyboard.instantiateViewController(identifier: "menuViewController")
				self.show(secondVC, sender: nil)
				self.restartGame()
			}))
			self.present(alert, animated: true, completion: nil)
			print(gameResultInfo[0])
		}
		
		if WHITE.score > BLACK.score {
			whiteScorelbl.text = "+\(WHITE.score - BLACK.score)"
			blackScorelbl.text = ""
		} else if WHITE.score < BLACK.score {
			whiteScorelbl.text = ""
			blackScorelbl.text = "+\(BLACK.score - WHITE.score)"
		} else {
			whiteScorelbl.text = ""
			blackScorelbl.text = ""
		}
		
		
		//Tints the tiles that can be traveled to
		if tileSelected {
			let pieceSelected = GAMEBOARD.board[selectedTile[0]][selectedTile[1]]
			for move in pieceSelected.getNextMoves() {
				if move.count == 0 {continue}
				if GAMEBOARD.theme == Theme.Rustic {
					GAMEBOARD.userChessBoard[move[0]][move[1]].setBackgroundImage(VISITED_TILE_IMAGE, for: UIControl.State.normal)
				} else {
					GAMEBOARD.userChessBoard[move[0]][move[1]].backgroundColor = UIColor.lightGray
				}
			}
		}
	}

	func initializeGameBoard() -> Void {
		var isWhite = true
		var currentTag = 0
		for i in 0..<8 {
			var current = isWhite
			for j in 0..<8 {
				//Sets the tag of the button so we can identify the location in the array of every button object
				GAMEBOARD.userChessBoard[i][j].tag = currentTag
				
				//Sets the action for the buttons so I can act on taps
				GAMEBOARD.userChessBoard[i][j].addTarget(self, action: #selector(tileClicked), for: UIControl.Event.touchUpInside)
				
				//Makes the size of the tiles fixed
				GAMEBOARD.userChessBoard[i][j].widthAnchor.constraint(equalToConstant: 50).isActive = true
				GAMEBOARD.userChessBoard[i][j].heightAnchor.constraint(equalToConstant: 50).isActive = true
				
				let buttonImage = GAMEBOARD.getImageFor(piece: GAMEBOARD.board[i][j])
				if (current) {
					if GAMEBOARD.theme == Theme.Rustic {
						GAMEBOARD.userChessBoard[i][j].setBackgroundImage(WHITE_TILE_IMAGE, for: UIControl.State.normal)
					} else {
						GAMEBOARD.userChessBoard[i][j].backgroundColor = UIColor.white
					}
				} else {
					if GAMEBOARD.theme == Theme.Rustic {
						GAMEBOARD.userChessBoard[i][j].setBackgroundImage(BLACK_TILE_IMAGE, for: UIControl.State.normal)
					} else {
						GAMEBOARD.userChessBoard[i][j].backgroundColor = PINK_COLOR
					}
				}
				
				//Sets the background image
				GAMEBOARD.userChessBoard[i][j].setTitle("", for: UIControl.State.normal)
				GAMEBOARD.userChessBoard[i][j].setImage(buttonImage, for: UIControl.State.normal)
				current = !current
				currentTag += 1
			}
			isWhite = !isWhite
			
		}
	}
	func getPositionByTag(tag: Int) -> [Int] {
		return [tag/8, tag % 8]
	}
	
	@objc func restartGame() {
		GAMEBOARD = Board(userChessBoard: userChessBoard, verticalStackView: verticalStackView)
		GAME = Game(white: Team(side: Side.White), black: Team(side: Side.Black), board: GAMEBOARD)
		WHITE = GAME.getWhite()
		BLACK = GAME.getBlack()
		GAMEBOARD.setNextMoves()
		initializeGameBoard()
		whiteScorelbl.text = ""
		blackScorelbl.text = ""
		GAMEBOARD.flipBoard(bottom: Side.White)
		GAMEBOARD.redrawboard()
	}
	
	@objc func flipBoardAction() {
		if GAMEBOARD.currentBottom == Side.White {
			GAMEBOARD.flipBoard(bottom: Side.Black)
		} else {
			GAMEBOARD.flipBoard(bottom: Side.White)
		}
	}
	
	//MPConnectivity
	func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
		  switch state {
			  case MCSessionState.connected:
			      print("Connected: \(peerID.displayName)")

			  case MCSessionState.connecting:
			      print("Connecting: \(peerID.displayName)")

			  case MCSessionState.notConnected:
			      print("Not Connected: \(peerID.displayName)")
			@unknown default:
				fatalError()
			}
	}
	
	func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
		
	}
	
	func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {

	}

	func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {

	}

	func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {

	}

	func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
		dismiss(animated: true)
	}

	func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
		dismiss(animated: true)
	}

}

