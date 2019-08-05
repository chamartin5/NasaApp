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
		nasaApiProvider.getApod(date: "2018-01-01")
			.asObservable()
			.subscribe(onNext: { result in
				switch result {
				case .success(let apodResponse):
					XCTAssertEqual(apodResponse.date, "2019-08-01", "date incorrectly mapped")
					XCTAssertEqual(apodResponse.explanation, "Massive stars spend their brief", "explanation incorrectly mapped")
					XCTAssertEqual(apodResponse.hdurl, "https://apod.nasa.gov/apod/image/1908/g292chandra.jpg", "hdurl incorrectly mapped")
					XCTAssertEqual(apodResponse.mediaType, .image, "mediaType incorrectly mapped")
					XCTAssertEqual(apodResponse.title, "Elements in the Aftermath", "title incorrectly mapped")
					XCTAssertEqual(apodResponse.url, "https://apod.nasa.gov/apod/image/1908/g292chandra.jpg", "url incorrectly mapped")
				case .failure(let error):
					XCTFail("getApod in error \(error)")
				}
			})
			.disposed(by: disposeBag)
	}
}
