//
//  NasaMapper.swift
//  nasaApp
//
//  Created by Charlotte Martin on 03/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//

import Foundation

final class NasaMapper {
	static func mapFromWS(_ responses: [ApodResponse]) -> [ApodItem] {
		return responses.map({ response -> ApodItem in
			let date = DateFormatter.dateFormatterWS.date(from: response.date)
			var hdUrl: URL?
			if let responseHd = response.hdurl {
				hdUrl = URL(string: responseHd)
			}
			return ApodItem(title: response.title,
							description: response.explanation,
							date: date,
							url: URL(string: response.url),
							hdUrl: hdUrl
			)
		})
	}

	static func mapFromWS(_ response: ApodResponse) -> ApodItem {
			let date = DateFormatter.dateFormatterWS.date(from: response.date)
			var hdUrl: URL?
			if let responseHd = response.hdurl {
				hdUrl = URL(string: responseHd)
			}
			return ApodItem(title: response.title,
							description: response.explanation,
							date: date,
							url: URL(string: response.url),
							hdUrl: hdUrl
			)
	}
}
