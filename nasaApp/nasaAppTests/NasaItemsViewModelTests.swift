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
		XCTAssertEqual(firstSection.items.count, 3)

		let firstItem = firstSection.items[0]
		XCTAssertEqual(firstItem.center, "MSFC", "center incorrectly mapped")
		XCTAssertEqual(firstItem.title, "Microgravity", "title incorrectly mapped")
		XCTAssertEqual(firstItem.description, "Space Vacuum Epitaxy Center works", "description incorrectly mapped")
		XCTAssertEqual(firstItem.createdDate, DateFormatter.iso8601.date(from: "1999-11-10T00:00:00Z"), "createdDate incorrectly mapped")
		XCTAssertEqual(firstItem.keywords.count, 1, "keywords incorrectly mapped")
		XCTAssertEqual(firstItem.nasaId, "0000485", "nasaId incorrectly mapped")
		XCTAssertEqual(firstItem.imageUrl?.absoluteString, "https://images-assets.nasa.gov/image/0000485/0000485~thumb.jpg", "imageUrl incorrectly mapped")
	}
}
