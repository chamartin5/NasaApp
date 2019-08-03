//
//  NasaItemsViewModelTests.swift
//  nasaAppTests
//
//  Created by Charlotte Martin on 03/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import Moya

@testable import nasaApp

class NasaItemsViewModelTests: XCTestCase {

	private var nasaItemsViewModel: NasaItemsViewModel!
	private var nasaDetailsViewModel: NasaDetailsViewModel!
	private var disposeBag: DisposeBag!
	private var scheduler: TestScheduler!

	override func setUp() {
		super.setUp()
		let moyaProvider = MoyaProvider<NasaService>(stubClosure: MoyaProvider.immediatelyStub)
		let nasaApiProvider = NasaAPIProvider(provider: moyaProvider)
		nasaItemsViewModel = NasaItemsViewModel(nasaApiProvider: nasaApiProvider)
		disposeBag = DisposeBag()
		scheduler = TestScheduler.init(initialClock: 0)
	}

	override func tearDown() {
		super.tearDown()
		nasaItemsViewModel = nil
		disposeBag = nil
		scheduler = nil
	}

	func testGetNasaImagesDetail() {
		nasaItemsViewModel.output.sections
			.subscribe(onNext: { sectionModel in
				XCTAssertEqual(sectionModel.count, 1)
				guard let firstSection = sectionModel.first else { return XCTFail("section has no first item") }
				XCTAssertEqual(firstSection.model, "")
				XCTAssertEqual(firstSection.items.count, 3)
			})
			.disposed(by: disposeBag)
	}

	func testTapOnImageToDetail() {
		nasaItemsViewModel.output.sections
			.subscribe(onNext: { sectionModel in
				XCTAssertEqual(sectionModel.count, 1)
				guard let firstSection = sectionModel.first else { return XCTFail("section has no first item") }
				XCTAssertEqual(firstSection.model, "")
				XCTAssertEqual(firstSection.items.count, 3)
			})
			.disposed(by: disposeBag)
	}
}
