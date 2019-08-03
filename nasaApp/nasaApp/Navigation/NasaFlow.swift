//
//  NasaFlow.swift
//  nasaApp
//
//  Created by Charlotte Martin on 02/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//
import RxFlow

class NasaFlow: Flow {
	var root: Presentable {
		return rootViewController
	}

	private let rootViewController = UINavigationController()

	func navigate(to step: Step) -> FlowContributors {
		guard let step = step as? AppStep else { return .none }
		switch step {
		case .imagesList:
			return navigateToImagesList()
		case .detail(let nasaItem):
			return navigateToNasaItem(nasaItem: nasaItem)
		case .nasaFullSize(let url):
			return navigateToNasaFullSize(url: url)
		}
	}

	private func navigateToImagesList() -> FlowContributors {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		guard let viewController = storyboard.instantiateViewController(withIdentifier: "NasaItemsViewController") as? NasaItemsViewController else {
			return .none
		}
		let viewModel = NasaItemsViewModel()
		viewController.viewModel = viewModel

		self.rootViewController.pushViewController(viewController, animated: true)
		return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
	}

	private func navigateToNasaItem(nasaItem: NasaItem) -> FlowContributors {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		guard let viewController = storyboard.instantiateViewController(withIdentifier: "NasaDetailsViewController") as? NasaDetailsViewController else {
			return .none
		}
		let viewModel = NasaDetailsViewModel(nasaItem: nasaItem)
		viewController.viewModel = viewModel

		self.rootViewController.pushViewController(viewController, animated: true)
		return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
	}

	private func navigateToNasaFullSize(url: URL?) -> FlowContributors {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		guard let viewController = storyboard.instantiateViewController(withIdentifier: "NasaFullSizeViewController") as? NasaFullSizeViewController else {
			return .none
		}
		let viewModel = NasaFullSizeViewModel(url: url)
		viewController.viewModel = viewModel

		self.rootViewController.pushViewController(viewController, animated: true)
		return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
	}

	func navigateToNasaFullSizeModally(url: URL?) -> FlowContributors {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		guard let viewController = storyboard.instantiateViewController(withIdentifier: "NasaFullSizeViewController") as? NasaFullSizeViewController else {
			return .none
		}
		let viewModel = NasaFullSizeViewModel(url: url)
		viewController.viewModel = viewModel

		self.rootViewController.present(viewController, animated: true, completion: nil)
		return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
	}
}
