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
	private let storyboard = UIStoryboard(name: "Main", bundle: nil)

	func navigate(to step: Step) -> FlowContributors {
		guard let step = step as? AppStep else { return .none }
		switch step {
		case .apodList:
			return navigateToApodList()
		case .apodDetails(let apodItem):
			return navigateToApodDetails(apodItem: apodItem)
		case .nasaFullSize(let apodUrl):
			return navigateToNasaFullSizeModally(apodUrl: apodUrl)
		case .closeModal:
			rootViewController.topViewController?.dismiss(animated: true, completion: nil)
			return .none
		}
	}

	private func navigateToApodList() -> FlowContributors {
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
		guard let viewController = storyboard.instantiateViewController(withIdentifier: "NasaDetailsViewController") as? NasaDetailsViewController else {
			return .none
		}
		let viewModel = NasaDetailsViewModel(apodItem: apodItem)
		viewController.viewModel = viewModel

		rootViewController.pushViewController(viewController, animated: true)
		return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
	}

	func navigateToNasaFullSizeModally(apodUrl: ApodUrl) -> FlowContributors {
		guard let viewController = storyboard.instantiateViewController(withIdentifier: "NasaFullSizeViewController") as? NasaFullSizeViewController else {
			return .none
		}
		let viewModel = NasaFullSizeViewModel(apodUrl: apodUrl)
		viewController.viewModel = viewModel

		rootViewController.present(viewController, animated: true, completion: nil)
		return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
	}
}
