//
//  NasaFullSizeViewModel.swift
//  nasaApp
//
//  Created by Charlotte Martin on 03/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//

import RxFlow
import RxCocoa
import RxSwift

final class NasaFullSizeViewModel: Stepper {
	let steps = PublishRelay<Step>()
	private let disposeBag = DisposeBag()

	struct Input {

	}

	struct Output {
		let url: Observable<ApodUrl>
	}

	let input: Input
	let output: Output
	private let urlSubject = ReplaySubject<ApodUrl>.create(bufferSize: 1)

	init(apodUrl: ApodUrl) {
		self.input = Input()
		self.output = Output(url: urlSubject.asObservable())
		urlSubject.onNext(apodUrl)
	}
}
