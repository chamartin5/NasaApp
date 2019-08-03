//
//  NasaDetailsViewModel.swift
//  nasaApp
//
//  Created by Charlotte Martin on 03/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//

import Foundation
import RxFlow
import RxCocoa
import RxSwift

class NasaDetailsViewModel: Stepper {
	let steps = PublishRelay<Step>()
	private let disposeBag = DisposeBag()

	struct Input {

	}

	struct Output {
		let info: Observable<NasaItem>
	}

	let nasaItem: NasaItem
	let input: Input
	let output: Output

	private let infoSubject = ReplaySubject<NasaItem>.create(bufferSize: 1)

	init(nasaItem: NasaItem) {
		self.nasaItem = nasaItem
		self.input = Input()
		self.output = Output(info: infoSubject.asObservable())
		setupBindings()
	}
}

private extension NasaDetailsViewModel {
	func setupBindings() {
		bindNasaInfo()
	}

	func bindNasaInfo() {
		Observable.just(nasaItem)
			.debug("bindNasaInfo")
			.bind(to: infoSubject)
			.disposed(by: disposeBag)
	}
}
