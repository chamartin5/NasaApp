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
		let tapOnImage: AnyObserver<Void>
	}

	struct Output {
		let info: Observable<NasaItem>
	}

	let nasaItem: NasaItem
	let input: Input
	let output: Output

	private let infoSubject = ReplaySubject<NasaItem>.create(bufferSize: 1)
	private let tapOnImageSubject = PublishSubject<Void>()

	init(nasaItem: NasaItem) {
		self.nasaItem = nasaItem
		self.input = Input(tapOnImage: tapOnImageSubject.asObserver())
		self.output = Output(info: infoSubject.asObservable())
		setupBindings()
	}
}

private extension NasaDetailsViewModel {
	func setupBindings() {
		bindNasaInfo()
		bindTapOnImage()
	}

	func bindNasaInfo() {
		Observable.just(nasaItem)
			.bind(to: infoSubject)
			.disposed(by: disposeBag)
	}

	func bindTapOnImage() {
		tapOnImageSubject
			.map { [weak self] _ -> AppStep? in
				guard let self = self else { return nil }
				return AppStep.nasaFullSize(self.nasaItem.imageUrl)
			}
			.subscribe(onNext: { [weak self] appStep in
				guard let self = self, let appStep = appStep else { return }
				self.steps.accept(appStep)
			})
			.disposed(by: disposeBag)
	}
}
