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
		nasaApiProvider.getNasaImagesDetail().asObservable()
			.subscribe(onNext: { result in
				switch result {
				case .success(let items):
					XCTAssertEqual(items.count, 3, "getDetail expected 3 items")
					guard let firstItem = items.first else { return XCTFail("first item is nil") }
					XCTAssertEqual("MSFC", firstItem.center, "center incorrectly mapped")
					XCTAssertEqual("Microgravity", firstItem.title, "title incorrectly mapped")
					XCTAssertEqual("Space Vacuum Epitaxy Center works", firstItem.description, "description incorrectly mapped")
					XCTAssertEqual(DateFormatter.iso8601.date(from: "1999-11-10T00:00:00Z"), firstItem.createdDate, "createdDate incorrectly mapped")
					XCTAssertEqual(1, firstItem.keywords.count, "keywords incorrectly mapped")
					XCTAssertEqual("0000485", firstItem.nasaId, "nasaId incorrectly mapped")
					XCTAssertEqual("https://images-assets.nasa.gov/image/0000485/0000485~thumb.jpg", firstItem.imageUrl?.absoluteString)
				case .failure(let error):
					XCTFail("getDetail in error \(error)")
				}
			})
			.disposed(by: disposeBag)
	}
}
