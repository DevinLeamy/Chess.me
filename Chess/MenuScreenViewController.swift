//
//  MenuScreenViewController.swift
//  Chess
//
//  Created by Devin Leamy on 2020-03-20.
//  Copyright © 2020 Devin Leamy. All rights reserved.
//

import UIKit
let INTRO_BACKGROUND_IMAGE = UIImage(named: "IntroBackgroundImage(3)")!
class MenuScreenViewController: UIViewController {
	
	@IBOutlet var playButton: UIButton!
	@IBOutlet var introBackgroundView: UIView!
	override func viewDidLoad() {
		super.viewDidLoad()
		introBackgroundView.layer.contents = (INTRO_BACKGROUND_IMAGE).cgImage
		playButton.widthAnchor.constraint(equalToConstant: 275).isActive = true
		playButton.heightAnchor.constraint(equalToConstant: 400).isActive = true
        // Do any additional setup after loading the view.
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
