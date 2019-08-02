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
	@IBOutlet weak var nasaImage: UIImageView! {
		didSet {
			nasaImage.layer.masksToBounds = true
			nasaImage.cornerRadius = 10
		}
	}

	func configure(url: String) {
		guard let url = URL(string: url) else { return }
		nasaImage.kf.setImage(with: url)
	}
}
