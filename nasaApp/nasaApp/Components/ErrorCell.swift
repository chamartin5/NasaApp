//
//  ErrorCell.swift
//  nasaApp
//
//  Created by Charlotte Martin on 05/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//

import UIKit

class ErrorCell: UICollectionViewCell {
	@IBOutlet weak var nasaImage: UIImageView! {
		didSet {
			nasaImage.backgroundColor = .gray
			let image = UIImage(named: "sad")
			nasaImage.image = image
			nasaImage.contentMode = .scaleAspectFill
		}
	}
}
