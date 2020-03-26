//
//  Pieces.swift
//  Chess
//
//  Created by Devin Leamy on 2020-03-19.
//  Copyright © 2020 Devin Leamy. All rights reserved.
//

import Foundation
enum Pieces {
	case Knight
	case Pawn
	case Rook
	case Bishop
	case King
	case Queen
	case Blank
}
enum Side {
	case White
	case Black
	case Blank
}
enum GameState {
	case Finished
	case Paused
	case InProgress
}

enum GameResult {
	case Tied
	case WhiteWon
	case BlackWon
	case Undecided
}

enum GameTied {
	case InsufficientMaterial
	case StaleMate
	case Undecided
}

enum GameWon {
	case CheckMate
	case Resignation
	case TimeOut
	case Undecided
}
enum GameMode {
        case SinglePlayer //Versus computer
        case Multiplayer //Online
        case BluetoothMultiplayer //Bluetooth games
        case LocalMultiplayer //Two people play game on one device
}
