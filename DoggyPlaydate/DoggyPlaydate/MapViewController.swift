//
//  MapViewController.swift
//  DoggyPlaydate
//
//  Created by user203663 on 11/11/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var mapView: MKMapView!
    
    override func loadView() {
        //create map view
        mapView = MKMapView()
        view = mapView
        
        //creating segmneted control bar
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.systemBackground
        segmentedControl.selectedSegmentIndex = 0;
        segmentedControl.addTarget(self, action: #selector(mapTypeChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        //constraints for segmented control
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        //constraints are active
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        //starts the map centered over Burlington
        let startLocation = CLLocationCoordinate2D(latitude: 44.4759, longitude: -73.2121)
        let startRegion = MKCoordinateRegion(center: startLocation, latitudinalMeters: CLLocationDistance(exactly: 5000)!, longitudinalMeters: CLLocationDistance(exactly: 5000)!)
        mapView.setRegion(startRegion, animated: true)
    }
    
    // Creates map annotation
    func makePoint(park: Park) {
        let parkAnnotation = MKPointAnnotation()
        parkAnnotation.title = park.name
        parkAnnotation.coordinate = CLLocationCoordinate2D(latitude: park.latitude, longitude: park.longitude)
        mapView.addAnnotation(parkAnnotation)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Parks"

        Park.fetchAllDocuments() { parks in
            // Make a point for each park
            let parksNonNil = parks.compactMap({ $0 })
            for park in parksNonNil {
                self.makePoint(park: park)
            }
        }
        
        // Uncomment to rewrite Park test data to Park.COLLECTION_NAME
//        for park in Park.TEST_DATA {
//            Park.writeDocument(obj: park) { success in /* pass */ }
//        }
        
        //creating temp park annotation
        //let park1 = Park(name: "Waterfront Park", street: "Lake Street", town: "Burlington", state: "VT", lat: 44.480024, long: -73.222048)
        //let park1Annotation = MKPointAnnotation()
        //park1Annotation.title = park1.name
        //park1Annotation.coordinate = CLLocationCoordinate2D(latitude: park1.lat, longitude: park1.long)
       // mapView.addAnnotation(park1Annotation)
        
        //creating temp park annotation using the park class
        //let park2 = Park(name: "Calahan Park", street: "Locust Street", town: "Burlington", state: "VT", lat: 44.46229, long: -73.21267)
        //let park2Annotation = MKPointAnnotation()
        //park2Annotation.title = park2.name
        //park2Annotation.coordinate = CLLocationCoordinate2D(latitude: park2.lat, longitude: park2.long)
        //mapView.addAnnotation(park2Annotation)
        
        //creating temp park annotation using park class
        //let park3 = Park(name: "North Beach Park", street: "Institute Road", town: "Burlington", state: "VT", lat: 44.49261, long: -73.24042)
        //let park3Annotation = MKPointAnnotation()
        //park3Annotation.title = park3.name
        //park3Annotation.subtitle = "Test"
        //park3Annotation.coordinate = CLLocationCoordinate2D(latitude: park3.lat, longitude: park3.long)
        //mapView.addAnnotation(park3Annotation)
        
        //creating a temp park annotation using park class
        //let park4 = Park(name: "Battery Park", street: "Park Street", town: "Burlington", state: "VT", lat: 44.48142, long: -73.21992)
        //let park4Annotation = MKPointAnnotation()
        //park4Annotation.title = park4.name
        //park4Annotation.coordinate = CLLocationCoordinate2D(latitude: park4.lat, longitude: park4.long)
        //mapView.addAnnotation(park4Annotation)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else {
            return nil
        }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            //I have no idea why this isn't working
            annotationView?.canShowCallout = true
            annotationView?.detailCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
        } else {
            annotationView?.annotation = annotation
        }
        
    
        return annotationView
    }
    
     func mapView(_ mapView: MKMapView, annotationsView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("Callout Button Pressed")
    }
    
    //changes map type based on segmented control selection
    @objc func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
}
