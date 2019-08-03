//
//  NasaFullSizeViewController.swift
//  nasaApp
//
//  Created by Charlotte Martin on 03/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift

class NasaFullSizeViewController: UIViewController {
	var viewModel: NasaFullSizeViewModel!
	private let disposeBag = DisposeBag()

	@IBOutlet private weak var nasaFullSizeImage: UIImageView!

	override func viewDidLoad() {
		super.viewDidLoad()
		setupBindings()
	}
}

// MARK: bindings
private extension NasaFullSizeViewController {
	func setupBindings() {
		viewModel.output.url
			.subscribe(onNext: { [weak self] url in
				guard let self = self else { return }
				self.nasaFullSizeImage.kf.setImage(with: url)
			})
			.disposed(by: disposeBag)
	}
}
