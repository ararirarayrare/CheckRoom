//
//  COPeviewView.swift
//  CheckRoom
//
//  Created by mac on 08.02.2023.
//

import UIKit

class COPeviewView: UIView {
    
    let topImageView = UIImageView()
    let bottomImageView = UIImageView()
    let shoesImageView = UIImageView()
    
    init() {
        super.init(frame: .zero)
        
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .white
        
        layer.cornerRadius = 20
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 20
        layer.shadowOpacity = 0.2
        layer.shadowOffset.height = 2
    
        topImageView.contentMode = .scaleAspectFit
        bottomImageView.contentMode = .scaleAspectFit
        shoesImageView.contentMode = .scaleAspectFit
    }
    
    private func layout() {
        topImageView.translatesAutoresizingMaskIntoConstraints = false
        bottomImageView.translatesAutoresizingMaskIntoConstraints = false
        shoesImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(topImageView)
        addSubview(bottomImageView)
        addSubview(shoesImageView)
        
        NSLayoutConstraint.activate([
            topImageView.topAnchor.constraint(equalTo: topAnchor,
                                              constant: 4),
            topImageView.bottomAnchor.constraint(equalTo: centerYAnchor,
                                                 constant: -12),
            topImageView.widthAnchor.constraint(equalTo: topImageView.heightAnchor),
            topImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            
            bottomImageView.topAnchor.constraint(equalTo: topImageView.bottomAnchor,
                                                 constant: 4),
            bottomImageView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                    constant: -4),
            bottomImageView.widthAnchor.constraint(equalTo: bottomImageView.heightAnchor),
            bottomImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            
            shoesImageView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                     constant: -24),
            shoesImageView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                   constant: -24),
            shoesImageView.widthAnchor.constraint(equalTo: widthAnchor,
                                                  multiplier: 0.3),
            shoesImageView.heightAnchor.constraint(equalTo: shoesImageView.widthAnchor)
        ])
    }
    
}
