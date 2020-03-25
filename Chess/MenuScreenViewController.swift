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
let PINK_COLOR = UIColor.init(displayP3Red: 249/255.0, green: 214/255.0, blue: 215/255.0, alpha: 1)
extension NSMutableAttributedString {
	func setColorForText(_ textToFind: String, with color: UIColor) {
		let range = self.mutableString.range(of: textToFind, options: .caseInsensitive)
		if range.location != NSNotFound {
			addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
		}
	}
}
class MenuScreenViewController: UIViewController {
	
	@IBOutlet var decorationImage: UIImageView!
	@IBOutlet var changeGameModebtn: UIButton!
	@IBOutlet var introHeaderlbl: UILabel!
	@IBOutlet var playButton: UIButton!
	@IBOutlet var introBackgroundView: UIView!
	@IBOutlet var displayGameModelbl: UILabel!
	@IBOutlet var displayQuotelbl: UILabel!
	var gameModes: [String] = [String]()
	var chessQuotes: [[String]] = [[String]]()
	var currentRow = 0
	override func viewDidLoad() {
		super.viewDidLoad()
		
//		introHeaderlbl.layer.backgroundColor = UIColor.lightGray.cgColor
		introHeaderlbl.layer.borderColor = UIColor.black.cgColor
		introHeaderlbl.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 90)
//		introHeaderlbl.layer.borderWidth = 5
		
		introBackgroundView.layer.contents = (INTRO_BACKGROUND_IMAGE).cgImage
		
		changeGameModebtn.layer.cornerRadius = 20
		changeGameModebtn.layer.backgroundColor = UIColor.white.cgColor
		
		
		playButton.clipsToBounds = true
		playButton.layer.cornerRadius = 30
		playButton.layer.backgroundColor = PINK_COLOR.cgColor
		playButton.layer.borderWidth = 20
		playButton.layer.borderColor = UIColor.white.cgColor
		
//		displayGameModelbl.layer.backgroundColor = UIColor.lightGray.cgColor
//		displayGameModelbl.layer.borderColor = UIColor.black.cgColor
		displayGameModelbl.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 57)
		let text = NSMutableAttributedString(string: "Play.me")
		text.setColorForText("Play", with: UIColor.white)
		text.setColorForText(".me", with: UIColor.black)
		displayGameModelbl.attributedText = text
//		displayGameModelbl.layer.borderWidth = 2
		
		decorationImage.image = DECORATION_IMAGE //X = 11, Y = 179
		
		displayQuotelbl.textColor = UIColor.black
		displayQuotelbl.font = UIFont(name: "HelveticaNeue-LightItalic", size: 20)
		displayQuotelbl.lineBreakMode = NSLineBreakMode.byWordWrapping
		displayQuotelbl.numberOfLines = 3
		
                gameModes = ["me", "online", "local"]
		
		chessQuotes = [
			["Chess is a beautiful mistress.", "Bent Larsen"],
			["Chess demands total concentration.", "Bobby Fisher"],
			["Chess is everything: art, science and sport.", "Anatoly Karpov"]
		]
		setRandomQuote() //Puts and formats a random quote in the quoteDisplaylbl
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
		let text = NSMutableAttributedString(string: "Play." + gameModes[currentRow])
		text.setColorForText("Play", with: UIColor.white)
		text.setColorForText("." + gameModes[currentRow], with: UIColor.black)
		displayGameModelbl.attributedText = text
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
	
	func setRandomQuote() ->  Void {
		let randomInt = Int.random(in: 0..<chessQuotes.count)
		let name = chessQuotes[randomInt][1]
		let quote = chessQuotes[randomInt][0]
		displayQuotelbl.text = "\"" + quote + "\"" + "      -" + name
//		let text = NSMutableAttributeString
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
