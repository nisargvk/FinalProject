//
//  Directions.swift
//  meetups
//
//  Created by Nisarg on 2020-12-07.

import SwiftUI
import MapKit

struct DirectionsView: View {
    @ObservedObject var locationManager = LocationManager()
    @State private var meetingCoordinates = CLLocationCoordinate2D()
    
    var location: String = ""
    var lat: Double = 0.0
    var lng: Double = 0.0
    
    var body: some View {
        VStack{
            MapView(location: self.location, coordinates: self.meetingCoordinates)
        }
        .onAppear(){
            if (self.lat != 0 && self.lng != 0){
                self.meetingCoordinates = CLLocationCoordinate2D(latitude: self.lat, longitude: self.lng)
            }
        }
    }
}

struct DirectionsView_Previews: PreviewProvider {
    static var previews: some View {
        DirectionsView()
    }
}

struct MapView : UIViewRepresentable{
//    typealias UIViewType = <#type#>
    
    @ObservedObject var locationManager = LocationManager()
    private var location: String = ""
    private var meetingCoordinates: CLLocationCoordinate2D
    private let regionRadius: CLLocationDistance = 300
    
    init(location: String, coordinates: CLLocationCoordinate2D){
        self.location = location
        self.meetingCoordinates = coordinates
    }
    
    func makeCoordinator() -> MapView.Coordinator {
        return MapView.Coordinator()
    }
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let map = MKMapView()
        
        map.mapType = MKMapType.standard
        map.showsUserLocation = true
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        map.isUserInteractionEnabled = true
        
        let sourceCoordinates = CLLocationCoordinate2D(latitude: 43.642567, longitude: -79.387054)
        //let sourceCoordinates = CLLocationCoordinate2D(latitude: self.locationManager.lat, longitude: self.locationManager.lng)
        let region = MKCoordinateRegion(center: sourceCoordinates, latitudinalMeters: regionRadius * 4.0, longitudinalMeters: regionRadius * 4.0)
        
        //locationManager.addPinToMapView(mapView: map, coordinates: sourceCoordinates, title: "You're Here")
        
        map.setRegion(region, animated: true)
        //map.delegate = context.coordinator
        
        return map
    }
    
        func createRandomLocation(nwCoordinate: CLLocationCoordinate2D, seCoordinate: CLLocationCoordinate2D) -> [CLLocationCoordinate2D]
        {
           return (0 ... 30).enumerated().map { _ in
                let latitude = randomFloatBetween(nwCoordinate.latitude, andBig: seCoordinate.latitude)
                let longitude = randomFloatBetween(nwCoordinate.longitude, andBig: seCoordinate.longitude)
                return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            }
        }

        func randomFloatBetween(_ smallNumber: Double, andBig bigNumber: Double) -> Double {
            let diff: Double = bigNumber - smallNumber
            return ((Double(arc4random() % (UInt32(RAND_MAX) + 1)) / Double(RAND_MAX)) * diff) + smallNumber
        }
        
        func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
            let sourceCoordinates = CLLocationCoordinate2D(latitude: 43.642567, longitude: -79.387054)
            let region = MKCoordinateRegion(center: sourceCoordinates, latitudinalMeters: regionRadius * 4.0, longitudinalMeters: regionRadius * 4.0)
            
            uiView.setRegion(region, animated: true)
        }
        
        
        
        }
    
    
    
    


