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
import RxSwift
import Lottie

class ImageCell: UICollectionViewCell {

	public var disposeBag = DisposeBag()

	@IBOutlet weak var nasaImage: UIImageView! {
		didSet {
			nasaImage.contentMode = .scaleAspectFill
			nasaImage.layer.masksToBounds = true
			nasaImage.cornerRadius = 10
		}
	}

	@IBOutlet weak var loaderContainer: UIView!

	func configure(url: URL?) {
		nasaImage.kf.setImage(with: url)
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		disposeBag = DisposeBag()
	}
}
