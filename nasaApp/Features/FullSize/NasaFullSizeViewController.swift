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
		static let minZoom: CGFloat = 1
		static let maxZoom: CGFloat = 5
		static let lottieSize = 200
	}

	let animationView = AnimationView(name: Constants.loaderName)
	var viewModel: NasaFullSizeViewModel!
	private let disposeBag = DisposeBag()

	@IBOutlet private weak var nasaFullSizeImage: UIImageView! {
		didSet {
			nasaFullSizeImage.contentMode = .scaleAspectFit
			nasaFullSizeImage.isUserInteractionEnabled = true
		}
	}

	@IBOutlet weak var scrollView: UIScrollView! {
		didSet {
			scrollView.minimumZoomScale = Constants.minZoom
			scrollView.maximumZoomScale = Constants.maxZoom
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

	override func viewDidLoad() {
		super.viewDidLoad()
		setupLottie()
		animationView.play()
		setupBindings()
		setupImageDoubleTap()
	}
}

// MARK: configuration
private extension NasaFullSizeViewController {
	func setupImageDoubleTap() {
		let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
		gestureRecognizer.numberOfTapsRequired = 2
		scrollView.addGestureRecognizer(gestureRecognizer)
	}

	@objc func handleDoubleTap() {
		if scrollView.zoomScale == Constants.minZoom {
			scrollView.zoomScale = Constants.maxZoom
		} else {
			scrollView.zoomScale = Constants.minZoom
		}
	}

	func setupLottie() {
		animationView.frame = CGRect(x: 0, y: 0, width: Constants.lottieSize, height: Constants.lottieSize)
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
