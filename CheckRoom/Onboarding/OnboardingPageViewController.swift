//
//  OnboardingViewController.swift
//  CheckRoom
//
//  Created by mac on 01.03.2023.
//

import UIKit

class OnboardingPageViewController: UIPageViewController {
    
    private var pages = [UIViewController]()
    
    private let nextButton = UIButton()
    private let skipButton = UIButton()
    private let pageControlLabel = UILabel()
    
    private let completion: () -> Void
    
    init(completion: @escaping () -> Void) {
        self.completion = completion
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        layout()
    }
    
    private func setup() {
        view.subviews.forEach { view in
            if let scrollView = view as? UIScrollView {
//                scrollView.isUserInteractionEnabled = false
//                scrollView.bounces = false
            }
        }
        
        pageControlLabel.font = .poppinsFont(ofSize: 24)
        pageControlLabel.textAlignment = .right
        
        nextButton.backgroundColor = .black
        nextButton.titleLabel?.font = .semiBoldPoppinsFont(ofSize: 20)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.setTitle("Next", for: .normal)
        nextButton.layer.cornerRadius = 28
        
        
        skipButton.backgroundColor = .clear
        skipButton.titleLabel?.font = .semiBoldPoppinsFont(ofSize: 20)
        let customGray = UIColor(red: 114/255, green: 114/255, blue: 114/255, alpha: 1.0)
        skipButton.setTitleColor(customGray, for: .normal)
        skipButton.setTitle("Skip", for: .normal)
        skipButton.layer.cornerRadius = 28
        
        
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        
        delegate = self
        dataSource = self
        
        let page1 = OnboardingViewController(
            title: "Hi!",
            description: "This app will help you fit your entire wardrobe in your phone! Now all your things will be collected here! Isn't it cool?",
            image: UIImage(named: "onboarding-0")
        )
        
        
        let page2 = OnboardingViewController(
            title: "Save your time with us.",
            description: "You no longer have to waste your time deciding what to wear tomorrow or any other day! After all, now you can do it in any place convenient for you, for example: in the subway or in a cafe, while you do not need to carry your entire wardrobe with you, because it is already on your phone!",
            image: UIImage(named: "onboarding-1")
        )
        
        
        let page3 = OnboardingViewController(
            title: "Multitasking",
            subtitle: "Now you can:",
            image: UIImage(named: "onboarding-2")
        )
        page3.pinImageViewToBottom = false
        
        
        let page4 = OnboardingViewController(
            title: "Stay in touch!",
            description: "Stay up to date with all the trends, see the selection of TOP 50 looks and share your looks on social networks!",
            image: UIImage(named: "onboarding-3")
        )
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        pages.append(page4)
        
        setViewControllers([page1], direction: .forward, animated: true)
        
        
        updatePageControlLabel()
    }
    
    private func layout() {
        
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        pageControlLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(skipButton)
        view.addSubview(nextButton)
        view.addSubview(pageControlLabel)
        
        NSLayoutConstraint.activate([
            skipButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                               constant: -0),
            skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skipButton.widthAnchor.constraint(equalToConstant: 140),
            skipButton.heightAnchor.constraint(equalToConstant: 48),
            
            
            nextButton.bottomAnchor.constraint(equalTo: skipButton.topAnchor,
                                               constant: -12),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 140),
            nextButton.heightAnchor.constraint(equalToConstant: 56),
            
            
            pageControlLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                 constant: 8),
            pageControlLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                       constant: -16)
        ])
    }
    
    private func updatePageControlLabel() {
        
        guard let currentViewController = viewControllers?.first,
              let currentIndex = pages.firstIndex(of: currentViewController) else {
            return
        }
        
        
        let currentText = NSAttributedString(
            string: "\(currentIndex + 1)/",
            attributes: [ .foregroundColor : UIColor.black ]
        )
        
        let countText = NSAttributedString(
            string: "\(pages.count)",
            attributes: [ .foregroundColor : UIColor(red: 186/255, green: 186/255, blue: 186/255, alpha: 1.0) ]
        )
        
        let mutableString = NSMutableAttributedString(attributedString: currentText)
        mutableString.append(countText)
        
        pageControlLabel.attributedText = mutableString
        
    }
    
    private func updateButtons() {
        guard let currentViewController = viewControllers?.first,
              let currentIndex = pages.firstIndex(of: currentViewController) else {
            return
        }
        
        let isOnLastPage = currentIndex == (pages.count - 1)
        
        nextButton.setTitle(isOnLastPage ? "Start" : "Next", for: .normal)
        skipButton.isHidden = isOnLastPage
    }

    private func scrollToPrevious() {
        guard let currentPage = viewControllers?.first,
              let previousPage = dataSource?.pageViewController(self, viewControllerBefore: currentPage) else {
            return
        }
        
        setViewControllers([previousPage], direction: .forward, animated: true)
    }
    
    
    @objc
    private func nextTapped() {
        guard let currentPage = viewControllers?.first else {
            return
        }
        
        if let nextPagge = dataSource?.pageViewController(self, viewControllerAfter: currentPage)  {
            setViewControllers([nextPagge], direction: .forward, animated: true)
            updatePageControlLabel()
            updateButtons()
        } else {
            completion()
        }
    }
      
    @objc
    private func skipTapped() {
        completion()
    }
}

extension OnboardingPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        if currentIndex == 0 {
            return nil
        } else {
            return pages[currentIndex - 1]
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        updatePageControlLabel()
        updateButtons()
    }
    
}

private class OnboardingViewController: ViewController {
    
    
    private let titleLabel = UILabel()
    
    private var subtitleLabel: UILabel?
    
    private var descriptionLabel: UILabel?
    
    private let imageView = UIImageView()
    
    var pinImageViewToBottom: Bool = true
    
    
    init(title: String, subtitle: String? = nil, description: String? = nil, image: UIImage?) {
        super.init(nibName: nil, bundle: nil)
        
        titleLabel.text = title
        
        if let subtitle = subtitle {
            subtitleLabel = UILabel()
            subtitleLabel?.text = subtitle
        }
        
        if let description = description {
            descriptionLabel = UILabel()
            descriptionLabel?.text = description
        }
        
        imageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        super.setup()
        
        titleLabel.font = .semiBoldPoppinsFont(ofSize: 32)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 2
        
        imageView.contentMode = .scaleAspectFit
        
        if let subtitleLabel = subtitleLabel {
            subtitleLabel.font = .mediumPoppinsFont(ofSize: 20)
            subtitleLabel.textColor = .black
            subtitleLabel.textAlignment = .left
        }
        
        if let descriptionLabel = descriptionLabel {
            descriptionLabel.font = .poppinsFont(ofSize: 14)
            descriptionLabel.textColor = .black
            descriptionLabel.textAlignment = .left
            descriptionLabel.numberOfLines = 0
            descriptionLabel.adjustsFontSizeToFitWidth = true
        }
        
    }
    
    override func layout() {
        super.layout()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                               constant: 16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: 48),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                 constant: -64),
            
            
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                               constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                constant: -16)
        ])
        
        if !pinImageViewToBottom {
            imageView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor,
                                              constant: -136).isActive = true
        } else {
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                              constant: -136).isActive = true
        }
        
        
        if let subtitleLabel = subtitleLabel {
            subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(subtitleLabel)
            
            NSLayoutConstraint.activate([
                subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
                subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                                   constant: 16)
            ])
            
        }
        
        if let descriptionLabel = descriptionLabel {
            descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(descriptionLabel)
            
            NSLayoutConstraint.activate([
                descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                         constant: 16),
                descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                          constant: -16),
                descriptionLabel.topAnchor.constraint(equalTo: subtitleLabel?.bottomAnchor ?? titleLabel.bottomAnchor,
                                                      constant: 8)
            ])
            
        }
        
        func ancherImageTopTo(label: UILabel) {
            if pinImageViewToBottom {
                imageView.topAnchor.constraint(greaterThanOrEqualTo: label.bottomAnchor,
                                               constant: 16).isActive = true
            } else {
                imageView.topAnchor.constraint(equalTo: label.bottomAnchor,
                                               constant: 16).isActive = true
            }
        }
        
        ancherImageTopTo(label: (descriptionLabel ?? subtitleLabel) ?? titleLabel)
        
        if let imageSize = imageView.image?.size {
            let multiplier = imageSize.height / imageSize.width
            
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor,
                                              multiplier: multiplier).isActive = true
        }
        
    }
    
    
}
