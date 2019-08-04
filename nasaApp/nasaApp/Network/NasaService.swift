//
//  NasaService.swift
//  nasaApp
//
//  Created by Charlotte Martin on 04/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//

import Moya

public enum NasaService: TargetType {

	static private let apiKey = "fv6pNsXF8ycuZY5wdA9utKTOg42JBcWa2V0DUMAl"

	case apod(String)

	public var baseURL: URL {
		return URL(string: "https://api.nasa.gov")!
	}

	public var path: String {
		return "planetary/apod"
	}

	public var method: Method {
		return .get
	}

	public var sampleData: Data {
		let data = getData(file: "apod")
		return data
	}

	public var task: Task {
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

	public var headers: [String : String]? {
		return nil
	}

	public func getData (file: String) -> Data {
		let fileExtension = "json"
		guard let path = Bundle.main.path(forResource: file, ofType: fileExtension) else {
			return Data()
		}
		let pathURL = URL(fileURLWithPath: path)
		do {
			let data = try Data(contentsOf: pathURL, options: .dataReadingMapped)
			return data
		} catch(let error) {
			print(error)
			return Data()
		}
	}
}
