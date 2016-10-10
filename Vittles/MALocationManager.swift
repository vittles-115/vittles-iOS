
import Foundation
import CoreLocation
import MapKit

class MALocationManager: CLLocationManager {
    
    static let sharedInstance = MALocationManager()
    var userLocation: CLLocation? {
        get {
            return askForAuthorization()
        }
    }
    
    override init() {
        super.init()
        askForAuthorization()
        desiredAccuracy = kCLLocationAccuracyBest
        startUpdatingLocation()
    }
    
    fileprivate func askForAuthorization() -> CLLocation? {
        if self.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)) {
            if CLLocationManager.authorizationStatus() != .authorizedWhenInUse || CLLocationManager.authorizationStatus() != .authorizedAlways {
                requestWhenInUseAuthorization()
            } else {
                return location
            }
        }
        
        return location
    }
}
