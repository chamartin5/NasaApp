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

class ImagesListViewController: UIViewController {
	private enum Constants {
		static let cellId = "ImageCell"
		static let spacing: CGFloat = 15
		static let numberOfItemsPerRow: CGFloat = 3
	}

	private var disposeBag = DisposeBag()
	var viewModel: ImagesListViewModel!
	private var dataSource: RxCollectionViewSectionedReloadDataSource<ImagesSectionModel>!

	@IBOutlet private weak var collectionView: UICollectionView! {
		didSet {
			let cellId = Constants.cellId
			collectionView.register(UINib.init(nibName: cellId, bundle: nil), forCellWithReuseIdentifier: cellId)
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
private extension ImagesListViewController {
	func setupCollectionViewUI() {
		let layout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: Constants.spacing, left: Constants.spacing, bottom: Constants.spacing, right: Constants.spacing)
		layout.minimumLineSpacing = Constants.spacing
		layout.minimumInteritemSpacing = Constants.spacing
		self.collectionView?.collectionViewLayout = layout
	}
}

private extension ImagesListViewController {
	func  setupBindings() {
		setupDataSource()
		setupTapOnCell()
	}

	func setupDataSource() {
		dataSource = RxCollectionViewSectionedReloadDataSource(
			configureCell: { (_, collectionView, indexPath, data) -> UICollectionViewCell in
				guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellId, for: indexPath) as? ImageCell else { return UICollectionViewCell() }
				cell.configure(url: data.imageUrl)
				return cell
		})

		viewModel.output.sections
			.bind(to: collectionView.rx.items(dataSource: dataSource))
			.disposed(by: disposeBag)
	}

	func setupTapOnCell() {
		collectionView.rx.modelSelected(NasaItem.self)
			.subscribe(onNext: { value in
				print("modelSelected \(value)")
			})
			.disposed(by: disposeBag)
	}
}

extension ImagesListViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let totalSpacing = Constants.spacing * (Constants.numberOfItemsPerRow + 1)
		let collectionViewWidth = collectionView.bounds.width
		let width = Int((collectionViewWidth - totalSpacing) / Constants.numberOfItemsPerRow)
		return CGSize(width: width, height: width)
	}
}
