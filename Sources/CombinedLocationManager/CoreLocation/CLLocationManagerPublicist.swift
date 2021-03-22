//
//	Using Swift 5.0
//
//	Created by Applevena.
//	Copyright © 2021 Applevena. All rights reserved.
//

import Combine
import CoreLocation

class CLLocationManagerPublicist: NSObject {
	private let authorizationSubject = PassthroughSubject<CLAuthorizationStatus, Never>()
	private let locationSubject = PassthroughSubject<[CLLocation], Never>()
	
	
}


extension CLLocationManagerPublicist: CLLocationManagerPublicistDelegate {
	func authorizationPublisher() -> AnyPublisher<CLAuthorizationStatus, Never> {
		return Just(CLAuthorizationStatus.notDetermined)
			.merge(with: authorizationSubject.compactMap { $0 })
			.eraseToAnyPublisher()
	}
	
	func locationPublisher() -> AnyPublisher<[CLLocation], Never> {
		return locationSubject.eraseToAnyPublisher()
	}
	
	
}


// CLLocationManagerDelegateとCombineを連結
extension CLLocationManagerPublicist {
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		locationSubject.send(locations)
	}
	
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		authorizationSubject.send(manager.authorizationStatus)
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		#if DEBUG
		print(#function, error)
		#endif
	}
	
	
}
