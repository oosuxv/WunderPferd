//
//  BestButton.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 15.04.2022.
//

import UIKit

class BrightButton: UIButton {
    
    private let defaultColor = UIColor.init(named: "ButtonBlue")
    private let highlightedColor = UIColor.orange

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 0
        self.layer.masksToBounds = true
    }
    
    override open var isHighlighted: Bool {
        didSet {
            self.backgroundColor = isHighlighted ? highlightedColor : defaultColor
        }
    }

    func setup() {
        self.backgroundColor = defaultColor;
    }
}
