//
//  LoaderViewController.swift
//  CheckRoom
//
//  Created by mac on 27.02.2023.
//

import UIKit

class LoaderViewController: ViewController {
    
    private let logoTitleImageView = UIImageView()
    private let hangerImageView = UIImageView()
    
    private let progressView = UIProgressView()
    private let loadingLabel = UILabel()
    
    private let completion: () -> Void
    
    init(completion: @escaping () -> Void) {
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        hangerImageView.frame.size = CGSize(width: logoTitleImageView.bounds.width * 0.8264,
                                            height: logoTitleImageView.bounds.height * 1.8575)
        
        hangerImageView.frame.origin.x = logoTitleImageView.frame.origin.x + (logoTitleImageView.bounds
            .width * 0.1449)
        hangerImageView.center.y = logoTitleImageView.frame.origin.y + (logoTitleImageView.bounds.height * 0.815)
        
        print(logoTitleImageView.frame.origin.y)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animate()
    }
    
    override func setup() {
        super.setup()
        
        view.backgroundColor = .white
        
        logoTitleImageView.image = Icons.logoTitle
        logoTitleImageView.contentMode = .scaleAspectFit
        
        hangerImageView.image = Icons.hanger
        hangerImageView.contentMode = .scaleAspectFit
        
        progressView.trackTintColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
        progressView.progressTintColor = .black
        progressView.progress = 0.35
        
        loadingLabel.font = .poppinsFont(ofSize: 16)
        loadingLabel.textColor = .black
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading"
    }
    
    override func layout() {
        super.layout()
        
        progressView.frame.size = CGSize(width: view.bounds.width - 64,
                                         height: 3)
        progressView.center.x = view.center.x
        progressView.frame.origin.y = view.bounds.height - 180
        
        logoTitleImageView.translatesAutoresizingMaskIntoConstraints = false
//        hangerImageView.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoTitleImageView)
        view.addSubview(hangerImageView)
        view.addSubview(progressView)
        view.addSubview(loadingLabel)
        
        
        NSLayoutConstraint.activate([
            logoTitleImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoTitleImageView.topAnchor.constraint(equalTo: view.centerYAnchor,
                                                    constant: -160),
            logoTitleImageView.widthAnchor.constraint(equalTo: view.widthAnchor,
                                                 multiplier: 0.5),
            logoTitleImageView.heightAnchor.constraint(equalTo: logoTitleImageView.widthAnchor,
                                                       multiplier: 0.533),
            
            
            loadingLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor,
                                              constant: 20),
            loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func animate() {
        progressView.progress = 0

        let displayLink = CADisplayLink(target: self, selector: #selector(updateProgress(_:)))
        displayLink.add(to: .main, forMode: .default)
        
        let anim = CABasicAnimation(keyPath: "transform.rotation.z")
        anim.fromValue = -0.25
        anim.toValue = 0.25
        anim.duration = 0.5
        anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        anim.repeatCount = .infinity
        anim.autoreverses = true
        
        self.hangerImageView.layer.add(anim, forKey: "rotationAnimation")
    }
    
    @objc
    private func updateProgress(_ displayLink: CADisplayLink) {
        let step = 0.015 - (progressView.progress / 80)
        
        progressView.progress += step
        
        if progressView.progress > 0.99 {
            progressView.progress = 1.0
            displayLink.invalidate()
            completion()
        }
    }
    
}
