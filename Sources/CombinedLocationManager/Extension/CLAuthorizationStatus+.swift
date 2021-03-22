//
//	Using Swift 5.0
//
//	Created by Applevena.
//	Copyright © 2021 Applevena. All rights reserved.
//

import CoreLocation

extension CLAuthorizationStatus: CustomStringConvertible {
	public var description: String {
		switch self {
			case .authorizedAlways: return "Authorized Always"
			case .authorizedWhenInUse: return "Authorized When In Use"
			case .denied: return "Denied"
			case .notDetermined: return "Not Determined"
			case .restricted: return "Restricted"
			@unknown default: return "Unknown"
		}
	}
	
	public var isAuthorized: Bool {
		return self == .authorizedAlways || self == .authorizedWhenInUse
	}
	
	
}
