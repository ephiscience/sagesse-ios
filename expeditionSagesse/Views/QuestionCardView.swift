//
//  QuestionCardView.swift
//  expeditionSagesse
//
//  Created by Karim Lakhssassi on 27/04/2020.
//  Copyright © 2020 ephiscience. All rights reserved.
//

import Foundation
import UIKit

public protocol QuestionCardViewDelegate {
    func questionCardDidTap(identifier: Int)
}

public class QuestionCardView: UIView {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var questionLabelView: UIView!
    @IBOutlet weak var questionLabel: UILabel!

    private var delegate: QuestionCardViewDelegate?
    private var identifier: Int?

    public func configure(identifier: Int?, question: String, delegate: QuestionCardViewDelegate?) {
        self.identifier = identifier

        backgroundView.layer.borderWidth = 2
        backgroundView.layer.borderColor = Helper.UIColorFromHex(0x02AAB0).cgColor

        questionLabelView.layer.borderWidth = 2
        questionLabelView.layer.borderColor = Helper.UIColorFromHex(0x02AAB0).cgColor

        questionLabel.text = question

        self.delegate = delegate
    }

    @IBAction func viewDidTap() {
        if let identifier = self.identifier {
            self.delegate?.questionCardDidTap(identifier: identifier)
        }
    }

    public func setBorderColor(color: CGColor) {
        backgroundView.layer.borderColor = color
        questionLabelView.layer.borderColor = color
    }
}
