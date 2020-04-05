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
let STICKMAN_FIGURE = UIImage(named: "StickFigure(3)")!
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
let OptionsLblFontName = "HelveticaNeue-Thin"
let OptionsLblPositionAndSize = [100.adjustedWidth, 250.adjustedWidth, 58.adjustedHeight, 45.adjustedHeight, 20.adjustedHeight] //X Coord, Width, Height, Font size, Corner radius
let OptionsVerticalSpace = 100.adjustedHeight
let OptionsBtnPositionAndSize = [360.adjustedWidth, 45.adjustedWidth, 45.adjustedWidth, (22.5).adjustedWidth] //X Coord, Width, Height, Corner Radius
let FirstOptionLblDistanceFromTop = 180.adjustedHeight
let FirstOptionBtnDistanceFromTop = (186.5).adjustedHeight
class MenuScreenViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
	var gameModes: [String] = [String]()
	var chessQuotes: [[String]] = [[String]]()
	var currentRow = 0
	
	
	@IBOutlet var introBackgroundView: UIView!
	//Initialize Buttons and labels
	let introHeaderlbl = UILabel(frame:
		CGRect(x: (UIScreen.main.bounds.width / 2) - (75.adjustedHeight),
		       y: 725.adjustedHeight,
		       width: 150.adjustedHeight,
		       height: 150.adjustedHeight)
	)
	
	let playlbl = UILabel(frame:
		CGRect(x: 20.adjustedWidth,
		       y: 70.adjustedHeight,
		       width: 500.adjustedWidth,
		       height: 90.adjustedHeight)
	)
	
	let stickManlbl = UIImageView(frame:
		CGRect(x: 40.adjustedWidth,
		       y: 650.adjustedHeight,
		       width: 75.adjustedHeight,
		       height: 150.adjustedHeight)
	)
	//.me
	let dotMelbl = UILabel(frame:
		CGRect(x: OptionsLblPositionAndSize[0],
		       y: FirstOptionLblDistanceFromTop,
		       width: OptionsLblPositionAndSize[1],
		       height: OptionsLblPositionAndSize[2])
	)
	let dotMebtn = UIButton(frame:
		CGRect(x: OptionsBtnPositionAndSize[0],
		       y: FirstOptionBtnDistanceFromTop,
		       width: OptionsBtnPositionAndSize[1],
		       height: OptionsBtnPositionAndSize[2])
	)
	
	//.bluetooth
	let dotBluetoothlbl = UILabel(frame:
		CGRect(x: OptionsLblPositionAndSize[0],
		       y: FirstOptionLblDistanceFromTop + (OptionsVerticalSpace * 1),
		       width: OptionsLblPositionAndSize[1],
		       height: OptionsLblPositionAndSize[2])
	)
	let dotBluetoothbtn = UIButton(frame:
		CGRect(x: OptionsBtnPositionAndSize[0],
		       y: FirstOptionBtnDistanceFromTop + (OptionsVerticalSpace * 1),
		       width: OptionsBtnPositionAndSize[1],
		       height: OptionsBtnPositionAndSize[2])
	)
	
	//.online
	let dotOnlinelbl = UILabel(frame:
		CGRect(x: OptionsLblPositionAndSize[0],
			y: FirstOptionLblDistanceFromTop + (OptionsVerticalSpace * 2),
			width: OptionsLblPositionAndSize[1],
			height: OptionsLblPositionAndSize[2])
	)
	let dotOnlinebtn = UIButton(frame:
		CGRect(x: OptionsBtnPositionAndSize[0],
		       y: FirstOptionBtnDistanceFromTop + (OptionsVerticalSpace * 2),
		       width: OptionsBtnPositionAndSize[1],
		       height: OptionsBtnPositionAndSize[2])
	)
	
	//.online
	let dotCouplelbl = UILabel(frame:
		CGRect(x: OptionsLblPositionAndSize[0],
			y: FirstOptionLblDistanceFromTop + (OptionsVerticalSpace * 3),
			width: OptionsLblPositionAndSize[1],
			height: OptionsLblPositionAndSize[2])
	)
	let dotCouplebtn = UIButton(frame:
		CGRect(x: OptionsBtnPositionAndSize[0],
		       y: FirstOptionBtnDistanceFromTop + (OptionsVerticalSpace * 3),
		       width: OptionsBtnPositionAndSize[1],
		       height: OptionsBtnPositionAndSize[2])
	)
	
	let displayQuotelbl = UILabel(frame:
		CGRect(x: 7.adjustedWidth,
		       y: 550.adjustedHeight,
		       width: 400.adjustedWidth,
		       height: 175.adjustedHeight
		)
	)
	
	//Random Quote display
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		//Initialize multipeer connectivity stuff
		peerID = MCPeerID(displayName: UIDevice.current.name)
		mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .optional)
		mcSession.delegate = self
		
		//Chess.me tag lbl
		introHeaderlbl.text = "Chess.me"
		introHeaderlbl.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 32.adjustedHeight)
		introHeaderlbl.textColor = UIColor.black
		introHeaderlbl.backgroundColor = UIColor.white
		introHeaderlbl.layer.cornerRadius = 75.adjustedHeight
		introHeaderlbl.textAlignment = NSTextAlignment.center
		introHeaderlbl.clipsToBounds = true
		self.view.addSubview(introHeaderlbl)
		
		//Play header label
		playlbl.text = "Chess"
		playlbl.font = UIFont(name: "HelveticaNeue", size: 75.adjustedWidth)
		playlbl.textColor = UIColor.white
		self.view.addSubview(playlbl)
		
		//Stick man decoration image
		stickManlbl.contentMode = UIView.ContentMode.scaleToFill
		stickManlbl.image = STICKMAN_FIGURE
		self.view.addSubview(stickManlbl)
		
		//.me option
		//1) .me label
		dotMelbl.text = " .me"
		dotMelbl.font = UIFont(name: OptionsLblFontName, size: OptionsLblPositionAndSize[3])
		dotMelbl.textColor = UIColor.black
		dotMelbl.backgroundColor = UIColor.white
		dotMelbl.layer.cornerRadius = OptionsLblPositionAndSize[4]
		dotMelbl.clipsToBounds = true
		self.view.addSubview(dotMelbl)
		
		//2) .me btn
		dotMebtn.layer.cornerRadius = OptionsBtnPositionAndSize[3]
		dotMebtn.layer.backgroundColor = UIColor.black.cgColor
		dotMebtn.layer.borderColor = UIColor.white.cgColor
		dotMebtn.layer.borderWidth = 3
		dotMebtn.addTarget(self, action: #selector(hoverDisplay), for: UIControl.Event.touchDown)
		dotMebtn.addTarget(self, action: #selector(playDotMe), for: UIControl.Event.touchUpInside)
		self.view.addSubview(dotMebtn)
		
		//.bluetooth option
		//1) .bluetooth label
		dotBluetoothlbl.text = " .bluetooth"
		dotBluetoothlbl.font = UIFont(name: OptionsLblFontName, size: OptionsLblPositionAndSize[3])
		dotBluetoothlbl.textColor = UIColor.black
		dotBluetoothlbl.backgroundColor = UIColor.white
		dotBluetoothlbl.layer.cornerRadius = OptionsLblPositionAndSize[4]
		dotBluetoothlbl.clipsToBounds = true
		self.view.addSubview(dotBluetoothlbl)
		
		//2) .bluetooth btn
		dotBluetoothbtn.layer.cornerRadius = OptionsBtnPositionAndSize[3]
		dotBluetoothbtn.layer.backgroundColor = UIColor.black.cgColor
		dotBluetoothbtn.layer.borderColor = UIColor.white.cgColor
		dotBluetoothbtn.layer.borderWidth = 3
		dotBluetoothbtn.addTarget(self, action: #selector(hoverDisplay), for: UIControl.Event.touchDown)
		dotBluetoothbtn.addTarget(self, action: #selector(playDotBluetooth), for: UIControl.Event.touchUpInside)
		self.view.addSubview(dotBluetoothbtn)
		
		// .online option
		//1) .online lbl
		dotOnlinelbl.text = " .online"
		dotOnlinelbl.font = UIFont(name: OptionsLblFontName, size: OptionsLblPositionAndSize[3])
		dotOnlinelbl.textColor = UIColor.black
		dotOnlinelbl.backgroundColor = UIColor.white
		dotOnlinelbl.layer.cornerRadius = OptionsLblPositionAndSize[4]
		dotOnlinelbl.clipsToBounds = true
		self.view.addSubview(dotOnlinelbl)
		
		//2) .online btn
		dotOnlinebtn.layer.cornerRadius = OptionsBtnPositionAndSize[3]
		dotOnlinebtn.layer.backgroundColor = UIColor.black.cgColor
		dotOnlinebtn.layer.borderColor = UIColor.white.cgColor
		dotOnlinebtn.layer.borderWidth = 3
		dotOnlinebtn.addTarget(self, action: #selector(hoverDisplay), for: UIControl.Event.touchDown)
		dotOnlinebtn.addTarget(self, action: #selector(playDotOnline), for: UIControl.Event.touchUpInside)
		self.view.addSubview(dotOnlinebtn)
		
		// .couple option
		//1) .couple lbl
		dotCouplelbl.text = " .couple"
		dotCouplelbl.font = UIFont(name: OptionsLblFontName, size: OptionsLblPositionAndSize[3])
		dotCouplelbl.textColor = UIColor.black
		dotCouplelbl.backgroundColor = UIColor.white
		dotCouplelbl.layer.cornerRadius = OptionsLblPositionAndSize[4]
		dotCouplelbl.clipsToBounds = true
		self.view.addSubview(dotCouplelbl)
		
		//2) .couple btn
		dotCouplebtn.layer.cornerRadius = OptionsBtnPositionAndSize[3]
		dotCouplebtn.layer.backgroundColor = UIColor.black.cgColor
		dotCouplebtn.layer.borderColor = UIColor.white.cgColor
		dotCouplebtn.layer.borderWidth = 3
		dotCouplebtn.addTarget(self, action: #selector(hoverDisplay), for: UIControl.Event.touchDown)
		dotCouplebtn.addTarget(self, action: #selector(playDotCouple), for: UIControl.Event.touchUpInside)
		self.view.addSubview(dotCouplebtn)
		
		//Display Random Quote
		displayQuotelbl.textColor = UIColor.black
//		displayQuotelbl.backgroundColor = UIColor.white
		displayQuotelbl.font =  UIFont(name: "AvenirNextCondensed-Italic", size: 25.adjustedWidth)
		displayQuotelbl.lineBreakMode = NSLineBreakMode.byWordWrapping
		displayQuotelbl.numberOfLines = 4
		displayQuotelbl.textAlignment = NSTextAlignment.center
		self.view.addSubview(displayQuotelbl)
		
		introBackgroundView.layer.contents = (INTRO_BACKGROUND_IMAGE).cgImage
		
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
	
	//Play.me btn function
	@objc func playDotMe(_ sender: UIButton) {
		sender.alpha = 1
		selectedGameMode = GameMode.SinglePlayer
		showGameViewController(sender)
	}
	
	//Play.bluetooth btn function
	@objc func playDotBluetooth(_ sender: UIButton) {
		sender.alpha = 1
		selectedGameMode = GameMode.BluetoothMultiplayer
		let alert = UIAlertController(title: "Play.bluetooth", message: "Join or Host a Game Session", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Join", style: .default, handler: joinSession))
		alert.addAction(UIAlertAction(title: "Host", style: .default, handler: startHosting))
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: stopBluetooth))
		self.present(alert, animated: true, completion: nil)
		showGameViewController(sender)
	}
	
	//Play.online btn function NOTE: Online features not yet implemented
	@objc func playDotOnline(_ sender: UIButton) {
		sender.alpha = 1
		selectedGameMode = GameMode.Multiplayer
		showGameViewController(sender)
	}
	
	@objc func playDotCouple(_ sender: UIButton) {
		sender.alpha = 1
		selectedGameMode = GameMode.LocalMultiplayer
		showGameViewController(sender)
	}
	
	@objc func hoverDisplay(_ sender: UIButton) {
		sender.alpha = 0.5
	}
	
	@objc func showGameViewController(_ sender: UIButton) {
		sender.alpha = 1
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let secondVC = storyboard.instantiateViewController(identifier: "gameViewController")
		show(secondVC, sender: self)
	}
	
	@objc func hoverPlayButton(_ sender: UIButton) {
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
	
	func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
		print("Received and invation from \(peerID)")
	}

	func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
		dismiss(animated: true)
	}

	func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
		dismiss(animated: true)
	}
	
	func startHosting(action: UIAlertAction!) {
		mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "Chess", discoveryInfo: nil, session: mcSession)
		mcAdvertiserAssistant.start()
		isHost = true
	}

	func joinSession(action: UIAlertAction!) {
		let mcBrowser = MCBrowserViewController(serviceType: "Chess", session: mcSession)
		mcBrowser.delegate = self
		self.present(mcBrowser, animated: true)
		isHost = false
	}
	
	func stopBluetooth(_ : UIAlertAction?) {
		isHost = false
		selectedGameMode = GameMode.Multiplayer
		currentRow = 2
		
		let text = NSMutableAttributedString(string: "Play." + gameModes[currentRow])
		text.setColorForText("Play", with: UIColor.white)
		text.setColorForText("." + gameModes[currentRow], with: UIColor.black)
//		displayGameModelbl.attributedText = text
		
		peerID = MCPeerID(displayName: UIDevice.current.name)
		mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
		mcSession.delegate = self
	}
	
	 func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
		browser.invitePeer(peerID, to: mcSession, withContext: nil, timeout: 10)
		print("Peer \(peerID) has been invited to a session")
	}

	func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
		print("Peer \(peerID) has been kicked? from a session")
	}
	
	
	
	//Restrict ViewController rotation
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
	    get {
		return .portrait

	    }
	}
}
