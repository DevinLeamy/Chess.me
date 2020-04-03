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

class ViewController: UIViewController {
	//Outlets
	@IBOutlet var toolBar: UIToolbar!
	@IBOutlet var gameBackgroundView: UIView!
	@IBOutlet var blackScorelbl: UILabel!
	@IBOutlet var whiteScorelbl: UILabel!
	@IBOutlet var verticalStackView: UIStackView!
	var userChessBoard = [[UIButton]]()
	var GAMEBOARD: Board!
	var GAME: Game!
	var WHITE: Team!
	var BLACK: Team!
	var mySide = Side.White //Default
	var engine : ChessEngine!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//Gets the buttons from the stackView and transfers them to an array
		getButtonsFromStackView()
	
		gameBackgroundView.layer.contents = (BACKGROUND_IMAGE).cgImage
		self.GAMEBOARD = Board(userChessBoard: userChessBoard, verticalStackView: verticalStackView)
		self.GAME = Game(white: Team(side: Side.White, teamScorelbl: whiteScorelbl), black: Team(side: Side.Black, teamScorelbl: blackScorelbl), board: GAMEBOARD)
		self.WHITE = GAME.getWhite()
		self.BLACK = GAME.getBlack()
		GAMEBOARD.setNextMoves()
		self.engine = ChessEngine(viewController: self)
		
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
		toolBar.barTintColor = UIColor.white
		
		//Commented out for testing
//		if selectedGameMode == GameMode.BluetoothMultiplayer {
//			if isHost {
//				mySide = Side.White
//			} else {
//				mySide = Side.Black
//			}
//		}
		
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
		} else if selectedGameMode == GameMode.BluetoothMultiplayer && mySide != GAMEBOARD.getTurn() {
			return
		} else if selectedGameMode == GameMode.SinglePlayer && GAMEBOARD.getTurn() != Side.White {
			engine.makeMove(board: GAMEBOARD, viewController: self)
		}
		let position = getPositionByTag(tag: sender.tag)
		let row = position[0]
		let col = position[1]
		let turn = GAMEBOARD.getTurn()
		if GAMEBOARD.board[row][col].getSide() == turn && !GAMEBOARD.tileSelected{
			GAMEBOARD.tileSelected = true
			GAMEBOARD.selectedTile = position
		} else if GAMEBOARD.board[row][col].getSide() != turn && GAMEBOARD.tileSelected{
			
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
			GAMEBOARD.makeMove(oldRow: GAMEBOARD.selectedTile[0], oldCol: GAMEBOARD.selectedTile[1], row: row, col: col, white: WHITE, black: BLACK,  uiViewController: self)
			GAMEBOARD.tileSelected = false
			GAMEBOARD.selectedTile = [-1, -1]
		} else if GAMEBOARD.board[row][col].getSide() == turn {
			GAMEBOARD.tileSelected = true
			GAMEBOARD.selectedTile = position
			let king = GAMEBOARD.getKing(side: GAMEBOARD.getTurn())! as! King //King is not found app will crash
			let kingRow = king.getPosition()[0]
			let kingCol = king.getPosition()[1]
			if king.isInCheck(gameBoard: GAMEBOARD) {
				GAMEBOARD.userChessBoard[kingRow][kingCol].setBackgroundImage(RED_TILE_IMAGE, for: UIControl.State.normal)
			}
		}
		GAMEBOARD.updateBoard(game: GAME, viewController: self)
		if selectedGameMode == GameMode.SinglePlayer && GAMEBOARD.getTurn() != Side.White {
			tileClicked(userChessBoard[0][0])
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
		GAME = Game(white: Team(side: Side.White, teamScorelbl: whiteScorelbl), black: Team(side: Side.Black, teamScorelbl: blackScorelbl), board: GAMEBOARD)
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
	//Receiving Date
	func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
		var move = Array<Int>(repeating: 0, count: data.count/MemoryLayout<Int>.stride)
		_ = move.withUnsafeMutableBytes { data.copyBytes(to: $0) }
		GAMEBOARD.makeMove(oldRow: move[0], oldCol: move[1], row: move[2], col: move[3], white: WHITE, black: BLACK, uiViewController: self)
	}
	
	func sendMove(move: [Int]) {
		//Commented out for testing
//		if mcSession.connectedPeers.count > 0 {
//			let moveData =  Data(buffer: UnsafeBufferPointer(start: move, count: move.count))
//			do {
//				try mcSession.send(moveData, toPeers: mcSession.connectedPeers, with: .reliable)
//			} catch let error as NSError {
//				let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
//				ac.addAction(UIAlertAction(title: "OK", style: .default))
//				present(ac, animated: true)
//			}
//
//		}
	}

}

