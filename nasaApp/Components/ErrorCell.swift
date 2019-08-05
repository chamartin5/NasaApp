//
//  ErrorCell.swift
//  nasaApp
//
//  Created by Charlotte Martin on 05/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//

import UIKit

class ErrorCell: UICollectionViewCell {
	private enum Constants {
		static let errorImageName = "bomb"
		static let videoImageName = "video"
	}

	@IBOutlet weak var nasaImage: UIImageView! {
		didSet {
			nasaImage.contentMode = .scaleAspectFill
			nasaImage.layer.masksToBounds = true
			nasaImage.cornerRadius = 10
		}
	}

	func configureError() {
			let image = UIImage(named: Constants.errorImageName)
			nasaImage.image = image
	}

	func configureIsVideo() {
		let image = UIImage(named: Constants.videoImageName)
		nasaImage.image = image
	}
}
