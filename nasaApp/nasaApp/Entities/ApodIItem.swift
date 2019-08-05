//
//  ApodItem.swift
//  nasaApp
//
//  Created by Charlotte Martin on 03/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//

import Foundation

enum ApodState {
	case success(ApodItem)
	case failure
}

struct ApodItem {
	let title: String
	let description: String
	let date: Date?
	let url: URL?
	let hdUrl: URL?
}

struct ApodUrl {
	let url: URL?
	let hdUrl: URL?
}


