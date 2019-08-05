//
//  ApiProvider.swift
//  nasaApp
//
//  Created by Charlotte Martin on 02/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//

import Moya
import RxSwift
import Result

enum NasaError: Error {
	case failGetApod(Error)
	case apodIsVideo
}

class NasaAPIProvider {
	private let provider: MoyaProvider<NasaService>

	init(provider: MoyaProvider<NasaService>) {
		self.provider = provider
	}

	func getApod(date: String) -> Single<Result<ApodResponse, NasaError>> {
		return provider.rx.request(.apod(date))
			.map { response -> Result<ApodResponse, NasaError> in
				let decoder = JSONDecoder()
				decoder.keyDecodingStrategy = .convertFromSnakeCase
				do {
					let apodResponse = try decoder.decode(ApodResponse.self, from: response.data)
					return .success(apodResponse)
				} catch {
					return .failure(.failGetApod(error))
				}
			}
	}
}
