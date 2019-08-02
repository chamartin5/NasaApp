//
//  ImagesResponse.swift
//  nasaApp
//
//  Created by Charlotte Martin on 02/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//

import Foundation

public class ImageResponse: Codable {
	let collection: Collection
}

struct Collection: Codable {
	let items: [Item]
}

struct Item: Codable {
	let data: [ImageData]
	let links: [LinkData]
}

struct ImageData: Codable {
	let title: String
}

struct LinkData: Codable {
	let href: String
}
