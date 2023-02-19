//
//  COLooksPreviewViewController.swift
//  CheckRoom
//
//  Created by mac on 14.01.2023.
//

import UIKit

class TOLooksPreviewViewController: ViewController {

//    private let containerView: UIView = {
//        let view = UIView()
//
//        view.backgroundColor = .white
//
//        view.layer.shadowColor = UIColor.black.cgColor
//        view.layer.shadowRadius = 8
//        view.layer.shadowOpacity = 0.2
//        view.layer.shadowOffset.height = 2
//
//        return view
//    }()
//
//    let imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//
//        imageView.layer.masksToBounds = true
//
////        imageView.layer.shadowColor = UIColor.black.cgColor
////        imageView.layer.shadowRadius = 8
////        imageView.layer.shadowOpacity = 0.4
////        imageView.layer.shadowOffset.height = 2
//
//        return imageView
//    }()
    
//    private let imageModel: TOLookImageModel
    
    private let outfitView: OutfitView
    
    private let originalRect: CGRect
    
    private let completion: () -> Void
    
    init(outfitView: OutfitView, originalRect: CGRect, completion: @escaping () -> Void) {
//        self.imageModel = imageModel
        
        self.outfitView = outfitView
        self.originalRect = originalRect
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        animatePresenting()
    }
    
    override func setup() {
        super.setup()
        
        
//        imageView.image = imageModel.image
//        imageView.layer.cornerRadius = imageModel.cornerRadius
//        containerView.layer.cornerRadius = imageModel.cornerRadius
//        containerView.frame.size = imageModel.size
//        containerView.frame.origin = imageModel.origin
        
        view.backgroundColor = .black.withAlphaComponent(0.1)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(hide))
        swipeGesture.direction = [.down, .up, .left, .right]
        view.addGestureRecognizer(swipeGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hide))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func layout() {
        super.layout()
        
        outfitView.frame = originalRect
        view.addSubview(outfitView)
        
        
//        NSLayoutConstraint.activate([
//            outfitView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            outfitView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            outfitView.topAnchor.constraint(equalTo: view.topAnchor),
//            outfitView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
        
//        view.addSubview(containerView)
//        containerView.addSubview(imageView)
//
//        NSLayoutConstraint.activate([
//            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
//            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
//            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
//            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
//        ])
    }
    
    @objc
    private func hide() {
        animateHiding()
    }
    
    func animatePresenting() {
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {

            let deltaWidth = self.outfitView.frame.size.width * 0.1
            let deltaHeight = self.outfitView.frame.size.height * 0.1

            self.outfitView.frame.origin.x += deltaWidth / 2
            self.outfitView.frame.origin.y += deltaHeight / 2

            self.outfitView.frame.size.width -= deltaWidth
            self.outfitView.frame.size.height -= deltaHeight
            
            self.view.layoutIfNeeded()

            
        } completion: { _ in
            
            UIView.animate(withDuration: 0.15) {

                self.view.backgroundColor = .black.withAlphaComponent(0.65)

                let width = self.view.bounds.width - 40
                let height = width * 1.25

                self.outfitView.frame.size = CGSize(width: width, height: height)

                self.outfitView.center = self.view.center

                self.view.layoutIfNeeded()

            }
            
        }
        
    }
    
    private func animateHiding() {
        
        UIView.animate(withDuration: 0.2) {
            
//            self.outfitView.frame.size = self.imageModel.size
//            self.outfitView.frame.origin = self.imageModel.origin
            self.outfitView.frame = self.originalRect
            self.view.backgroundColor = .clear
            
            self.view.layoutIfNeeded()

        } completion: { _ in
            self.completion()
            self.dismiss(animated: false)
        }
        
    }
    
}
