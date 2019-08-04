//
//  ImagesListViewModel.swift
//  nasaApp
//
//  Created by Charlotte Martin on 02/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//

import RxCocoa
import RxSwift
import RxFlow
import Result
import RxDataSources

typealias NasaSectionModel = SectionModel<String, NasaItem>

class NasaItemsViewModel: Stepper {
	private let nasaApiProvider: NasaAPIProvider!
	let steps = PublishRelay<Step>()
	private let disposeBag = DisposeBag()

	struct Input {
		let tapOnCell: AnyObserver<NasaItem>
	}

	struct Output {
		let sections: Observable<[NasaSectionModel]>
	}

	let input: Input
	let output: Output

	private let tapOnCellSubject = PublishSubject<NasaItem>()
	private let sectionsSubject = ReplaySubject<[NasaSectionModel]>.create(bufferSize: 1)

	init(nasaApiProvider: NasaAPIProvider) {
		self.nasaApiProvider = nasaApiProvider
		self.input = Input(tapOnCell: tapOnCellSubject.asObserver())
		self.output = Output(sections: sectionsSubject.asObservable())
		setupBindings()
	}
}

// MARK: bindings
private extension NasaItemsViewModel {
	func setupBindings() {
		bindSections()
		bindTapOnCell()
	}

	func bindSections() {
		nasaApiProvider.getNasaImagesDetail()
			.asObservable()
			.flatMap { [weak self] result -> Observable<[NasaSectionModel]> in
				switch result {
				case .success(let nasaResponse):
					guard let self = self else { return Observable.never() }
					let sectionModel = self.buildSectionModel(nasaResponse: nasaResponse)
					return Observable.just(sectionModel)
				case .failure:
					return Observable.never()
				}
			}
			.bind(to: sectionsSubject)
			.disposed(by: disposeBag)
	}

	func bindTapOnCell() {
		tapOnCellSubject
			.map { item -> AppStep in
				return AppStep.detail(item)
			}
			.bind(to: steps)
			.disposed(by: disposeBag)
	}
}

// MARK: build sectionModel
private extension NasaItemsViewModel {
	func buildSectionModel(nasaResponse: NasaResponse) -> [NasaSectionModel] {
		let firstTwentyItems = Array(nasaResponse.collection.items.prefix(20))
		let items = NasaMapper.mapFromWS(firstTwentyItems)
		let sectionModel = NasaSectionModel.init(model: "", items: items)
		return [sectionModel]
	}
}
