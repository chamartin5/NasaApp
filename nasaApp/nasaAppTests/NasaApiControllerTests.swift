//
//  nasaAppTests.swift
//  nasaAppTests
//
//  Created by Charlotte Martin on 03/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//

import XCTest
import RxSwift
import Moya

@testable import nasaApp

class NasaApiControllerTests: XCTestCase {

	private var nasaApiProvider: NasaAPIProvider!
	private var disposeBag: DisposeBag!

    override func setUp() {
		super.setUp()
		let moyaProvider = MoyaProvider<NasaService>(stubClosure: MoyaProvider.immediatelyStub)
		nasaApiProvider = NasaAPIProvider(provider: moyaProvider)
		disposeBag = DisposeBag()
    }

    override func tearDown() {
		nasaApiProvider = nil
		disposeBag = nil
		super.tearDown()
    }

	func testGetNasaImagesDetail() {
		nasaApiProvider.getNasaImagesDetail()
			.asObservable()
			.subscribe(onNext: { result in
				switch result {
				case .success(let nasaResponse):
					XCTAssertEqual(nasaResponse.collection.items.count, 3, "getNasaImagesDetail expected 3 items")
					guard let firstItem = nasaResponse.collection.items.first,
						let firstData = firstItem.data.first,
						let firstLink = firstItem.links.first  else { return XCTFail("first item, data or link is nil") }
					XCTAssertEqual(firstData.center, "MSFC", "center incorrectly mapped")
					XCTAssertEqual(firstData.title, "Microgravity", "title incorrectly mapped")
					XCTAssertEqual(firstData.description, "Space Vacuum Epitaxy Center works", "description incorrectly mapped")
					XCTAssertEqual(firstData.createdDate, "1999-11-10T00:00:00Z", "date incorrectly mapped")
					XCTAssertEqual(firstData.keywords.count, 1, "keywords incorrectly mapped")
					XCTAssertEqual(firstData.nasaId, "0000485", "nasaId incorrectly mapped")
					XCTAssertEqual(firstLink.href, "https://images-assets.nasa.gov/image/0000485/0000485~thumb.jpg", "href incorrectly mapped")
				case .failure(let error):
					XCTFail("getDetail in error \(error)")
				}
			})
			.disposed(by: disposeBag)
	}
}
