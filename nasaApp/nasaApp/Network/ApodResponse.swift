//
//  ApodResponse.swift
//  nasaApp
//
//  Created by Charlotte Martin on 02/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//

import Foundation

struct ApodResponse: Codable {
	let date: String
	let explanation: String
	let hdurl: String?
	let title: String
	let url: String
	let mediaType: MediaType

	enum MediaType: String, Codable {
		case image
		case video
	}
}
