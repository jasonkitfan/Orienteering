//
//  MapView.swift
//  Orienteering
//
//  Created by Kit Fan Cheung on 15/6/2023.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: UIViewRepresentable {
    @StateObject private var locationViewModel = LocationViewModel()
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.showsUserLocation = true // Enable showing the user's location on the map
        
        // Create and add two additional annotations to the map
        let annotation1 = MKPointAnnotation()
        annotation1.coordinate = CLLocationCoordinate2D(latitude: 22.31430, longitude: 114.2237)
        annotation1.title = "Check Point 1"
        
        let annotation2 = MKPointAnnotation()
        annotation2.coordinate = CLLocationCoordinate2D(latitude: 22.3231, longitude: 114.2071)
        annotation2.title = "Check Point 2"
        
        mapView.addAnnotations([annotation1, annotation2])
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        guard let coordinate = locationViewModel.location?.coordinate else { return }
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        if !locationViewModel.initialLocationSet {
            mapView.setRegion(region, animated: true)
            locationViewModel.initialLocationSet = true
        }
    }
}

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var initialLocationSet = false
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
