//
//  AppFlow.swift
//  nasaApp
//
//  Created by Charlotte Martin on 02/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa

class AppFlow: Flow {
	var root: Presentable {
		return rootViewController
	}

	private lazy var rootViewController: UINavigationController = {
		let viewController = UINavigationController()
		return viewController
	}()

	private let rootWindow: UIWindow

	init(withWindow window: UIWindow) {
		self.rootWindow = window
	}


	func navigate(to step: Step) -> FlowContributors {
		guard let step = step as? AppStep else { return .none }
		switch step {
		case .apodList:
			return navigateToApodList()
		default:
			return .none
		}
	}

	private func navigateToApodList() -> FlowContributors {
		let nasaFlow = NasaFlow()

		Flows.whenReady(flow1: nasaFlow) { [weak self] root in
			self?.rootWindow.rootViewController = root
		}
		return .one(flowContributor: .contribute(withNextPresentable: nasaFlow, withNextStepper: OneStepper(withSingleStep: AppStep.apodList)))
	}
}

class AppStepper: Stepper {
	let steps = PublishRelay<Step>()
	private let disposeBag = DisposeBag()

	//    /// callback used to emit steps once the FlowCoordinator is ready to listen to them to contribute to the Flow
	func readyToEmitSteps() {
		steps.accept(AppStep.apodList)
	}
}

