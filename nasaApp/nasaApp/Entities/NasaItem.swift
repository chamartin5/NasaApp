//
//  NasaItem.swift
//  nasaApp
//
//  Created by Charlotte Martin on 03/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//

import Foundation

public struct NasaItem {
	let center: String
	let title: String
	let description: String
	let createdDate: Date?
	let keywords: [String]
	let nasaId: String
	let imageUrl: URL?
}
