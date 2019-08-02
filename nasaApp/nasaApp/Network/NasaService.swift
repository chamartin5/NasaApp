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
		return Data()
	}

	public var task: Task {
		let params: [String: Any] = ["media_type": "image"]
		return .requestParameters(parameters: params,
								  encoding: URLEncoding.default)
	}

	public var headers: [String : String]? {
		return nil
	}
}
