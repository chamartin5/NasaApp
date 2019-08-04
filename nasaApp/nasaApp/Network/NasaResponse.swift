//
//  NasaResponse.swift
//  nasaApp
//
//  Created by Charlotte Martin on 02/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//

import Foundation

public class NasaResponse: Codable {
	let collection: CollectionResponse
}

struct CollectionResponse: Codable {
	let items: [ItemResponse]
}

struct ItemResponse: Codable {
	let data: [ImageDataResponse]
	let links: [LinkDataResponse]
}

class ImageDataResponse: Codable {
	let center: String
	let title: String
	let description: String
	let createdDate: String
	let keywords: [String]
	let nasaId: String

	enum ImageDataCodingKeys: String, CodingKey {
		case center
		case title
		case description
		case createdDate = "date_created"
		case keywords
		case nasaId = "nasa_id"
	}

	public required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: ImageDataCodingKeys.self)
		center = try container.decode(String.self, forKey: .center)
		title = try container.decode(String.self, forKey: .title)
		description = try container.decode(String.self, forKey: .description)
		createdDate = try container.decode(String.self, forKey: .createdDate)
		keywords = try container.decode([String].self, forKey: .keywords)
		nasaId = try container.decode(String.self, forKey: .nasaId)
	}
}

struct LinkDataResponse: Codable {
	let href: String
}
