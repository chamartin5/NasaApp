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
		let sectionsListener = scheduler.createObserver([NasaSectionModel].self)

		nasaItemsViewModel.output.sections
			.bind(to: sectionsListener)
			.disposed(by: disposeBag)

		guard let sectionModels = sectionsListener.events[0].value.element else { return XCTFail("sectionModels is nil") }
		XCTAssertEqual(sectionModels.count, 1)

		let firstSection = sectionModels[0]
		XCTAssertEqual(firstSection.model, "")
		XCTAssertEqual(firstSection.items.count, 30)

		let firstItem = firstSection.items[0]
		XCTAssertEqual(firstItem.date, DateFormatter.dateFormatterWS.date(from: "2019-08-01"), "date incorrectly mapped")
		XCTAssertEqual(firstItem.title, "Elements in the Aftermath", "title incorrectly mapped")
		XCTAssertEqual(firstItem.description, "Massive stars spend their brief", "description incorrectly mapped")
		XCTAssertEqual(firstItem.url?.absoluteString, "https://apod.nasa.gov/apod/image/1908/g292chandra.jpg", "url incorrectly mapped")
	}
}
