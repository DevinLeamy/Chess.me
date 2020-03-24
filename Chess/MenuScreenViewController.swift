//
//  MenuScreenViewController.swift
//  Chess
//
//  Created by Devin Leamy on 2020-03-20.
//  Copyright © 2020 Devin Leamy. All rights reserved.
//

import UIKit

let INTRO_BACKGROUND_IMAGE = UIImage(named: "IntroBackgroundImage(3)")!
var selectedGameMode = GameMode.SinglePlayer

class MenuScreenViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
	
	@IBOutlet var playButton: UIButton!
	@IBOutlet var introBackgroundView: UIView!
	@IBOutlet var gameTypePickerView: UIPickerView!
	var gameModes: [String] = [String]()
	override func viewDidLoad() {
		super.viewDidLoad()
		introBackgroundView.layer.contents = (INTRO_BACKGROUND_IMAGE).cgImage
		playButton.contentHorizontalAlignment = .right;
		playButton.layer.zPosition = 10
		playButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 45.0)

                self.gameTypePickerView.delegate = self
                self.gameTypePickerView.dataSource = self
		
		
		gameTypePickerView.layer.zPosition = 5 //Makes the playButton go over the picker View
                gameModes = ["me", "online", "local"]
        // Do any additional setup after loading the view.
	}
    
	
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
                return 1
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
                return gameModes.count
        }
	
	func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

		var pickerLabel = view as? UILabel;
		pickerLabel = pickerLabel ?? UILabel()
		switch gameModes[row] {
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
		pickerLabel?.text = gameModes[row]
		pickerLabel?.textColor = UIColor.white
		pickerLabel?.font = UIFont(name: "HelveticaNeue", size: 45.0)
		pickerLabel?.textAlignment = NSTextAlignment.center
//		gameTypePickerView.subviews[0].isHidden = true
		return pickerLabel!
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
