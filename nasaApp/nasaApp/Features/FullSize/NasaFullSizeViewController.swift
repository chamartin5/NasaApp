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
			.subscribe(onNext: { [weak self] apodUrl in
				guard let self = self else { return }
				let placeholder = UIImage(named: "nasablackandwhite")
				if let hdUrl = apodUrl.hdUrl {
					self.nasaFullSizeImage.kf.setImage(with: hdUrl, placeholder: placeholder)
				} else {
					self.nasaFullSizeImage.kf.setImage(with: apodUrl.url, placeholder: placeholder)
				}
			})
			.disposed(by: disposeBag)
	}
}
