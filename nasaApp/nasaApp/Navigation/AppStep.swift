//
//  AppStep.swift
//  nasaApp
//
//  Created by Charlotte Martin on 02/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//
import RxFlow

enum AppStep: Step {

	// Member
	case imagesList
	case detail(NasaItem)
	case nasaFullSize(URL?)
}
