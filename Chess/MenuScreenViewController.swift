//
//  MenuScreenViewController.swift
//  Chess
//
//  Created by Devin Leamy on 2020-03-20.
//  Copyright © 2020 Devin Leamy. All rights reserved.
//

import UIKit
import MultipeerConnectivity

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
var peerID: MCPeerID!
var mcSession: MCSession!
var mcAdvertiserAssistant: MCAdvertiserAssistant!
var isHost = false

class MenuScreenViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {

	
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
		
		peerID = MCPeerID(displayName: UIDevice.current.name)
		mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
		mcSession.delegate = self
		
		
//		introHeaderlbl.layer.backgroundColor = UIColor.lightGray.cgColor
		introHeaderlbl.layer.borderColor = UIColor.black.cgColor
		introHeaderlbl.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 90)
//		introHeaderlbl.layer.borderWidth = 5
		
		introBackgroundView.layer.contents = (INTRO_BACKGROUND_IMAGE).cgImage
		
		changeGameModebtn.layer.cornerRadius = 20
		changeGameModebtn.layer.backgroundColor = UIColor.black.cgColor //UIColor.white.cgColor // original color
		
		
		playButton.clipsToBounds = true
		playButton.layer.cornerRadius = 30
		playButton.layer.backgroundColor = UIColor.black.cgColor //PINK_COLOR.cgColor // original color
		playButton.layer.borderWidth = 20
		playButton.layer.borderColor = UIColor.white.cgColor
		
//		displayGameModelbl.layer.backgroundColor = UIColor.lightGray.cgColor
//		displayGameModelbl.layer.borderColor = UIColor.black.cgColor
		displayGameModelbl.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 50)
		let text = NSMutableAttributedString(string: "Play.me")
		text.setColorForText("Play", with: UIColor.white)
		text.setColorForText(".me", with: UIColor.black)
		displayGameModelbl.attributedText = text
//		displayGameModelbl.layer.borderWidth = 2
		
		decorationImage.image = DECORATION_IMAGE //X = 11, Y = 179
		
		displayQuotelbl.textColor = UIColor.black
		displayQuotelbl.font = UIFont(name: "HelveticaNeue-LightItalic", size: 20)
		displayQuotelbl.lineBreakMode = NSLineBreakMode.byWordWrapping
		displayQuotelbl.numberOfLines = 4
		
                gameModes = ["me", "bluetooth", "online", "couple"]
		
		chessQuotes = [
			["Chess is a beautiful mistress.", "Bent Larsen"],
			["Chess demands total concentration.", "Bobby Fisher"],
			["Chess is everything: art, science and sport.", "Anatoly Karpov"],
			["It always starts with one move to bring down the king.", "Garry Kasprov"],
			["Chess is like life, you don't want to waste a move.", "Bing Gordan"],
			["Chess is war over the board. The object is to crush the opponent's mind", "Boris Spassky"]
		]
		setRandomQuote() //Puts and formats a random quote in the quoteDisplaylbl
	}
    
	
	@IBAction func hoverDisplay(_ sender: UIButton) {
		sender.alpha = 0.5
	}
	@IBAction func changeGameMode(_ sender: UIButton) {
		sender.alpha = 1
		currentRow += 1
		currentRow %= gameModes.count
		switch gameModes[currentRow] {
                        case gameModes[0]:
				selectedGameMode = GameMode.SinglePlayer
                        case gameModes[1]:
				selectedGameMode = GameMode.BluetoothMultiplayer
				let alert = UIAlertController(title: "Play.bluetooth", message: "Join or Host a Game Session", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: NSLocalizedString("Join", comment: "Default action"), style: .default, handler: joinSession))
				alert.addAction(UIAlertAction(title: NSLocalizedString("Host", comment: "Default action"), style: .default, handler: startHosting))
				alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .cancel, handler: stopBluetooth))
				self.present(alert, animated: true, completion: nil)
                        case gameModes[2]:
				selectedGameMode = GameMode.Multiplayer
			case gameModes[3]:
				selectedGameMode = GameMode.LocalMultiplayer
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
		displayQuotelbl.text = "\"" + quote + "\"" + "\n- " + name
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
	
	func startHosting(action: UIAlertAction!) {
		isHost = true
		mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-kb", discoveryInfo: nil, session: mcSession)
		mcAdvertiserAssistant.start()
	}

	func joinSession(action: UIAlertAction!) {
		isHost = false
		let mcBrowser = MCBrowserViewController(serviceType: "hws-kb", session: mcSession)
		mcBrowser.delegate = self
		present(mcBrowser, animated: true)
	}
	
	func stopBluetooth(_ : UIAlertAction?) {
		isHost = false
		selectedGameMode = GameMode.Multiplayer
		currentRow = 2
		
		let text = NSMutableAttributedString(string: "Play." + gameModes[currentRow])
		text.setColorForText("Play", with: UIColor.white)
		text.setColorForText("." + gameModes[currentRow], with: UIColor.black)
		displayGameModelbl.attributedText = text
		
		peerID = MCPeerID(displayName: UIDevice.current.name)
		mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
		mcSession.delegate = self
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
