//
//  MainOutfitsView.swift
//  CheckRoom
//
//  Created by mac on 26.02.2023.
//

import UIKit

class MainOutfitsView: UIView {
    
    private var todayLabel: UILabel?
    private var tomorrowLabel: UILabel?
    
    var outfitViewToday: OutfitView? {
        didSet {
            
            guard let view = outfitViewToday else {
                oldValue?.removeFromSuperview()
                return
            }
            
            setupOutfitView(view)
            let label = createLabel(text: "Outfit for today :")
            
            view.translatesAutoresizingMaskIntoConstraints = false
            label.translatesAutoresizingMaskIntoConstraints = false
            
            addSubview(view)
            addSubview(label)
            
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: leadingAnchor),
                label.trailingAnchor.constraint(equalTo: centerXAnchor,
                                                constant: -8),
                label.topAnchor.constraint(equalTo: topAnchor),
                
                
                view.leadingAnchor.constraint(equalTo: leadingAnchor),
                view.trailingAnchor.constraint(equalTo: centerXAnchor,
                                               constant: -8),
                view.topAnchor.constraint(equalTo: label.bottomAnchor,
                                          constant: 4),
                view.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
            
        }
    }
    
    var outfitViewTomorrow: OutfitView? {
        didSet {
            
            guard let view = outfitViewTomorrow else {
                oldValue?.removeFromSuperview()
                return
            }
            
            setupOutfitView(view)
            let label = createLabel(text: "Outfit for tomorrow :")
            
            
            view.translatesAutoresizingMaskIntoConstraints = false
            label.translatesAutoresizingMaskIntoConstraints = false
            
            addSubview(view)
            addSubview(label)
            
            NSLayoutConstraint.activate([
                view.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
            
            if let outfitViewToday = self.outfitViewToday {
                
                NSLayoutConstraint.activate([
                    label.leadingAnchor.constraint(equalTo: outfitViewToday.trailingAnchor,
                                                   constant: 16),
                    label.trailingAnchor.constraint(equalTo: trailingAnchor),
                    label.topAnchor.constraint(equalTo: topAnchor),
                    
                    
                    view.leadingAnchor.constraint(equalTo: outfitViewToday.trailingAnchor,
                                                  constant: 16),
                    view.trailingAnchor.constraint(equalTo: trailingAnchor),
                    view.topAnchor.constraint(equalTo: label.bottomAnchor,
                                              constant: 4)
                ])
                
            } else {
                
                NSLayoutConstraint.activate([
                    label.leadingAnchor.constraint(equalTo: leadingAnchor),
                    label.trailingAnchor.constraint(equalTo: centerXAnchor,
                                                    constant: -8),
                    label.topAnchor.constraint(equalTo: topAnchor),
                    
                    
                    view.leadingAnchor.constraint(equalTo: leadingAnchor),
                    view.trailingAnchor.constraint(equalTo: centerXAnchor,
                                                  constant: -8),
                    view.topAnchor.constraint(equalTo: label.bottomAnchor,
                                              constant: 4)
                ])
                
            }
            
        }
    }
    
    private func setupOutfitView(_ view: OutfitView) {
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowRadius = 12
        view.layer.cornerRadius = 12
    }
    
    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .left
        label.text = text
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }
}
