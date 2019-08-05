//
//  AppStep.swift
//  nasaApp
//
//  Created by Charlotte Martin on 02/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//
import RxFlow

enum AppStep: Step {
	case apodList
	case apodDetails(ApodItem)
	case nasaFullSize(ApodUrl)
	case closeModal
}
