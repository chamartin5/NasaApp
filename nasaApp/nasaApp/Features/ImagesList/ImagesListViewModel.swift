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

typealias ImagesSectionModel = SectionModel<String, String>

class ImagesListViewModel: Stepper {
	let steps = PublishRelay<Step>()
	private let disposeBag = DisposeBag()
	private let apiProvider = APIProvider(provider: MoyaProvider<NasaService>())

	struct Input {

	}

	struct Output {
		let sections: Observable<[ImagesSectionModel]>
	}

	let input: Input
	let output: Output

	private let outputSections = ReplaySubject<[ImagesSectionModel]>.create(bufferSize: 1)

	init() {
		self.input = Input()
		self.output = Output(sections: outputSections.asObservable())
		setupBindings()
	}
}

private extension ImagesListViewModel {
	func setupBindings() {
		apiProvider.getDetail()
			.map { result -> ImagesSectionModel? in
				switch result {
				case .success(let imageResponse):
					let images = imageResponse.collection.items.map { item -> String? in
						guard let link = item.links.first?.href else { return nil }
						return link
					}
					let notNilImages = Array(images
						.compactMap { $0 }
						.prefix(20))
					return ImagesSectionModel.init(model: "", items: notNilImages)
				case .failure:
					return nil
				}
			}.asObservable()
			.subscribe(onNext: { [weak self] imagesSectionModel in
				guard let self = self, let imagesSectionModel = imagesSectionModel else { return }
				self.outputSections.onNext([imagesSectionModel])
			})
			.disposed(by: disposeBag)
	}
}
