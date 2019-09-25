//
//  OfferDataBaseModel.swift
//  KulinerKuy
//
//  Created by Willa on 18/09/19.
//  Copyright © 2019 WillaSaskara. All rights reserved.
//

import Foundation
import CloudKit

class OfferDataBaseModel{
    
    static let instance = OfferDataBaseModel()
    
    let privateDatabase = CKContainer.default().privateCloudDatabase
    let publicDatabase = CKContainer.default().publicCloudDatabase
    
    let recordType = "Offering"
    
    var delegate: OfferDatabaseModelDelegate?
    
    var publicRecordResult = [CKRecord]()
    var privateRecordResult = [CKRecord]()
    var userName = [CKRecord]()
    
    func saveData(offerTitle: String, price: String, people: Int, isPrivate: Bool, name: String ){
        let titleForKey = "title"
        let priceForKey = "price"
        let peopleForKey = "people"
        let nameForKey = "name"
        let newValue = CKRecord(recordType: recordType)
        newValue.setValue(offerTitle, forKey: titleForKey)
        newValue.setValue(price, forKey: priceForKey)
        newValue.setValue(people, forKey: peopleForKey)
        newValue.setValue(name, forKey: nameForKey)
        
        if isPrivate{
            privateDatabase.save(newValue) { (record, error) in
                if record != nil{
                    print("SUCCESS : SAVE TO THE PRIVATE CLOUD")
                }else{
                    print("ERROR : SOMETHING WRONG WITH SAVE PRIVATE RECORD \(error!.localizedDescription)")
                }
            }
        }else{
            publicDatabase.save(newValue) { (record, error) in
                if record != nil{
                    print("SUCCESS : SAVE TO THE PUBLIC CLOUD")
                }else{
                    print("ERROR : SOMETHING WRONG WITH SAVE PUBLIC RECORD \(error!.localizedDescription)")
                }
            }
        }
    }
    
    
    func fetchData(isPrivate : Bool){
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
        query.sortDescriptors = [sortDescriptor]
        
        if isPrivate{
            privateDatabase.perform(query, inZoneWith: nil) { (recordArray, error) in
                if error == nil{
                    guard let result = recordArray else { return }
                    self.privateRecordResult = result
                    self.delegate?.isDoneFetching(isDone: true)
                }else{
                    print("ERROR : FETCH PRIVATE DATA \(error!.localizedDescription)")
                }
            }
            
        }else{
            publicDatabase.perform(query, inZoneWith: nil) { (recordArray, error) in
                if error == nil{
                    guard let result = recordArray else { return }
                    self.publicRecordResult = result
                    self.delegate?.isDoneFetching(isDone: true)
                }else{
                    print("ERROR : FETCH PUBLIC DATA \(error!.localizedDescription)")
                }
            }
        }
    }
}

protocol OfferDatabaseModelDelegate {
    func isDoneFetching(isDone: Bool)
}

