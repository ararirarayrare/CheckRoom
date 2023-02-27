//
//  ViewController.swift
//  CheckRoom
//
//  Created by mac on 09.01.2023.
//

import UIKit

class MainViewController: ViewController {
    
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        //        scrollView.delegate = self
        return scrollView
    }()
    
    private let containerView = UIView()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Icons.logo
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let headerView = MainHeaderView()
    
    private var outfitsView: MainOutfitsView? {
        didSet {
            oldValue?.removeFromSuperview()
            
            guard let outfitsView = self.outfitsView else {
                return
            }
            
            outfitsView.translatesAutoresizingMaskIntoConstraints = false
            
            containerView.addSubview(outfitsView)
            
            NSLayoutConstraint.activate([
                outfitsView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
                outfitsView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
                outfitsView.topAnchor.constraint(equalTo: headerView.bottomAnchor,
                                                 constant: 24),
                outfitsView.heightAnchor.constraint(equalTo: outfitsView.widthAnchor,
                                                    multiplier: 0.7)
            ])
        }
    }
    
    let coordinator: MainCoordinator
    
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let savedOutfits = DataManager.shared.savedOutfits() {
            
            print("SavED :",savedOutfits.count)
            
            let outfitsView = MainOutfitsView()
            
            if let today = savedOutfits.first(where: { Date() > $0.key })?.value {
                outfitsView.outfitViewToday = today.createPreview()
            }
            
            if let tomorrow = savedOutfits.first(where: { $0.key > Date() })?.value {
                outfitsView.outfitViewTomorrow = tomorrow.createPreview()
            }
            
            self.outfitsView = outfitsView
        }
    }

    override func setup() {
        super.setup()
        
        navigationItem.largeTitleDisplayMode = .never
        
        headerView.coordinator = self.coordinator
        
    }
    
    override func layout() {
        super.layout()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        containerView.addSubview(logoImageView)
        containerView.addSubview(headerView)
        
        let contentGuide = scrollView.contentLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
            containerView.leadingAnchor.constraint(equalTo: contentGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentGuide.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentGuide.bottomAnchor),
            containerView.topAnchor.constraint(equalTo: contentGuide.topAnchor),
            
            
            logoImageView.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor,
                                               constant: 24),
            logoImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor,
                                                  multiplier: 1.12),
            
            
            headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                constant: 20),
            headerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                 constant: -20),
            headerView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor,
                                            constant: 32)
        ])
        
        let contentViewCenterY = containerView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        contentViewCenterY.priority = .defaultLow
        
        let contentViewHeight = containerView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor)
        contentViewHeight.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentViewCenterY,
            contentViewHeight
        ])
        
    }
    
}
