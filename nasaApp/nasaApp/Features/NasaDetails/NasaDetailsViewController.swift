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
	private enum Constants {
		static let keywordsTitle = "Keywords"
	}

	var viewModel: NasaDetailsViewModel!
	private let disposeBag = DisposeBag()

	@IBOutlet private weak var nasaImage: UIImageView! {
		didSet {
			nasaImage.layer.masksToBounds = true
			nasaImage.cornerRadius = 10
		}
	}

	@IBOutlet private weak var titleLabel: UILabel! {
		didSet {
			titleLabel.numberOfLines = 0
			titleLabel.font = UIFont(name: Fonts.nasa, size: 25)
		}
	}

	@IBOutlet private weak var subtitleLabel: UILabel! {
		didSet {
			subtitleLabel.numberOfLines = 0
			subtitleLabel.font = UIFont(name: Fonts.italic, size: 20)
			subtitleLabel.textColor = .gray
		}
	}

	@IBOutlet private weak var descriptionLabel: UILabel! {
		didSet {
			descriptionLabel.numberOfLines = 0
			descriptionLabel.font = UIFont(name: Fonts.medium, size: 15)
		}
	}

	@IBOutlet private weak var keywordsTitleLabel: UILabel! {
		didSet {
			keywordsTitleLabel.text = Constants.keywordsTitle
			keywordsTitleLabel.font = UIFont(name: Fonts.bold, size: 15)
		}
	}

	@IBOutlet private weak var keywordsLabel: UILabel! {
		didSet {
			keywordsLabel.numberOfLines = 0
			keywordsLabel.font = UIFont(name: Fonts.medium, size: 15)
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupBindings()
	}
}

// MARK: UI
private extension NasaDetailsViewController {
	func configure(nasaItem: NasaItem) {
		nasaImage.kf.setImage(with: nasaItem.imageUrl)
		titleLabel.text = nasaItem.title
		let dateStr = getDateString(date: nasaItem.createdDate)
		subtitleLabel.text = "(\(nasaItem.center), \(dateStr))"
		descriptionLabel.text = nasaItem.description
		keywordsLabel.text = nasaItem.keywords.joined(separator: "\n")
	}

	func getDateString(date: Date?) -> String {
		guard let date = date else { return "" }
		let dateFormatter = DateFormatter.dateFormatterLong
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
			.subscribe(onNext: { [weak self] item in
				guard let self = self else { return }
				self.configure(nasaItem: item)
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
