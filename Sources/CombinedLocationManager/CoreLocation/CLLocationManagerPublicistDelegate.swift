//
//	Using Swift 5.0
//
//	Created by Applevena.
//	Copyright © 2021 Applevena. All rights reserved.
//

import Combine
import CoreLocation

public protocol CLLocationManagerPublicistDelegate: CLLocationManagerDelegate {
	func authorizationPublisher() -> AnyPublisher<CLAuthorizationStatus, Never>
	
	func locationPublisher() -> AnyPublisher<[CLLocation], Never>
	
	
}
