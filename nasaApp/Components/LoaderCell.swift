//
//  LoaderCell.swift
//  nasaApp
//
//  Created by Charlotte Martin on 05/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//

import Foundation

import UIKit
import Lottie

class LoaderCell: UICollectionViewCell {
	private enum Constants {
		static let loaderName = "loader"
	}

	let animationView = AnimationView(name: Constants.loaderName)

	@IBOutlet weak var containerView: UIView! {
		didSet {
			containerView.backgroundColor = ColorHelper.lightGrey
			containerView.layer.masksToBounds = true
			containerView.cornerRadius = 10
		}
	}

	func playLoader() {
		animationView.play()
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		configureLottie()
	}
}

private extension LoaderCell {
	func configureLottie() {
		animationView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
		animationView.center = containerView.center
		animationView.contentMode = .scaleAspectFill
		animationView.loopMode = .loop
		containerView.addSubview(animationView)
	}
}
