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

class NasaAPIProvider {
	private let provider: MoyaProvider<NasaService>

	init(provider: MoyaProvider<NasaService>) {
		self.provider = provider
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
}
