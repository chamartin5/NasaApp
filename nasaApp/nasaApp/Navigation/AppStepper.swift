//
//  AppStepper.swift
//  nasaApp
//
//  Created by Charlotte Martin on 05/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa

final class AppStepper: Stepper {
	let steps = PublishRelay<Step>()
	private let disposeBag = DisposeBag()

	//    /// callback used to emit steps once the FlowCoordinator is ready to listen to them to contribute to the Flow
	func readyToEmitSteps() {
		steps.accept(AppStep.apodList)
	}
}
