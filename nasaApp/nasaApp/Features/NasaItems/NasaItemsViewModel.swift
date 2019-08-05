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

typealias NasaSectionModel = SectionModel<String, ApodState>

final class NasaItemsViewModel: Stepper {
	private let nasaApiProvider: NasaAPIProvider!
	let steps = PublishRelay<Step>()
	private let disposeBag = DisposeBag()

	struct Input {
		let tapOnCell: AnyObserver<ApodItem>
	}

	struct Output {
		let sections: Observable<[NasaSectionModel]>
		let isLoading: Observable<Bool>
	}

	let input: Input
	let output: Output

	private let tapOnCellSubject = PublishSubject<ApodItem>()
	private let sectionsSubject = ReplaySubject<[NasaSectionModel]>.create(bufferSize: 1)
	private let isLoadingSubject = ReplaySubject<Bool>.create(bufferSize: 1)

	init(nasaApiProvider: NasaAPIProvider) {
		self.nasaApiProvider = nasaApiProvider
		self.input = Input(tapOnCell: tapOnCellSubject.asObserver())
		self.output = Output(sections: sectionsSubject.asObservable(),
							 isLoading: isLoadingSubject.asObserver())
		setupBindings()
	}
}

// MARK: bindings
private extension NasaItemsViewModel {
	func setupBindings() {
		initLoaderBinding()
		bindSections()
		bindTapOnCell()
	}

	func initLoaderBinding() {
		isLoadingSubject.onNext(true)
	}

	func bindSections() {
		let lastDates = getLast30Dates()

		let initSectionModel = [NasaSectionModel.init(model: "", items: [])]

		Observable.from(lastDates)
			.concatMap { [weak self] date -> Single<Result<ApodResponse, NasaError>> in
				guard let self = self else { return Single.never() }
				return self.nasaApiProvider.getApod(date: date)
			}
			.map { result -> ApodState in
				switch result {
				case .success(let apodResponse):
					if apodResponse.mediaType == .image {
						let apodItem = NasaMapper.mapFromWS(apodResponse)
						return .success(apodItem)
					} else {
						return .apodIsVideo
					}
				case .failure:
					return .failure
				}
			}
			.withLatestFrom(sectionsSubject.startWith(initSectionModel), resultSelector: { [weak self] (newApodState, previousSection) -> [NasaSectionModel]? in
				guard let self = self else { return nil }
				return self.updateSectionModel(newApodState: newApodState, previousSection: previousSection)
			})
			.unwrap()
			.do(onNext: { [weak self] _ in
				self?.isLoadingSubject.onNext(false)
			})
			.bind(to: sectionsSubject)
			.disposed(by: disposeBag)
	}

	func bindSections0() {
		let lastDates = getLast30Dates()
		let observables = lastDates.map { date -> Observable<Result<ApodResponse, NasaError>> in
			return nasaApiProvider.getApod(date: date).asObservable()
		}

		Observable.zip(observables)
			.map({ results -> [ApodState] in
				var apodStates: [ApodState] = []
				results.forEach { result in
					switch result {
					case .success(let apodResponse):
						if apodResponse.mediaType == .image {
							let apodItem = NasaMapper.mapFromWS(apodResponse)
							apodStates.append(.success(apodItem))
						} else {
							apodStates.append(.apodIsVideo)
						}
					case .failure:
						apodStates.append(.failure)
					}
				}
				return apodStates
			})
			.flatMap({ [weak self] apodStates -> Observable<[NasaSectionModel]> in
				guard let self = self else { return Observable.never() }
				let sectionModel = self.buildSectionModel(apodStates: apodStates)
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

// MARK: helpers
private extension NasaItemsViewModel {
	func buildSectionModel(apodStates: [ApodState]) -> [NasaSectionModel] {
		let sectionModel = NasaSectionModel.init(model: "", items: apodStates)
		return [sectionModel]
	}

	func updateSectionModel(newApodState: ApodState, previousSection: [NasaSectionModel]) -> [NasaSectionModel] {
		var newSection = previousSection[0]
		var items = newSection.items
		items.append(newApodState)
		newSection.items = items
		return [newSection]
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
