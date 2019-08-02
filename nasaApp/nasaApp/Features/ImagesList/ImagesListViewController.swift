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
	private let spacing:CGFloat = 16.0
	private let cellId = "ImageCell"
	private var disposeBag = DisposeBag()
	var viewModel: ImagesListViewModel!
	private var dataSource: RxCollectionViewSectionedReloadDataSource<ImagesSectionModel>!

	@IBOutlet private weak var collectionView: UICollectionView! {
		didSet {
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
		layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
		layout.minimumLineSpacing = spacing
		layout.minimumInteritemSpacing = spacing
		self.collectionView?.collectionViewLayout = layout
	}
}

private extension ImagesListViewController {
	func setupBindings() {
		dataSource = RxCollectionViewSectionedReloadDataSource(
			configureCell: { [weak self] (_, collectionView, indexPath, url) -> UICollectionViewCell in
				guard let self = self else { return UICollectionViewCell() }
				guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as? ImageCell else { return UICollectionViewCell() }
				cell.configure(url: url)
				return cell
		})

		viewModel.output.sections
			.bind(to: collectionView.rx.items(dataSource: dataSource))
			.disposed(by: disposeBag)
	}
}

extension ImagesListViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

//		let cellWidth2 = CGFloat((collectionView.frame.size.width / 3) - 10)
//		print(cellWidth2)
//		let cellWidth = 100
//		let cellHeight = 100
//
//		return CGSize(width: cellWidth2, height: cellWidth2)

		let numberOfItemsPerRow: CGFloat = 3
		let spacingBetweenCells: CGFloat = 16

		let totalSpacing = (2 * spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
		let width = (collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow - 1
		return CGSize(width: width, height: width)
	}
}
