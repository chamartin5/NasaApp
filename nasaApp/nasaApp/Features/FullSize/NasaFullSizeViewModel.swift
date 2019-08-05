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
		let tapOnClose: AnyObserver<Void>
	}

	struct Output {
		let url: Observable<ApodUrl>
	}

	let input: Input
	let output: Output

	let apodUrl: ApodUrl

	private let urlSubject = ReplaySubject<ApodUrl>.create(bufferSize: 1)
	private let tapOnCloseSubject = PublishSubject<Void>()

	init(apodUrl: ApodUrl) {
		self.apodUrl = apodUrl
		self.input = Input(tapOnClose: tapOnCloseSubject.asObserver())
		self.output = Output(url: urlSubject.asObservable())
		setupBindings()
	}
}

// MARK: bindings
private extension NasaFullSizeViewModel {
	func setupBindings() {
		bindApodUrl()
		bindTapOnClose()
	}

	func bindApodUrl() {
		urlSubject.onNext(apodUrl)
	}

	func bindTapOnClose() {
		tapOnCloseSubject
			.map { _ -> AppStep in
				return .closeModal
			}
			.bind(to: steps)
			.disposed(by: disposeBag)
	}
}
