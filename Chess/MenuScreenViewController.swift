//
//  MenuScreenViewController.swift
//  Chess
//
//  Created by Devin Leamy on 2020-03-20.
//  Copyright © 2020 Devin Leamy. All rights reserved.
//

import UIKit

let INTRO_BACKGROUND_IMAGE = UIImage(named: "IntroBackgroundImage(4)")!
var selectedGameMode = GameMode.SinglePlayer

class MenuScreenViewController: UIViewController {
	
	@IBOutlet var changeGameModebtn: UIButton!
	@IBOutlet var introHeaderlbl: UILabel!
	@IBOutlet var playButton: UIButton!
	@IBOutlet var introBackgroundView: UIView!
	@IBOutlet var displayGameModelbl: UILabel!
	var gameModes: [String] = [String]()
	var currentRow = 0
	override func viewDidLoad() {
		super.viewDidLoad()
		
		introHeaderlbl.layer.backgroundColor = UIColor.lightGray.cgColor
		introHeaderlbl.layer.borderColor = UIColor.black.cgColor
		introHeaderlbl.layer.borderWidth = 5
		
		introBackgroundView.layer.contents = (INTRO_BACKGROUND_IMAGE).cgImage
		
		changeGameModebtn.layer.cornerRadius = 10
		
		
		playButton.clipsToBounds = true
		playButton.layer.cornerRadius = 10
		playButton.layer.backgroundColor = UIColor.lightGray.cgColor
		
		displayGameModelbl.layer.backgroundColor = UIColor.lightGray.cgColor
		displayGameModelbl.layer.borderColor = UIColor.black.cgColor
		displayGameModelbl.layer.borderWidth = 1
		
                gameModes = ["me", "online", "local"]
	}
    
	
	@IBAction func changeGameMode(_ sender: UIButton) {
		currentRow += 1
		currentRow %= 3
		switch gameModes[currentRow] {
                        case "me":
                            selectedGameMode = GameMode.SinglePlayer
                        case "local":
                            selectedGameMode = GameMode.LocalMultiplayer
                        case "online":
                            selectedGameMode = GameMode.Multiplayer
                        //Add case where you are player two player on one device
                        default:
                            _ = true
                }
		displayGameModelbl.text = "Play." + gameModes[currentRow]
	}

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
