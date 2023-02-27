//
//  LoaderViewController.swift
//  CheckRoom
//
//  Created by mac on 27.02.2023.
//

import UIKit

class LoaderViewController: ViewController {
    
    private let logoImageView = UIImageView()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animate()
    }
    
    override func setup() {
        super.setup()
        
        view.backgroundColor = .white
        
        logoImageView.image = Icons.logo
        logoImageView.contentMode = .scaleAspectFit
        
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
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoImageView)
        view.addSubview(progressView)
        view.addSubview(loadingLabel)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor,
                                                  constant: -64),
            logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor,
                                                 multiplier: 0.5),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
            
            
            loadingLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor,
                                              constant: 20),
            loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func animate() {
        progressView.progress = 0

        let displayLink = CADisplayLink(target: self, selector: #selector(updateProgress(_:)))
        displayLink.add(to: .main, forMode: .default)
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
