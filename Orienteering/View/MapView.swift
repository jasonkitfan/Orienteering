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
    @State var checkpoints: [CheckpointLocation] = []

    // Function to retrieve the checkpoint data
    private func getCheckpoints(completion: @escaping () -> Void) {
        let firestoreManager = FirestoreManager()
        firestoreManager.getCheckpointData { result in
            switch result {
            case .success(let data):
                // Use the retrieved document data here
                if let locations = data["checkpoints"] as? [[String: Any]] {
                    var checkpointLocations: [CheckpointLocation] = []
                    for checkpointData in locations {
                        if let title = checkpointData["title"] as? String,
                           let location = checkpointData["location"] as? [String: Any],
                           let latitude = location["lat"] as? Double,
                           let longitude = location["long"] as? Double,
                           let point = checkpointData["point"] as? Int {
                            let checkpoint = CheckpointLocation(title: title, latitude: latitude, longitude: longitude, point: point)
                            print(checkpoint)
                            checkpointLocations.append(checkpoint)
                        } else {
                            print("Error: Checkpoint data is missing or invalid")
                        }
                    }
                    self.checkpoints = checkpointLocations
                    print("final checkpoint: \(checkpoints)")
                    completion() // Call the completion handler once the data is retrieved
                } else {
                    print("Checkpoints not found in data")
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    // Function to create and configure the MKMapView
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.showsUserLocation = true // Enable showing the user's location on the map

        let userTrackingButton = MKUserTrackingButton(mapView: mapView)
        userTrackingButton.layer.backgroundColor = UIColor.white.cgColor
        userTrackingButton.layer.borderColor = UIColor.gray.cgColor
        userTrackingButton.layer.borderWidth = 1.0
        userTrackingButton.layer.cornerRadius = 5.0
        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(userTrackingButton)

        NSLayoutConstraint.activate([
            userTrackingButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -12),
            userTrackingButton.bottomAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.bottomAnchor, constant: -12)
        ])

        // Set the map's tracking mode to follow the user's location and heading
        mapView.setUserTrackingMode(.followWithHeading, animated: true)

        return mapView
    }

    // Function to update the MKMapView
    func updateUIView(_ mapView: MKMapView, context: Context) {
        guard let coordinate = locationViewModel.location?.coordinate else { return }

        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)

        if !locationViewModel.initialLocationSet {
            mapView.setRegion(region, animated: true)
            locationViewModel.initialLocationSet = true
        }

        // Call the getCheckpoints function to retrieve the checkpoint data
        getCheckpoints {
            // Remove existing annotations
            mapView.removeAnnotations(mapView.annotations)
            
            // Add new annotations for each checkpoint
            for checkpoint in checkpoints {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: checkpoint.latitude, longitude: checkpoint.longitude)
                annotation.title = "\(checkpoint.title) (\(checkpoint.point))"
                mapView.addAnnotation(annotation)
            }
        }
    }
}

// LocationViewModel class to handle location updates
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
