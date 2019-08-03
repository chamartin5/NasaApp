//
//  NasaMapper.swift
//  nasaApp
//
//  Created by Charlotte Martin on 03/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//

import Foundation

final class NasaMapper {
	static func mapFromWS(_ response: NasaResponse) -> [NasaItem] {
		return response.collection.items.map { nasaResponseItem -> NasaItem? in
			guard let data = nasaResponseItem.data.first, let linkData = nasaResponseItem.links.first else { return nil }
			return NasaItem(center: data.center,
							title: data.title,
							description: data.description,
							createdDate: data.createdDate,
							keywords: data.keywords,
							nasaId: data.nasaId,
							imageUrl: URL(string: linkData.href))
		}
		.compactMap { $0 }
	}
}
