//
//  TestVM.swift
//  nasaAppTests
//
//  Created by Charlotte Martin on 03/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//

import XCTest
import RxSwift
import RxTest

@testable import nasaApp

class NasaFullSizeViewModelTests: XCTestCase {
	enum Constants {
		static let fakeUrl: URL? = URL(string: "https://images-assets.nasa.gov/image/0000485/0000485~thumb.jpg")
		static let fakeHdUrl: URL? = URL(string: "https://hd-images-assets.nasa.gov/image/0000485/0000485~thumb.jpg")
	}
	private var nasaFullSizeViewModel: NasaFullSizeViewModel!
	private var nasaDetailsViewModel: NasaDetailsViewModel!
	private var disposeBag: DisposeBag!
	var scheduler: TestScheduler!

	override func setUp() {
		super.setUp()
		let apodUrl = ApodUrl(url: Constants.fakeUrl, hdUrl: Constants.fakeHdUrl)
		nasaFullSizeViewModel = NasaFullSizeViewModel(apodUrl: apodUrl)
		let apodItem = ApodItem(title: "", description: "", date: nil, url: Constants.fakeUrl, hdUrl: Constants.fakeHdUrl)
		nasaDetailsViewModel = NasaDetailsViewModel(apodItem: apodItem)
		disposeBag = DisposeBag()
		scheduler = TestScheduler(initialClock: 0)
	}

	override func tearDown() {
		super.tearDown()
		nasaFullSizeViewModel = nil
		nasaDetailsViewModel = nil
		disposeBag = nil
		scheduler = nil
	}

    func testBindUrl() {
		nasaFullSizeViewModel.output.url
			.subscribe(onNext: { apodUrl in
				XCTAssertEqual(apodUrl.url, Constants.fakeUrl)
				XCTAssertEqual(apodUrl.hdUrl, Constants.fakeHdUrl)
			})
			.disposed(by: disposeBag)
    }

	func testTapOnImage() {
		let apodUrlListener = scheduler.createObserver(ApodUrl.self)

		nasaFullSizeViewModel.output.url
			.bind(to: apodUrlListener)
			.disposed(by: disposeBag)

		scheduler.createColdObservable([.next(10, ())])
			.bind(to: nasaDetailsViewModel.input.tapOnImage)
			.disposed(by: disposeBag)

		scheduler.start()

		let events = apodUrlListener.events
		XCTAssertEqual(events.count, 1)

		guard let apodUrl = apodUrlListener.events[0].value.element else { return XCTFail("apodUrl is nil") }
		XCTAssertEqual(apodUrl.hdUrl, Constants.fakeHdUrl, "no hdUrl")
		XCTAssertEqual(apodUrl.url, Constants.fakeUrl, "no url")
	}
}

