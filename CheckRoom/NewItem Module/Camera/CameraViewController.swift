//
//  AddItemViewController.swift
//  CheckRoom
//
//  Created by mac on 09.01.2023.
//

import UIKit

class CameraViewController: ViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = .black
        button.titleLabel?.font = .boldSystemFont(ofSize: 22)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Save", for: .normal)
        
        button.layer.cornerRadius = 28
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let vc = CategoryViewController()
        
        navigationController?.pushViewController(vc, animated: true)
        
//        let imagePicker = UIImagePickerController()
//        imagePicker.modalPresentationStyle = .overFullScreen
//        imagePicker.allowsEditing = false
//        imagePicker.sourceType = .camera
//        imagePicker.delegate = self
//
//        present(imagePicker, animated: true)
    }
    
    @objc
    private func editTapped() {
        
    }
    
    @objc
    private func saveTapped() {
        let vc = CategoryViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setup() {
        view.backgroundColor = .white

        navigationController?.navigationBar.prefersLargeTitles = true
        
        title = "Preview"
        
        let editButton = UIBarButtonItem(image: Icons.editPicture,
                                         style: .plain,
                                         target: self,
                                         action: #selector(editTapped))
        editButton.tintColor = UIColor(red: 133/255, green: 133/255, blue: 133/255, alpha: 1.0)
        navigationItem.rightBarButtonItem = editButton
        
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }
    
    private func layout() {
        view.addSubview(saveButton)
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                               constant: -32),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 140),
            saveButton.heightAnchor.constraint(equalToConstant: 56),
            
            
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                           constant: 20),
            imageView.bottomAnchor.constraint(equalTo: saveButton.topAnchor,
                                              constant: -48)
        ])
    }
    
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: false)
        navigationController?.popViewController(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
        }
        
    }
}
