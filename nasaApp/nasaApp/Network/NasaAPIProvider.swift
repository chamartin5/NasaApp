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

	public func getNasaImagesDetail() -> Single<Result<[NasaItem], ImageError>> {
		return provider.rx.request(.all)
			.map(NasaResponse.self)
			.map { nasaReponse -> Result<[NasaItem], ImageError> in
				let items = NasaMapper.mapFromWS(nasaReponse)
				return .success(items)
			}
			.catchError { error -> Single<Result<[NasaItem], ImageError>> in
				return Single.just(.failure(.failGetImages))
		}
	}
}
