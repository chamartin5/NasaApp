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
import Lottie

final class NasaFullSizeViewController: UIViewController {

	private enum Constants {
		static let loaderName = "loader"
		static let closeImageName = "close"
	}

	let animationView = AnimationView(name: Constants.loaderName)
	var viewModel: NasaFullSizeViewModel!
	private let disposeBag = DisposeBag()

	@IBOutlet private weak var nasaFullSizeImage: UIImageView! {
		didSet {
			nasaFullSizeImage.contentMode = .scaleAspectFit
		}
	}

	@IBOutlet weak var scrollView: UIScrollView! {
		didSet {
			scrollView.minimumZoomScale = 1.0
			scrollView.maximumZoomScale = 5.0
			scrollView.delegate = self
		}
	}

	@IBOutlet private weak var closeButton: UIButton! {
		didSet {
			if let image = UIImage(named: Constants.closeImageName) {
				closeButton.setImageForAllStates(image)
				closeButton.tintColor = ColorHelper.blue
			}
			closeButton.setTitleForAllStates("")
		}
	}

	@IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
	@IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
	@IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
	@IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!

	override func viewDidLoad() {
		super.viewDidLoad()
		setupLottie()
		animationView.play()
		setupBindings()
	}

	func setupLottie() {
		animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
		animationView.center = self.view.center
		animationView.contentMode = .scaleAspectFill
		animationView.loopMode = .loop
		view.addSubview(animationView)
	}

	func hideLottie() {
		animationView.stop()
		animationView.removeFromSuperview()
	}
}

// MARK: bindings
private extension NasaFullSizeViewController {
	func setupBindings() {
		bindTapOnClose()
		bindImage()
	}

	func bindTapOnClose() {
		closeButton.rx.tap
			.bind(to: viewModel.input.tapOnClose)
			.disposed(by: disposeBag)
	}
	
	func bindImage() {
		viewModel.output.url
			.subscribe(onNext: { [weak self] apodUrl in
				guard let self = self else { return }
				if let hdUrl = apodUrl.hdUrl {
					self.nasaFullSizeImage.kf.setImage(with: hdUrl, completionHandler: { (_, _, _, _) in
						self.hideLottie()
					})
				} else {
					self.nasaFullSizeImage.kf.setImage(with: apodUrl.url, completionHandler: { (_, _, _, _) in
						self.hideLottie()
					})
				}
			})
			.disposed(by: disposeBag)
	}
}

// MARK: zoom
extension NasaFullSizeViewController: UIScrollViewDelegate {
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return nasaFullSizeImage
	}
}
