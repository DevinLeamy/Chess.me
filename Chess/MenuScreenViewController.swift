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
let OptionsLblPositionAndSize = [100.adjustedWidth, 250.adjustedWidth, 50.adjustedHeight, 50.adjustedHeight] //X Coord, Width, Height, Font size
let OptionsVerticalSpace = 100.adjustedHeight
let OptionsBtnPositionAndSize = [360.adjustedWidth, 40.adjustedWidth, 40.adjustedWidth, 20.adjustedWidth] //X Coord, Width, Height, Corner Radius
let FirstOptionLblDistanceFromTop = 200.adjustedHeight
let FirstOptionBtnDistanceFromTop = 205.adjustedHeight
class MenuScreenViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
	var gameModes: [String] = [String]()
	var chessQuotes: [[String]] = [[String]]()
	var currentRow = 0
	
	
	@IBOutlet var introBackgroundView: UIView!
	//Initialize Buttons and labels
	let introHeaderlbl = UILabel(frame: CGRect(x: 25.adjustedWidth, y: 775.adjustedHeight, width: 300.adjustedWidth, height: 100.adjustedHeight))
	
	let playlbl = UILabel(frame: CGRect(x: 20.adjustedWidth, y: 100.adjustedHeight, width: 500.adjustedWidth, height: 90.adjustedHeight))
	
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
		CGRect(x: 67.adjustedWidth,
		       y: 600.adjustedHeight,
		       width: 300.adjustedWidth,
		       height: 150.adjustedHeight
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
		introHeaderlbl.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 45.adjustedWidth)
		introHeaderlbl.textColor = UIColor.black
		self.view.addSubview(introHeaderlbl)
		
		//Play header label
		playlbl.text = "Play"
		playlbl.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 80.adjustedWidth)
		playlbl.textColor = UIColor.black
		self.view.addSubview(playlbl)
		
		//.me option
		//1) .me label
		dotMelbl.text = ".me"
		dotMelbl.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: OptionsLblPositionAndSize[3])
		dotMelbl.textColor = UIColor.black
		self.view.addSubview(dotMelbl)
		
		//2) .me btn
		dotMebtn.layer.cornerRadius = OptionsBtnPositionAndSize[3]
		dotMebtn.layer.backgroundColor = UIColor.black.cgColor
		dotMebtn.addTarget(self, action: #selector(hoverDisplay), for: UIControl.Event.touchDown)
		dotMebtn.addTarget(self, action: #selector(playDotMe), for: UIControl.Event.touchUpInside)
		self.view.addSubview(dotMebtn)
		
		//.bluetooth option
		//1) .bluetooth label
		dotBluetoothlbl.text = ".bluetooth"
		dotBluetoothlbl.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: OptionsLblPositionAndSize[3])
		dotBluetoothlbl.textColor = UIColor.black
		self.view.addSubview(dotBluetoothlbl)
		
		//2) .bluetooth btn
		dotBluetoothbtn.layer.cornerRadius = 20.adjustedWidth
		dotBluetoothbtn.layer.backgroundColor = UIColor.black.cgColor
		dotBluetoothbtn.addTarget(self, action: #selector(hoverDisplay), for: UIControl.Event.touchDown)
		dotBluetoothbtn.addTarget(self, action: #selector(playDotBluetooth), for: UIControl.Event.touchUpInside)
		self.view.addSubview(dotBluetoothbtn)
		
		// .online option
		//1) .online lbl
		dotOnlinelbl.text = ".online"
		dotOnlinelbl.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: OptionsLblPositionAndSize[3])
		dotOnlinelbl.textColor = UIColor.black
		self.view.addSubview(dotOnlinelbl)
		
		//2) .online btn
		dotOnlinebtn.layer.cornerRadius = 20.adjustedWidth
		dotOnlinebtn.layer.backgroundColor = UIColor.black.cgColor
		dotOnlinebtn.addTarget(self, action: #selector(hoverDisplay), for: UIControl.Event.touchDown)
		dotOnlinebtn.addTarget(self, action: #selector(playDotOnline), for: UIControl.Event.touchUpInside)
		self.view.addSubview(dotOnlinebtn)
		
		// .couple option
		//1) .couple lbl
		dotCouplelbl.text = ".couple"
		dotCouplelbl.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: OptionsLblPositionAndSize[3])
		dotCouplelbl.textColor = UIColor.black
		self.view.addSubview(dotCouplelbl)
		
		//2) .couple btn
		dotCouplebtn.layer.cornerRadius = 20.adjustedWidth
		dotCouplebtn.layer.backgroundColor = UIColor.black.cgColor
		dotCouplebtn.addTarget(self, action: #selector(hoverDisplay), for: UIControl.Event.touchDown)
		dotCouplebtn.addTarget(self, action: #selector(playDotCouple), for: UIControl.Event.touchUpInside)
		self.view.addSubview(dotCouplebtn)
		
		//Display Random Quote
		displayQuotelbl.textColor = UIColor.black
//		displayQuotelbl.backgroundColor = UIColor.white
		displayQuotelbl.font =  UIFont(name: "AppleSDGothicNeo-SemiBold", size: 23.adjustedWidth)
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
		let alert = UIAlertController(title: "Play.bluetooth", message: "Join or Host a Game Session", preferredStyle: .actionSheet)
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

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
