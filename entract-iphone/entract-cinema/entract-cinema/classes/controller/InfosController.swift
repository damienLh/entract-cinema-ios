//
//  InfosController.swift
//  entract-cinema
//
//  Created by Damien Lheuillier on 29/07/2018.
//  Copyright © 2018 Damien Lheuillier. All rights reserved.
//

import MapKit

class InfosController : UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    
    // set initial location in Honolulu
    let initialLocation = CLLocation(latitude: 43.7700499, longitude: 1.2948405)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        centerMapOnLocation(location: initialLocation)
        
        let artwork = Artwork(title: "Cinéma L'entract",
                              locationName: "Cinéma L'entract",
                              discipline: "cinéma",
                              coordinate: CLLocationCoordinate2D(latitude: 43.7700499, longitude: 1.2948405))
        mapView.addAnnotation(artwork)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Artwork else { return nil }
        let identifier = "marker"
        var view: MKAnnotationView
        
        if #available(iOS 11.0, *) {
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKMarkerAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
        } else {
            if let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequedView.annotation = annotation
                view = dequedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }
        }

        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Artwork
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}
