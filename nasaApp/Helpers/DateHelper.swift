//
//  DateHelper.swift
//  nasaApp
//
//  Created by Charlotte Martin on 03/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//

import Foundation

struct DateHelper {
	static let dateFormat = "yyyy-MM-dd"
	static let americanTimeZone = "CDT"

	static func getDateString(date: Date?) -> String {
		guard let date = date else { return "" }
		let dateFormatter = DateFormatter.dateFormatterLong
		return dateFormatter.string(from: date)
	}
}

extension DateFormatter {
	static let dateFormatterAmerican: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.timeZone = TimeZone(abbreviation: DateHelper.americanTimeZone)
		dateFormatter.dateFormat = DateHelper.dateFormat
		return dateFormatter
	}()

	static let dateFormatterWS: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.timeZone = .current
		dateFormatter.locale = .current
		dateFormatter.dateFormat = DateHelper.dateFormat
		return dateFormatter
	}()

	static var dateFormatterLong: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.timeZone = .current
		dateFormatter.locale = .current
		dateFormatter.dateStyle = .long
		return dateFormatter
	}()
}
