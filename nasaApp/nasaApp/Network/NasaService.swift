//
//  NasaService.swift
//  nasaApp
//
//  Created by Charlotte Martin on 02/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//

import Moya

public enum NasaService: TargetType {

	static private let publicKey = "YOUR PUBLIC KEY"
	static private let privateKey = "YOUR PRIVATE KEY"

	case all

	public var baseURL: URL {
		return URL(string: "https://images-api.nasa.gov")!
	}

	public var path: String {
		return "search"
	}

	public var method: Method {
		return .get
	}

	public var sampleData: Data {
		let data = getData(file: "nasaImages")
		return data
	}

	public var task: Task {
		let params: [String: Any] = ["media_type": "image"]
		return .requestParameters(parameters: params,
								  encoding: URLEncoding.default)
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
