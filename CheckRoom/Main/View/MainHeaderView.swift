//
//  MainHeaderView.swift
//  CheckRoom
//
//  Created by mac on 09.01.2023.
//

import UIKit

class MainHeaderView: UIView {
    
    private(set) var addItemView: MainHeaderViewButton!
    private(set) var createOutfitView: MainHeaderViewButton!
    private(set) var myOutfitsView: MainHeaderViewButton!
    private(set) var tomorrowOutfitView: MainHeaderViewButton!
    
    private let leftStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .equalCentering
        
        return stackView
    }()
    
    private let rightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .equalCentering
        
        return stackView
    }()
    
    var coordinator: MainCoordinator?
    
    init() {
        super.init(frame: .zero)
        
        setup()
        layout()
    }
    
    private func setup() {
        addItemView = MainHeaderViewButton(title: "Add an item",
                                               image: Icons.addItem) { [weak self] in
            
            self?.coordinator?.eventOccured(.addItem)
        }
        
        createOutfitView = MainHeaderViewButton(title: "Create outfit",
                                                    image: Icons.createOutfit) { [weak self] in
            
            self?.coordinator?.eventOccured(.createOutfit)
        }
        
        myOutfitsView = MainHeaderViewButton(title: "My outfits",
                                                 image: Icons.myOutfits) { [weak self] in
            
            self?.coordinator?.eventOccured(.myOutfits)
        }
        
        tomorrowOutfitView = MainHeaderViewButton(title: "Choose outfit for tomorrow",
                                                  image: Icons.tomorrowOutfit) { [weak self] in
            
            self?.coordinator?.eventOccured(.tomorrowOutfit)
        }
        
        let views: [MainHeaderViewButton] = [addItemView, createOutfitView, myOutfitsView, tomorrowOutfitView]
        
        views.enumerated().forEach { index, view in
            ((index + 1) % 2 == 0 ? rightStackView : leftStackView).addArrangedSubview(view)
        }
    }
    
    private func layout() {
        addSubview(leftStackView)
        addSubview(rightStackView)
            
        
        NSLayoutConstraint.activate([
            leftStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            leftStackView.topAnchor.constraint(equalTo: topAnchor),
            leftStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            leftStackView.widthAnchor.constraint(equalTo: widthAnchor,
                                                 multiplier: 0.475),
            
            
            rightStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            rightStackView.topAnchor.constraint(equalTo: topAnchor),
            rightStackView.widthAnchor.constraint(equalTo: widthAnchor,
                                                 multiplier: 0.475),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MainHeaderViewButton: UIView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.backgroundColor = .lightGray
        
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .poppinsFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 1.0)
        
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        
        return label
    }()
    
    private let handler: (() -> Void)?
    
    init(title: String, image: UIImage?, action: (() -> Void)?) {
        self.handler = action
        super.init(frame: .zero)
        
        titleLabel.text = title
        imageView.image = image
        
        setup()
        layout()
    }
    
    @objc
    private func tapped() {
        handler?()
    }
    
    private func setup() {
        backgroundColor = .white
        
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 12
        layer.cornerRadius = 12
        
        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(tapGesture)
    }
    
    private func layout() {
        addSubview(imageView)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor,
                                           constant: 24),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor,
                                             multiplier: 0.25),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                              constant: -80),
            
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor,
                                            constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                 constant: -24)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
