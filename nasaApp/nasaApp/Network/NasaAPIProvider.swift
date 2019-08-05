//
//  ApiProvider.swift
//  nasaApp
//
//  Created by Charlotte Martin on 02/08/2019.
//  Copyright © 2019 Charlotte Martin. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import Result

enum NasaError: Error {
	case failGetApod(Error)
}

class NasaAPIProvider {
	private let provider: MoyaProvider<NasaService>

	init(provider: MoyaProvider<NasaService>) {
		self.provider = provider
	}

	public func getApod(date: String) -> Single<Result<ApodResponse, NasaError>> {
		return provider.rx.request(.apod(date))
			.map(ApodResponse.self)
			.map { nasaReponse -> Result<ApodResponse, NasaError> in
				return .success(nasaReponse)
			}
			.catchError { error -> Single<Result<ApodResponse, NasaError>> in
				print("error for date \(date) \(error)")
				return Single.just(.failure(.failGetApod(error)))
		}
	}
}
