//
//  Team.swift
//  Chess
//
//  Created by Devin Leamy on 2020-03-19.
//  Copyright © 2020 Devin Leamy. All rights reserved.
//

import Foundation
import UIKit

class Team {
	var score = 0
	var piecesCaptured = [Pieces]()
	var side: Side
	var teamScorelbl: UILabel
	init(side: Side, teamScorelbl: UILabel) {
		self.side = side
		self.teamScorelbl = teamScorelbl
	}
	
	func capturedPiece(piece: Pieces) {
		var points = 0
		switch piece {
			case Pieces.Knight:
				points = 3
			case Pieces.Bishop:
				points = 3
			case Pieces.King:
				points = 1000
			case Pieces.Queen:
				points = 9
			case Pieces.Pawn:
				points = 1
			case Pieces.Rook:
				points = 5
			case Pieces.Blank:
				points = 0
		}
		score += points
		piecesCaptured.append(piece)
	}
}
