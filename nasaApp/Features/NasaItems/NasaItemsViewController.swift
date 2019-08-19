//
//  ViewController.swift
//  nasaApp
//
//  Created by Charlotte Martin on 02/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import RxGesture

final class NasaItemsViewController: UIViewController {
	private enum Constants {
		static let cellSuccessId = "ImageCell"
		static let cellErrorId = "ErrorCell"
		static let cellLoaderId = "LoaderCell"
		static let spacing: CGFloat = 15
		static let numberOfItemsPerRow: CGFloat = 3
	}

	private let disposeBag = DisposeBag()
	var viewModel: NasaItemsViewModel!
	private var dataSource: RxCollectionViewSectionedReloadDataSource<NasaSectionModel>!

	@IBOutlet private weak var collectionView: UICollectionView! {
		didSet {
			let cellSuccessId = Constants.cellSuccessId
			collectionView.register(UINib.init(nibName: cellSuccessId, bundle: Bundle.main), forCellWithReuseIdentifier: cellSuccessId)
			let cellErrorId = Constants.cellErrorId
			collectionView.register(UINib.init(nibName: cellErrorId, bundle: Bundle.main), forCellWithReuseIdentifier: cellErrorId)
			let cellLoaderId = Constants.cellLoaderId
			collectionView.register(UINib.init(nibName: cellLoaderId, bundle: Bundle.main), forCellWithReuseIdentifier: cellLoaderId)
			collectionView.rx.setDelegate(self).disposed(by: disposeBag)
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupCollectionViewUI()
		setupBindings()
	}
}

// MARK: UI
private extension NasaItemsViewController {
	func setupCollectionViewUI() {
		let layout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: Constants.spacing, left: Constants.spacing, bottom: Constants.spacing, right: Constants.spacing)
		layout.minimumLineSpacing = Constants.spacing
		layout.minimumInteritemSpacing = Constants.spacing
		self.collectionView?.collectionViewLayout = layout
	}

	func configureLoadingCell(indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellLoaderId, for: indexPath) as? LoaderCell else { return UICollectionViewCell() }
		cell.playLoader()
		return cell
	}

	func configureCellSuccess(indexPath: IndexPath, apodItem: ApodItem) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellSuccessId, for: indexPath) as? ImageCell else { return UICollectionViewCell() }
		cell.configure(url: apodItem.url)
		setupTapOnCell(cell: cell, apodItem: apodItem)
		return cell
	}

	func configureCellError(indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellErrorId, for: indexPath) as? ErrorCell else { return UICollectionViewCell() }
		cell.configureError()
		return cell
	}

	func configureCellIsVideo(indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellErrorId, for: indexPath) as? ErrorCell else { return UICollectionViewCell() }
		cell.configureIsVideo()
		return cell
	}
}

// MARK: bindings
private extension NasaItemsViewController {
	func setupBindings() {
		setupDataSource()
	}

	func setupDataSource() {
		dataSource = RxCollectionViewSectionedReloadDataSource(
			configureCell: { [weak self] (_, collectionView, indexPath, apodState) -> UICollectionViewCell in
				guard let self = self else { return UICollectionViewCell() }
				switch apodState {
				case .loading:
					return self.configureLoadingCell(indexPath: indexPath)
				case .success(let apodItem):
					return self.configureCellSuccess(indexPath: indexPath, apodItem: apodItem)
				case .failure:
					return self.configureCellError(indexPath: indexPath)
				case .apodIsVideo:
					return self.configureCellIsVideo(indexPath: indexPath)
				}
		})

		viewModel.output.sections
			.bind(to: collectionView.rx.items(dataSource: dataSource))
			.disposed(by: disposeBag)
	}

	func setupTapOnCell(cell: ImageCell, apodItem: ApodItem) {
		cell.rx.tapGesture().when(.recognized)
			.map { _ -> ApodItem in
				return apodItem
			}
			.bind(to: viewModel.input.tapOnCell)
			.disposed(by: cell.disposeBag)
	}
}

// MARK: collection view config
extension NasaItemsViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let totalSpacing = Constants.spacing * (Constants.numberOfItemsPerRow + 1)
		let collectionViewWidth = collectionView.bounds.width
		let width = Int((collectionViewWidth - totalSpacing) / Constants.numberOfItemsPerRow)
		return CGSize(width: width, height: width)
	}
}
