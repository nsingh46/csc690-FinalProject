//
//  CustomerViewController.swift
//  Cruz
//
//  Created by charan singh on 12/9/19.
//  Copyright © 2019 Navneet Singh. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth

class CustomerViewController: UIViewController, CLLocationManagerDelegate{

    @IBOutlet weak var CustomerMap: MKMapView!
    
    @IBOutlet weak var orderDelivery: UIButton!
    
    @IBOutlet weak var WeightTEXT: UITextField!
    
    @IBOutlet weak var locationTEXT: UITextField!
    
    var locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    var deliveryInitiated = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
         
        //safety check, if delivery has already been order, will keep that set up and wont allow for a new order.
        if let  email = Auth.auth().currentUser?.email
        {
            Database.database().reference().child("DeliveryInvoice").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: { (deletion) in
                self.deliveryInitiated = true
                self.orderDelivery.setTitle("Cancel Delivery", for: .normal)
                    
                //lets order new deliveries
                Database.database().reference().child("DeliveryInvoice").removeAllObservers()
            })
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func GetPrice(_ sender: Any)
    {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let coordinate = manager.location?.coordinate
        {       //setup the map to find location
                let centerCoor =  CLLocationCoordinate2D(latitude : coordinate.latitude, longitude : coordinate.longitude)
                userLocation = centerCoor
                let regionCoor =  MKCoordinateRegion(center: centerCoor, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                CustomerMap.setRegion(regionCoor, animated: true)
            
                    //stops extra location pins from coming
                    CustomerMap.removeAnnotations(CustomerMap.annotations)
            
                     //finds your specific location with pin
                    let notate = MKPointAnnotation()
                    notate.coordinate = centerCoor
                    notate.title = "Your Location"
                    CustomerMap.addAnnotation(notate)
            
            
            }
    }
    //log out of account and back to main screen
    @IBAction func LogoutActive(_ sender: Any)
    {
        try? Auth.auth().signOut()
        navigationController?.dismiss(animated: true, completion: nil)
    }
    //repsoniblies order raleted actions
    @IBAction func orderDeliveryAction(_ sender: Any)
    {
    
    
       if let  email = Auth.auth().currentUser?.email
        {
            if deliveryInitiated
            {
                    deliveryInitiated = false
                
                    //changes button
                    orderDelivery.setTitle("Order Delivery", for: .normal)
                
                    //deletes the order delivery
                    Database.database().reference().child("DeliveryInvoice").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded) { (deletion) in
                    deletion.ref.removeValue()
                        
                    //lets order new deliveries
                    Database.database().reference().child("DeliveryInvoice").removeAllObservers()
                }
            }
            else
            {   //create a delivery and store in Firebase
                let deliveryInvoice : [String:Any] = ["email":email, "latitude":userLocation.latitude, "longitude":userLocation.longitude]
                Database.database().reference().child("DeliveryInvoice").childByAutoId().setValue(deliveryInvoice)
                
                    //change button to "Delete Order"
                    deliveryInitiated = true
                    orderDelivery.setTitle("Deleted Order", for: .normal)
                
            }
             
            
                
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
