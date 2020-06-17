//
//  CriteriaCollectionViewCell.swift
//  expeditionSagesse
//
//  Created by Omar Mahboubi on 04/05/2020.
//  Copyright © 2020 ephiscience. All rights reserved.
//

import Foundation
import UIKit

class CriteriaCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var criteriaLabel: UILabel!
    @IBOutlet weak var auditorOneImageView: UIImageView!
    @IBOutlet weak var auditorTwoImageView: UIImageView!
    var criteria: PartyCriteria? = nil
    
    let auditorImageOnName = "noun_Headphones_2853339_ Pascal Heß_DE"
     let auditorImageOffName = "gray_Headphones_2853339"
    var validationsByAuditors: Int = 0
    
    func configure(withCriteria criteria: PartyCriteria, shouldDisplayAuditorsImages: Bool = true){
        self.criteria = criteria
        self.criteriaLabel.text = criteria.title
        if shouldDisplayAuditorsImages == true {
            auditorOneImageView.image = UIImage(named: auditorImageOffName)
            auditorTwoImageView.image = UIImage(named: auditorImageOffName)
            if criteria.validatedAuditors == 1 {
                auditorOneImageView.image = UIImage(named: auditorImageOnName)
            }
        auditorOneImageView.isHidden = false
        auditorTwoImageView.isHidden = false
        } else {
            auditorOneImageView.isHidden = true
            auditorTwoImageView.isHidden = true
        }
    }
    
    func didAuditorValidated(withCriteria criteria: PartyCriteria) {
        auditorOneImageView.image = UIImage(named: auditorImageOnName)
        if criteria.validatedAuditors > 1 {
            auditorTwoImageView.image = UIImage(named: auditorImageOnName)
        }
    }
    
}
