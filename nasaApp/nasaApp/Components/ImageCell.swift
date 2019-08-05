//
//  ImageCell.swift
//  nasaApp
//
//  Created by Charlotte Martin on 02/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//

import UIKit
import Kingfisher
import SwifterSwift

class ImageCell: UICollectionViewCell {

	private enum Constants {
		static let placeholderImageName = "nasablackandwhite"
	}

	@IBOutlet weak var nasaImage: UIImageView! {
		didSet {
			nasaImage.contentMode = .scaleAspectFill
			nasaImage.layer.masksToBounds = true
			nasaImage.cornerRadius = 10
		}
	}

	func configure(url: URL?) {
		let placeholder = UIImage(named: Constants.placeholderImageName)
		nasaImage.kf.setImage(with: url, placeholder: placeholder)
	}
}
