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

class APIProvider {
	private let provider: MoyaProvider<NasaService>

	init(provider: MoyaProvider<NasaService>) {
		self.provider = provider
	}

	public func getDetail() -> Single<Result<ImageResponse, ImageError>> {
		return provider.rx.request(.all)
			.map(ImageResponse.self)
			.map { images -> Result<ImageResponse, ImageError> in
				return .success(images)
			}
			.catchError { error -> Single<Result<ImageResponse, ImageError>> in
				return Single.just(.failure(.failGetImages))
			}
	}
}
//			.map { rawResponse -> Result<ImageResponse, ImageError> in
//				guard let jsonResponse = try rawResponse.mapJSON() as? [String: Any] else {
//					return .failure(.failGetImages)
//				}
//
//				if let data = jsonResponse["data"] as? [String: Any] ,
//					let errorDictionnary = data["errors"] as? [String: [String]] {
//					let errors = errorDictionnary.map { $0.value }.flatMap { $0 }
//					return .failure(.failGetImages)
//				}
//
//				do {
//					let imageResponse = try rawResponse.map(ImageResponse.self)
//					return .success(imageResponse)
//				} catch {
//					return .failure(.failGetImages)
//				}
//			}




//func getCurrent() -> Single<Result<CustomerResponse, UserError>> {
//    return provider
//        .request(.currentCustomer)
//        .map(CustomerResponse.self)
//        .map { user -> Result<CustomerResponse, UserError> in
//            return .success(user)
//        }
//        .catchError { error -> Single<Result<CustomerResponse, UserError>> in
//            return Single.just(.failure(.failFetchingUser(error)))
//    }
//}
