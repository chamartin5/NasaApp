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
import Moya
import Result
import RxDataSources

typealias NasaSectionModel = SectionModel<String, NasaItem>

class NasaItemsViewModel: Stepper {
	let steps = PublishRelay<Step>()
	private let disposeBag = DisposeBag()
	private let apiProvider = APIProvider(provider: MoyaProvider<NasaService>())

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

	init() {
		self.input = Input(tapOnCell: tapOnCellSubject.asObserver())
		self.output = Output(sections: sectionsSubject.asObservable())
		setupBindings()
	}
}

private extension NasaItemsViewModel {
	func setupBindings() {
		bindSections()
		bindTapOnCell()
	}

	func bindSections() {
		apiProvider.getDetail()
			.map { result -> NasaSectionModel? in
				switch result {
				case .success(let nasaItems):
					let firstTwentyItems = Array(nasaItems.prefix(20))
					return NasaSectionModel.init(model: "", items: firstTwentyItems)
				case .failure:
					return nil
				}
			}
			.asObservable()
			.subscribe(onNext: { [weak self] imagesSectionModel in
				guard let self = self, let imagesSectionModel = imagesSectionModel else { return }
				self.sectionsSubject.onNext([imagesSectionModel])
			})
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
