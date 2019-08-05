//
//  NasaService.swift
//  nasaApp
//
//  Created by Charlotte Martin on 04/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//

import Moya

enum NasaService: TargetType {

	static private let apiKey = "fv6pNsXF8ycuZY5wdA9utKTOg42JBcWa2V0DUMAl"

	case apod(String)

	var baseURL: URL {
		return URL(string: "https://api.nasa.gov")!
	}

	var path: String {
		return "planetary/apod"
	}

	var method: Method {
		return .get
	}

	var sampleData: Data {
		let data = getData(file: "apod")
		return data
	}

	var task: Task {
		switch self {
		case .apod(let date):
			let params: [String: Any] = ["api_key": NasaService.apiKey,
										 "date": date,
										 "hd": true
			]
			return .requestParameters(parameters: params,
									  encoding: URLEncoding.default)
		}
	}

	var headers: [String : String]? {
		return nil
	}

	func getData (file: String) -> Data {
		let fileExtension = "json"
		guard let path = Bundle.main.path(forResource: file, ofType: fileExtension) else {
			return Data()
		}
		let pathURL = URL(fileURLWithPath: path)
		do {
			let data = try Data(contentsOf: pathURL, options: .dataReadingMapped)
			return data
		} catch(let error) {
			#if DEBUG
			print("error in getting json data\(error)")
			#endif
			return Data()
		}
	}
}
