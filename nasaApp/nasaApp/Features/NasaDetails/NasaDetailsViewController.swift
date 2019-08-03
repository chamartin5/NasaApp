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

class NasaDetailsViewController: UIViewController {
	private enum Constants {
		static let keywordsTitle = "Mot Clés"
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
//			guard let font = UIFont(name: "LiterataBook-Medium", size: 12) else { return }
//			titleLabel.font = font
		}
	}

	@IBOutlet private weak var subtitleLabel: UILabel! {
		didSet {
			subtitleLabel.numberOfLines = 0
		}
	}

	@IBOutlet private weak var descriptionLabel: UILabel! {
		didSet {
			descriptionLabel.numberOfLines = 0
		}
	}

	@IBOutlet private weak var keywordsTitleLabel: UILabel! {
		didSet {
			keywordsTitleLabel.text = Constants.keywordsTitle
		}
	}

	@IBOutlet private weak var keywordsLabel: UILabel! {
		didSet {
			keywordsLabel.numberOfLines = 0
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
		subtitleLabel.text = nasaItem.center
		descriptionLabel.text = nasaItem.description
		keywordsLabel.text = nasaItem.keywords.joined(separator: "\n")
	}
}

// MARK: bindings
private extension NasaDetailsViewController {
	func setupBindings() {
		viewModel.output.info
			.subscribe(onNext: { [weak self] item in
				guard let self = self else { return }
				self.configure(nasaItem: item)
			})
			.disposed(by: disposeBag)
	}
}
