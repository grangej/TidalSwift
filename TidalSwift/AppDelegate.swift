//
//  AppDelegate.swift
//  TidalSwift
//
//  Created by Melvin Gundlach on 12.03.19.
//  Copyright © 2019 Melvin Gundlach. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	
	var mainViewController: ViewController?

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
		
//		let loginCredentials = readDemoLoginCredentials()
//		let token = readDemoToken()
//		let config = Config(loginCredentials: loginCredentials, apiToken: token)
//		let session = Session(config: config)
//
//		session.deletePersistantInformation()
//
//		print(loginCredentials.username)
//		print(loginCredentials.password)
//
//		_ = session.login()
//		print(session.checkLogin())
//		
//		session.saveConfig()
//		session.saveSession()
//
//		session.loadSession()
		
		print("-----")
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
		
		UserDefaults.standard.synchronize()
	}


}
