//
//  ApodItem.swift
//  nasaApp
//
//  Created by Charlotte Martin on 03/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//

import Foundation

enum ApodState: Equatable {
	static func == (lhs: ApodState, rhs: ApodState) -> Bool {
		switch (lhs, rhs) {
		case (.loading, .loading):
			return true
		case (.success(let item1), .success(let item2)):
			return item1.date == item2.date &&
			item1.description ==  item2.description &&
			item1.hdUrl == item2.hdUrl &&
			item1.url == item2.url &&
			item1.url == item2.url
		case (.failure, .failure):
			return true
		case (.apodIsVideo, .apodIsVideo):
			return true
		default:
			return false
		}
	}

	case loading
	case success(ApodItem)
	case failure
	case apodIsVideo
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


