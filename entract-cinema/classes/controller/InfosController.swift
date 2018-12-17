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
    
    @IBOutlet weak var btnPhone: UIImageView!
    
    @IBOutlet weak var btnWebsite: UIImageView!
    
    @IBOutlet weak var btnFacebook: UIImageView!
    
    @IBOutlet weak var lblAdresse: UILabel!
    
    @IBOutlet weak var lblReference: UILabel!
    
    let regionRadius: CLLocationDistance = 1000
    
    // set initial location in Honolulu
    let initialLocation = CLLocation(latitude: 43.7700499, longitude: 1.2948405)
    
    let infoFilm = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : Tools.shared.manageTheme()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        centerMapOnLocation(location: initialLocation)
        
        let artwork = Artwork(title: "cinema".localized(),
                              locationName: "cinema".localized(),
                              discipline: "movie".localized(),
                              coordinate: CLLocationCoordinate2D(latitude: 43.7700499, longitude: 1.2948405))
        mapView.addAnnotation(artwork)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onClicTelephone(sender:)))
        btnPhone.isUserInteractionEnabled = true
        btnPhone.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.onClicFacebook(sender:)))
        btnFacebook.isUserInteractionEnabled = true
        btnFacebook.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.onClicWebsite(sender:)))
        btnWebsite.isUserInteractionEnabled = true
        btnWebsite.addGestureRecognizer(tap3)
        
        let content = NSMutableAttributedString()
        content.append(NSMutableAttributedString(string: "salleClassee".localized(), attributes:infoFilm))
        content.append(NSMutableAttributedString(string: "artEssai".localized(), attributes:infoFilm))
        content.append(Tools.shared.attributedTextWithImage(imageName: Constants.artEssai))
        content.append(NSMutableAttributedString(string: "jeunePublic".localized(), attributes:infoFilm))
        lblReference.attributedText = content
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = Tools.shared.manageWindowTheme()
        self.lblAdresse.textColor = Tools.shared.manageTheme()
        self.lblReference.textColor = Tools.shared.manageTheme()
    }
    
    @objc func onClicFacebook(sender:UITapGestureRecognizer) {
        
        var url = URL(string:"fbProfile".localized())!
        if !UIApplication.shared.canOpenURL(url)  {
            url = URL(string: "fbLong".localized())!
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @objc func onClicWebsite(sender:UITapGestureRecognizer) {
        let url = URL(string: "urlSite".localized())!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @objc func onClicTelephone(sender:UITapGestureRecognizer) {
        let url = URL(string: "tel".localized())!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion.init(center: location.coordinate,
                                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
