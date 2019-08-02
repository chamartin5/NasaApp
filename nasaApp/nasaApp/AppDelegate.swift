//
//  AppDelegate.swift
//  nasaApp
//
//  Created by Charlotte Martin on 02/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//


import UIKit
import RxFlow
import RxSwift
import RxCocoa

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var coordinator = FlowCoordinator()
	let disposeBag = DisposeBag()

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		guard let window = self.window else { return false }

		// listening for the coordination mechanism is not mandatory, but can be useful
		coordinator.rx.didNavigate.subscribe(onNext: { (flow, step) in
			print ("did navigate to flow=\(flow) and step=\(step)")
		}).disposed(by: self.disposeBag)

		let appFlow = AppFlow(withWindow: window)
		self.coordinator.coordinate(flow: appFlow, with: AppStepper())

		return true
	}
}
