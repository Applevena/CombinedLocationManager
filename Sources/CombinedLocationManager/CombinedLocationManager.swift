//
//	Using Swift 5.0
//
//	Created by Applevena.
//	Copyright © 2021 Applevena. All rights reserved.
//

import UIKit
import Combine
import CoreLocation

public class CombinedLocationManager: ObservableObject {
	
	public static let shared: CombinedLocationManager = CombinedLocationManager()
	
	private let manager: CLLocationManager
	private let publicist: CLLocationManagerPublicistDelegate
	private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
	
	
	@Published public private(set) var authorizationStatus = CLAuthorizationStatus.notDetermined
	@Published public private(set) var location: CLLocation?
	
	
	private init() {
		let manager = CLLocationManager()
		let publicist = CLLocationManagerPublicist()
		
		// デフォルト設定
		manager.delegate = publicist
		manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
		manager.distanceFilter = 10
		manager.activityType = .fitness
		
		self.manager = manager
		self.publicist = publicist
		
		// 認証状態が変更した際に位置情報取得メソッドを呼ぶ
		publicist.authorizationPublisher()
			.sink(receiveValue: self.updateLocationDidChangeAuthorization(_:))
			.store(in: &cancellable)
		
		// 認証状態を保存
		// Viewの描写に関係ある場合メインキューで受け取る
		publicist.authorizationPublisher()
			.receive(on: DispatchQueue.main)
			.assign(to: &$authorizationStatus)
		
		// ユーザーの位置情報を保存
		// 位置情報は配列として渡されるため、シークエンスパブリッシャーを介し1つずつ取り出す
		// CLLocationはオプショナルとして保存するため、オプショナルに変更
		// Viewの描写に関係ある場合メインキューで受け取る
		publicist.locationPublisher()
			.flatMap(Publishers.Sequence.init(sequence:))
			.map { $0 as CLLocation? }
			.receive(on: DispatchQueue.main)
			.assign(to: &$location)
	}
	
	
}


extension CombinedLocationManager {
	
	public func configure(_ customize: @escaping (CLLocationManager) -> Void) {
		customize(manager)
	}
	
	public func requestAuthorization() {
		manager.requestWhenInUseAuthorization()
	}
	
	public func openSetting() {
		UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
	}
	
	public func requestLocation() {
		handleAuthorization { manager.requestLocation() }
	}
	
	public func startUpdatingLocation() {
		handleAuthorization { manager.startUpdatingLocation() }
	}
	
	public func stopUpdatingLocation() {
		handleAuthorization { manager.stopUpdatingLocation() }
	}
	
	
	private func handleAuthorization(for method: () -> Void) {
		switch manager.authorizationStatus {
			case .authorizedAlways, .authorizedWhenInUse: method()
			case .notDetermined: manager.requestWhenInUseAuthorization()
			case .denied, .restricted: openSetting()
			@unknown default: return
		}
	}
	
	private func updateLocationDidChangeAuthorization(_ receiveValue: CLAuthorizationStatus) {
		switch receiveValue {
			case .authorizedAlways, .authorizedWhenInUse: manager.requestLocation()
			case .notDetermined: manager.requestWhenInUseAuthorization()
			default: return
		}
	}
	
	
}
