//
//  NasaMapper.swift
//  nasaApp
//
//  Created by Charlotte Martin on 03/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//

import Foundation

final class NasaMapper {
	static func mapFromWS(_ response: [ItemResponse]) -> [NasaItem] {
		return response.map { nasaResponseItem -> NasaItem? in
			guard let data = nasaResponseItem.data.first, let linkData = nasaResponseItem.links.first else { return nil }
			let createdDate = DateFormatter.iso8601.date(from: data.createdDate)
			return NasaItem(center: data.center,
							title: data.title,
							description: data.description,
							createdDate: createdDate,
							keywords: data.keywords,
							nasaId: data.nasaId,
							imageUrl: URL(string: linkData.href))
		}
		.compactMap { $0 }
	}

	static func mapFromWS(_ responses: [ApodResponse]) -> [ApodItem] {
		return responses.map({ response -> ApodItem in
			let date = DateFormatter.dateFormatterWS.date(from: response.date)
			return ApodItem(title: response.title,
							description: response.explanation,
							date: date,
							url: URL(string: response.url)
			)
		})
	}
}
