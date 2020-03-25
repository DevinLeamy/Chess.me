//
//  MenuScreenViewController.swift
//  Chess
//
//  Created by Devin Leamy on 2020-03-20.
//  Copyright © 2020 Devin Leamy. All rights reserved.
//

import UIKit

let INTRO_BACKGROUND_IMAGE = UIImage(named: "IntroBackgroundImage(3)")!
let DECORATION_IMAGE = UIImage(named: "DecorationImage(3)")
var selectedGameMode = GameMode.SinglePlayer

class MenuScreenViewController: UIViewController {
	
	@IBOutlet var decorationImage: UIImageView!
	@IBOutlet var changeGameModebtn: UIButton!
	@IBOutlet var introHeaderlbl: UILabel!
	@IBOutlet var playButton: UIButton!
	@IBOutlet var introBackgroundView: UIView!
	@IBOutlet var displayGameModelbl: UILabel!
	var gameModes: [String] = [String]()
	var currentRow = 0
	override func viewDidLoad() {
		super.viewDidLoad()
		
//		introHeaderlbl.layer.backgroundColor = UIColor.lightGray.cgColor
		introHeaderlbl.layer.borderColor = UIColor.black.cgColor
//		introHeaderlbl.layer.borderWidth = 5
		
		introBackgroundView.layer.contents = (INTRO_BACKGROUND_IMAGE).cgImage
		
		changeGameModebtn.layer.cornerRadius = 20
		changeGameModebtn.layer.backgroundColor = UIColor.white.cgColor
		
		
		playButton.clipsToBounds = true
		playButton.layer.cornerRadius = 20
		playButton.layer.backgroundColor = UIColor.white.cgColor
//		playButton.layer.borderWidth = 3
		
//		displayGameModelbl.layer.backgroundColor = UIColor.lightGray.cgColor
		displayGameModelbl.layer.borderColor = UIColor.black.cgColor
//		displayGameModelbl.layer.borderWidth = 2
		
		decorationImage.image = DECORATION_IMAGE
		
                gameModes = ["me", "online", "local"]
	}
    
	
	@IBAction func hoverDisplay(_ sender: UIButton) {
		sender.alpha = 0.5
	}
	@IBAction func changeGameMode(_ sender: UIButton) {
		sender.alpha = 1
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
	
	@IBAction func showGameViewController(_ sender: UIButton) {
		sender.alpha = 1
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let secondVC = storyboard.instantiateViewController(identifier: "gameViewController")
		show(secondVC, sender: self)
	}
	
	@IBAction func hoverPlayButton(_ sender: UIButton) {
		sender.alpha = 0.5
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
