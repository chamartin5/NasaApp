//
//  TestVM.swift
//  nasaAppTests
//
//  Created by Charlotte Martin on 03/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//

import XCTest
import RxSwift

@testable import nasaApp

class NasaFullSizeViewModelTests: XCTestCase {
	enum Constants {
		static let fakeUrl = "https://images-assets.nasa.gov/image/0000485/0000485~thumb.jpg"
	}
	private var nasaItemsViewModel: NasaFullSizeViewModel!
	private var disposeBag: DisposeBag!

	override func setUp() {
		super.setUp()
		let url = URL(string: Constants.fakeUrl)
		nasaItemsViewModel = NasaFullSizeViewModel(url: url)
		disposeBag = DisposeBag()
	}

	override func tearDown() {
		super.tearDown()
		nasaItemsViewModel = nil
		disposeBag = nil
	}

    func testBindUrl() {
		nasaItemsViewModel.output.url
			.subscribe(onNext: { url in
				XCTAssertEqual(url?.absoluteString, Constants.fakeUrl)
			})
			.disposed(by: disposeBag)
    }

}

