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

typealias NasaSectionModel = SectionModel<String, ApodItem>

class NasaItemsViewModel: Stepper {
	private let nasaApiProvider: NasaAPIProvider!
	let steps = PublishRelay<Step>()
	private let disposeBag = DisposeBag()

	struct Input {
		let tapOnCell: AnyObserver<ApodItem>
	}

	struct Output {
		let sections: Observable<[NasaSectionModel]>
	}

	let input: Input
	let output: Output

	private let tapOnCellSubject = PublishSubject<ApodItem>()
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
		let lastDates = getLast30Dates()
		let observables = lastDates.map { date -> Observable<Result<ApodResponse, NasaError>> in
			return nasaApiProvider.getApod(date: date).asObservable()
		}

		Observable.zip(observables)
			.map({ results -> [ApodResponse] in
				var responses: [ApodResponse] = []
				print("CMA: \(responses.count)")
				results.forEach { result in
					switch result {
					case .success(let apodResponse):
						if apodResponse.mediaType == .image {
							responses.append(apodResponse)
						}
					case .failure(let error):
						print("CMA: failure \(error)")
					}
				}
				return responses
			})
			.flatMap({ [weak self] responses -> Observable<[NasaSectionModel]> in
				guard let self = self else { return Observable.never() }
				let sectionModel = self.buildSectionModel(responses: responses)
				return Observable.just(sectionModel)
			})
			.bind(to: sectionsSubject)
			.disposed(by: disposeBag)
	}

	func bindTapOnCell() {
		tapOnCellSubject
			.map { item -> AppStep in
				return AppStep.apodDetails(item)
			}
			.bind(to: steps)
			.disposed(by: disposeBag)
	}
}

// MARK: build sectionModel
private extension NasaItemsViewModel {
	func buildSectionModel(responses: [ApodResponse]) -> [NasaSectionModel] {
		let items = NasaMapper.mapFromWS(responses)
		let sectionModel = NasaSectionModel.init(model: "", items: items)
		return [sectionModel]
	}

	func getLast30Dates() -> [String] {
		var currentDate = Date()
		var dateArray: [String] = []

		let dateFormatter = DateFormatter.dateFormatterAmerican
		var currentDateStr = dateFormatter.string(from: currentDate)
		dateArray.append(currentDateStr)

		for _ in 1...29 {
			guard let dayBefore = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) else { continue }
			currentDate = dayBefore
			currentDateStr = dateFormatter.string(from: currentDate)
			dateArray.append(currentDateStr)
		}

		return dateArray
	}
}
