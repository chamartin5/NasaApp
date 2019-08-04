//
//  ApodResponse.swift
//  nasaApp
//
//  Created by Charlotte Martin on 02/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//

import Foundation

public class ApodResponse: Codable {
	let date: String
	let explanation: String
	let hdurl: String?
	let title: String
	let url: String
	let mediaType: MediaType

	enum ApodResponseCodingKeys: String, CodingKey {
		case date
		case explanation
		case hdurl
		case title
		case url
		case mediaType = "media_type"
	}

	public required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: ApodResponseCodingKeys.self)
		date = try container.decode(String.self, forKey: .date)
		explanation = try container.decode(String.self, forKey: .explanation)
		hdurl = try container.decodeIfPresent(String.self, forKey: .hdurl)
		title = try container.decode(String.self, forKey: .title)
		url = try container.decode(String.self, forKey: .url)
		mediaType = try container.decode(MediaType.self, forKey: .mediaType)
	}

	public enum MediaType: String, Codable {
		case image
		case video
	}
}
