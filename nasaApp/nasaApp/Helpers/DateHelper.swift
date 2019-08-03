//
//  DateHelper.swift
//  nasaApp
//
//  Created by Charlotte Martin on 03/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//

import Foundation

extension DateFormatter {
	static var dateFormatterLong: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.timeZone = .current
		dateFormatter.timeZone = .current
		dateFormatter.dateStyle = .long
		return dateFormatter
	}()

	static var iso8601: ISO8601DateFormatter = {
		let dateFormatter = ISO8601DateFormatter()
		dateFormatter.timeZone = .current
		return dateFormatter
	}()
}
