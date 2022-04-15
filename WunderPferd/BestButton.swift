//
//  BestButton.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 15.04.2022.
//

import UIKit

class BestButton: UIButton {

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
        self.layer.cornerRadius = 25
    }
    
    override open var isHighlighted: Bool {
        didSet {
            self.backgroundColor = isHighlighted ? .yellow : .blue
        }
    }

    func setup() {
        self.backgroundColor = .blue;
    }
}
