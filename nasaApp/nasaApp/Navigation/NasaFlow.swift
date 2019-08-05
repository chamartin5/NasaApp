//
//  NasaFlow.swift
//  nasaApp
//
//  Created by Charlotte Martin on 02/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//
import RxFlow
import Moya

final class NasaFlow: Flow {
	var root: Presentable {
		return rootViewController
	}

	private let rootViewController = UINavigationController()

	func navigate(to step: Step) -> FlowContributors {
		guard let step = step as? AppStep else { return .none }
		switch step {
		case .apodList:
			return navigateToApodList()
		case .apodDetails(let apodItem):
			return navigateToApodDetails(apodItem: apodItem)
		case .nasaFullSize(let apodUrl):
			return navigateToNasaFullSize(apodUrl: apodUrl)
		}
	}

	private func navigateToApodList() -> FlowContributors {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		guard let viewController = storyboard.instantiateViewController(withIdentifier: "NasaItemsViewController") as? NasaItemsViewController else {
			return .none
		}
		let nasaApiProvider = NasaAPIProvider(provider: MoyaProvider<NasaService>())
		let viewModel = NasaItemsViewModel(nasaApiProvider: nasaApiProvider)
		viewController.viewModel = viewModel

		rootViewController.pushViewController(viewController, animated: true)
		return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
	}

	private func navigateToApodDetails(apodItem: ApodItem) -> FlowContributors {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		guard let viewController = storyboard.instantiateViewController(withIdentifier: "NasaDetailsViewController") as? NasaDetailsViewController else {
			return .none
		}
		let viewModel = NasaDetailsViewModel(apodItem: apodItem)
		viewController.viewModel = viewModel

		rootViewController.pushViewController(viewController, animated: true)
		return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
	}

	private func navigateToNasaFullSize(apodUrl: ApodUrl) -> FlowContributors {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		guard let viewController = storyboard.instantiateViewController(withIdentifier: "NasaFullSizeViewController") as? NasaFullSizeViewController else {
			return .none
		}
		let viewModel = NasaFullSizeViewModel(apodUrl: apodUrl)
		viewController.viewModel = viewModel

		rootViewController.pushViewController(viewController, animated: true)
		return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
	}

	func navigateToNasaFullSizeModally(apodUrl: ApodUrl) -> FlowContributors {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		guard let viewController = storyboard.instantiateViewController(withIdentifier: "NasaFullSizeViewController") as? NasaFullSizeViewController else {
			return .none
		}
		let viewModel = NasaFullSizeViewModel(apodUrl: apodUrl)
		viewController.viewModel = viewModel

		rootViewController.popViewController(animated: true)
		rootViewController.present(viewController, animated: true, completion: nil)
		return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
	}
}
