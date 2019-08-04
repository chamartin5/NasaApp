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

enum ImageError: Error {
	case failGetImages
}

enum NasaError: Error {
	case failGetApod(Error)
}

class NasaAPIProvider {
	private let provider: MoyaProvider<NasaService>
	private let provider2: MoyaProvider<Nasa2Service>

	init(provider: MoyaProvider<NasaService>, provider2: MoyaProvider<Nasa2Service>) {
		self.provider = provider
		self.provider2 = provider2
	}

	public func getNasaImagesDetail() -> Single<Result<NasaResponse, ImageError>> {
		return provider.rx.request(.all)
			.map(NasaResponse.self)
			.map { nasaReponse -> Result<NasaResponse, ImageError> in
				return .success(nasaReponse)
			}
			.catchError { error -> Single<Result<NasaResponse, ImageError>> in
				return Single.just(.failure(.failGetImages))
		}
	}

	public func getApod(date: String) -> Single<Result<ApodResponse, NasaError>> {
		return provider2.rx.request(.apod(date))
			.map(ApodResponse.self)
			.map { nasaReponse -> Result<ApodResponse, NasaError> in
				return .success(nasaReponse)
			}
			.catchError { error -> Single<Result<ApodResponse, NasaError>> in
				print("in error for date \(date)")
				return Single.just(.failure(.failGetApod(error)))
		}
	}
}
