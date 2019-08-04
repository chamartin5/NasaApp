//
//  NasaFullSizeViewModel.swift
//  nasaApp
//
//  Created by Charlotte Martin on 03/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//

import Foundation
import RxFlow
import RxCocoa
import RxSwift

class NasaFullSizeViewModel: Stepper {
	let steps = PublishRelay<Step>()
	private let disposeBag = DisposeBag()

	struct Input {

	}

	struct Output {
		let url: Observable<URL?>
	}

	let input: Input
	let output: Output
	private let urlSubject = BehaviorRelay<URL?>.init(value: nil)

	init(url: URL?) {
		self.input = Input()
		self.output = Output(url: urlSubject.asObservable())
		urlSubject.accept(url)
	}
}
