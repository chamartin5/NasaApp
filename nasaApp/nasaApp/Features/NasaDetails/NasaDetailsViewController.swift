//
//  NasaDetailsViewController.swift
//  nasaApp
//
//  Created by Charlotte Martin on 03/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher
import RxGesture

class NasaDetailsViewController: UIViewController {

	var viewModel: NasaDetailsViewModel!
	private let disposeBag = DisposeBag()

	@IBOutlet private weak var nasaImage: UIImageView! {
		didSet {
			nasaImage.contentMode = .scaleAspectFill
			nasaImage.layer.masksToBounds = true
			nasaImage.cornerRadius = 10
		}
	}

	@IBOutlet private weak var titleLabel: UILabel! {
		didSet {
			titleLabel.numberOfLines = 0
			titleLabel.font = UIFont(name: FontHelper.nasa, size: 25)
		}
	}

	@IBOutlet private weak var subtitleLabel: UILabel! {
		didSet {
			subtitleLabel.numberOfLines = 0
			subtitleLabel.font = UIFont(name: FontHelper.italic, size: 20)
			subtitleLabel.textColor = .gray
		}
	}

	@IBOutlet private weak var descriptionLabel: UILabel! {
		didSet {
			descriptionLabel.numberOfLines = 0
			descriptionLabel.font = UIFont(name: FontHelper.medium, size: 15)
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupBindings()
	}
}

// MARK: UI
private extension NasaDetailsViewController {
	func configure(apodItem: ApodItem) {
		nasaImage.kf.setImage(with: apodItem.url)
		titleLabel.text = apodItem.title
		let dateStr = getDateString(date: apodItem.date)
		subtitleLabel.text = "(\(dateStr))"
		descriptionLabel.text = apodItem.description
	}

	func getDateString(date: Date?) -> String {
		guard let date = date else { return "" }
		let dateFormatter = DateFormatter.dateFormatterWS
		return dateFormatter.string(from: date)
	}
}

// MARK: bindings
private extension NasaDetailsViewController {
	func setupBindings() {
		bindInfos()
		bindTapOnImage()
	}

	func bindInfos() {
		viewModel.output.info
			.subscribe(onNext: { [weak self] apodItem in
				guard let self = self else { return }
				self.configure(apodItem: apodItem)
			})
			.disposed(by: disposeBag)
	}

	func bindTapOnImage() {
		nasaImage.rx.tapGesture().when(.recognized)
			.map { _ in () }
			.bind(to: viewModel.input.tapOnImage)
			.disposed(by: disposeBag)
	}
}
