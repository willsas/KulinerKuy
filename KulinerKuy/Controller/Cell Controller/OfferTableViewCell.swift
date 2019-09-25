//
//  OfferTableViewCell.swift
//  KulinerKuy
//
//  Created by Willa on 18/09/19.
//  Copyright © 2019 WillaSaskara. All rights reserved.
//

import UIKit

class OfferTableViewCell: UITableViewCell {
    
    var delegate: OfferTableViewCellDelegate?
    
    
    @IBOutlet var kuyButtonOutlet: UIButton!
    
    @IBOutlet var tittleOutlet: UILabel!
    
    @IBOutlet var userNameOutlet: UILabel!
    
    @IBOutlet var priceOutlet: UILabel!
    
    @IBOutlet var peopleLeftOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    @IBAction func kuyButtonTapped(_ sender: Any) {
       delegate?.kuyButtonTapped()
        
    }
    
    
    
}


protocol OfferTableViewCellDelegate {
    func kuyButtonTapped()
}
