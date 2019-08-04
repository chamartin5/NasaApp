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
	}
	private var nasaFullSizeViewModel: NasaFullSizeViewModel!
	private var nasaDetailsViewModel: NasaDetailsViewModel!
	private var disposeBag: DisposeBag!
	var scheduler: TestScheduler!

	override func setUp() {
		super.setUp()
		nasaFullSizeViewModel = NasaFullSizeViewModel(url: Constants.fakeUrl)
		let apodItem = ApodItem(title: "", description: "", date: nil, url: Constants.fakeUrl)
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
			.subscribe(onNext: { url in
				XCTAssertEqual(url, Constants.fakeUrl)
			})
			.disposed(by: disposeBag)
    }

	func testTapOnImage() {
		let isShowingFullImage = scheduler.createObserver(URL?.self)

		nasaFullSizeViewModel.output.url
			.bind(to: isShowingFullImage)
			.disposed(by: disposeBag)

		scheduler.createColdObservable([.next(10, ())])
			.bind(to: nasaDetailsViewModel.input.tapOnImage)
			.disposed(by: disposeBag)

		scheduler.start()

		let events = isShowingFullImage.events
		XCTAssertEqual(events.count, 1)
		XCTAssertEqual(isShowingFullImage.events, [.next(0, Constants.fakeUrl)])
	}

}

