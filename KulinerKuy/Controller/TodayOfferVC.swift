//
//  ViewController.swift
//  KulinerKuy
//
//  Created by Willa on 18/09/19.
//  Copyright © 2019 WillaSaskara. All rights reserved.
//

import UIKit
import CloudKit
import LocalAuthentication
import CoreLocation

class TodayOfferVC: UIViewController {
    
    @IBOutlet var yoursButtonOutlet: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    
    //Cloudkit
    let DatabaseInstance = OfferDataBaseModel.instance
    var record = [CKRecord]()
    
    //BiometricAuth
    var context = LAContext()
    enum AuthenticationState{
        case loggedin, loggedout
    }
    var state = AuthenticationState.loggedout{
        didSet{ print("SUCCESS: FACE ID IS SUCCESS BEING EXECUTED") }
    }
    
    //Corelocation
    let locationManager = CLLocationManager()
    var isPlacingImage = false
    
    //popup
    var popup = UIView()
    var blackBackground = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupRefresherControl()
        fetchingData()
        setupLocalAuth()
        setupCoreLocatoin()
        blackBackground = addBlackBackground()
        popup = addPopup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchingData()
        addImageFarFromAcademy()
        fetchingData()
    }
    
    
    
    
    // MARK: - Setup Func
    
    func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9490196078, blue: 0.937254902, alpha: 1)
    }
    func setupRefresherControl(){
        let refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(fetchingData), for: .valueChanged)
        self.tableView.refreshControl = refresher
    }
    @objc func fetchingData(){
        DatabaseInstance.fetchData(isPrivate: false) { (arrayOfCKRecord) in
            self.record = arrayOfCKRecord
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
    func setupLocalAuth(){
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        state = .loggedout
    }
    func biometricAuth(){
        if state == .loggedin{
            state = .loggedout
        }else{
            self.context = LAContext()
            context.localizedCancelTitle = "Pake Password aja"
            
            var error: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                
                let reason = "Log in to your account"
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in
                    if success {
                        // Move to the main thread because a state update triggers UI changes.
                        DispatchQueue.main.async { [unowned self] in
                            self.state = .loggedin
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                self.didBiometricsSuccessedAlert()
                                //animate UIVIEW
                                self.popupAppear()
                            })
                        }
                    }else{
                        print(error?.localizedDescription ?? "Failed to authenticate")
                    }
                }
            }else{
                print(error?.localizedDescription ?? "Can't evaluate policy")
            }
        }
    }
    
    func setupCoreLocatoin(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
    }
    
    func startScanning(){
        let uuid = UUID(uuidString: "CB10023F-A318-3394-4199-A8730C7C1AEC")!
        let identityConstrait = CLBeaconIdentityConstraint(uuid: uuid, major: 222, minor: 155)
        let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: identityConstrait, identifier: "Hacker")
        
        // for ios below 13.0 use this CLBeaconRegion :
        // let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 222, minor: 155, identifier:    "Hacker")
        
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(satisfying: identityConstrait)
        
        // for ios below 13.0 use this instead of satisfying asu :
        //locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    func updateDistance(distance: CLProximity){
            switch distance {
            case .unknown:
                self.view.backgroundColor = UIColor.red
//                DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
//                    self.tableView.isHidden = true
//                    self.yoursButtonOutlet.isEnabled = false
//                    self.navigationItem.title = "You are far from Academy"
//                    print("unknown dipanggil")
//                })
               
            case .far:
                self.view.backgroundColor = UIColor.gray
//                tableView.isHidden = true
//                self.yoursButtonOutlet.isEnabled = false
//                navigationItem.title = "You are far from Academy"
                
            case .near:
                self.view.backgroundColor = UIColor.white
                self.closeToAcademy()
            case .immediate:
                self.view.backgroundColor = UIColor.white
                self.closeToAcademy()
            default: break
               // print("SOMETHING WRONG WITH \(#function): \(fatalError())")
        }
    }
    
    func farFromAcademy(){
        print(#function)
        let newImage = UIImage(named: "farFromAcademy")
        let imageView = UIImageView(image: newImage!)
        imageView.frame = CGRect(x: self.view.frame.width / 2 - 150, y: self.view.frame.height / 2 - 150, width: 300, height: 300)
        self.view.insertSubview(imageView, at: 0)
        
    }
    func closeToAcademy(){
        print(#function)
        self.tableView.isHidden = false
        self.yoursButtonOutlet.isEnabled = true
        navigationItem.title = "Today Offers"
    }

    func didBiometricsSuccessedAlert(){
        let alert = UIAlertController(title: "You Have Successfully join", message: nil, preferredStyle: .alert)
        let actionDone = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(actionDone)
        self.present(alert, animated: true)
    }
    
    func addImageFarFromAcademy(){
        if self.isPlacingImage == false{
            self.farFromAcademy()
            print("UNKNOWN FUNCTION DIPANGIL")
            self.isPlacingImage = true
        }
    }
    
    func addPopup() -> UIView{
        let view = UIView()
        view.backgroundColor = .orange
        view.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.height / 2)
        view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.maxY, width: self.view.frame.width, height: self.view.frame.height / 2)
        
        self.navigationController?.navigationBar.addSubview(view)
        //self.view.addSubview(view)
        return view
    }
    
    func addBlackBackground() -> UIView {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0.5
        backgroundView.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y - 45, width: self.view.frame.width, height: self.view.frame.height)
        backgroundView.isHidden = true
        self.navigationController?.navigationBar.addSubview(backgroundView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopup))
        self.view.addGestureRecognizer(tapGesture)
        return backgroundView
    }
    
    func popupAppear(){
        self.blackBackground.isHidden = false
        self.tableView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.2) {
            self.popup.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.maxY / 2, width: self.view.frame.width, height: self.view.frame.height / 2)
        }
    }
    
    @objc func dismissPopup(){
        
        UIView.animate(withDuration: 0.3) {
            self.blackBackground.isHidden = true
            self.popup.frame.origin.y = self.view.frame.maxY
        }
        self.tableView.isUserInteractionEnabled = true
    }
}




// MARK: - Extension and Delegate
extension TodayOfferVC: OfferTableViewCellDelegate{
    func kuyButtonTapped() {
        biometricAuth()
    }
}

extension TodayOfferVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return record.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let nib = UINib(nibName: "OfferTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "offerTableViewCell")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "offerTableViewCell", for: indexPath) as! OfferTableViewCell
        
        cell.delegate = self
        cell.tittleOutlet.text = record[indexPath.row].value(forKey: "title") as? String
        cell.priceOutlet.text = "Rp. \(record[indexPath.row].value(forKey: "price") as! String)"
        cell.peopleLeftOutlet.text = String(record[indexPath.row].value(forKey: "people") as! Int) + " left"
        
        cell.userNameOutlet.text = record[indexPath.row].value(forKey: "name") as? String
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("ROW AT \(indexPath.row)")
    }
}


extension TodayOfferVC: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse{
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self){
                if CLLocationManager.isRangingAvailable(){
                    startScanning()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            updateDistance(distance: beacons[0].proximity)
        }else{
            updateDistance(distance: .unknown)
            
        }
    }
}


extension TodayOfferVC: UIPopoverPresentationControllerDelegate{
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}
