//
//  DateHelper.swift
//  nasaApp
//
//  Created by Charlotte Martin on 03/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//

import Foundation

extension DateFormatter {
	static let dateFormatterAmerican: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.timeZone = TimeZone(abbreviation: "CDT")
		dateFormatter.dateFormat = "yyyy-MM-dd"
		return dateFormatter
	}()

	static let dateFormatterWS: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.timeZone = .current
		dateFormatter.locale = .current
		dateFormatter.dateFormat = "yyyy-MM-dd"
		return dateFormatter
	}()
}
