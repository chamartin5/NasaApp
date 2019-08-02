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
		case .detail:
			return .none
		}
	}

	private func navigateToImagesList() -> FlowContributors {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		guard let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController else {
			return .none
		}
		let viewModel = ImagesListViewModel()
		viewController.viewModel = viewModel

		self.rootViewController.pushViewController(viewController, animated: true)
		return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
	}

//	private func navigateToMemberDetail(memberId: Int) -> FlowContributors {
//		let viewController = StoryboardScene.Member.memberDetailViewController.instantiate()
//		let viewModel = MemberDetailViewModel(memberId: memberId)
//		viewController.viewModel = viewModel
//
//		self.rootViewController.pushViewController(viewController, animated: true)
//		return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
//	}
}
