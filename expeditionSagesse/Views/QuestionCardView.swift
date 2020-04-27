//
//  QuestionCardView.swift
//  expeditionSagesse
//
//  Created by Karim Lakhssassi on 27/04/2020.
//  Copyright © 2020 ephiscience. All rights reserved.
//

import Foundation
import UIKit

public class QuestionCardView: UIView {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var questionLabelView: UIView!
    @IBOutlet weak var questionLabel: UILabel!

    public func configure(question: String) {
        if let cardsBackgroundImage = UIImage(named: "cards-background") {
            backgroundView.backgroundColor = UIColor(patternImage: cardsBackgroundImage)
        }

        backgroundView.layer.borderWidth = 2
        backgroundView.layer.borderColor = Helper.UIColorFromHex(0x02AAB0).cgColor

        questionLabelView.layer.borderWidth = 2
        questionLabelView.layer.borderColor = Helper.UIColorFromHex(0x02AAB0).cgColor

        questionLabel.text = question
    }
}
