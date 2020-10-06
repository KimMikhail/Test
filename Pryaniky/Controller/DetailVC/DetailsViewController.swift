//
//  DetailsViewController.swift
//  Pryaniky
//
//  Created by  Mikhail on 01.10.2020.
//  Copyright © 2020  Mikhail. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    var data:      Datum?
    
    var nameLabel: UILabel?
    var textLabel: UILabel?
    var imageView: UIImageView?
    
    var buttons:   [UIButton] = []
    var map:       [String : Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
    }
    
    private func setupTextView() {
        
        setupNameLabel()
        setupTextLabel()
        
    }
    
    private func setupPictureView() {
        
        setupTextView()
        
        imageView = UIImageView(frame: CGRect(x: 8,
                                              y: UIScreen.main.bounds.height - UIScreen.main.bounds.width - 40,
                                              width: UIScreen.main.bounds.width - 16,
                                              height: UIScreen.main.bounds.width - 16))
        imageView?.contentMode = .scaleAspectFit
        let url = (data?.data.url)!
        getImage(urlString: url)
        
        view.addSubview(imageView!)
    }
    
    private func setupSelectorView() {
        
        setupNameLabel()
        
        let stackView = UIStackView(frame: CGRect(x: 8,
                                                  y: Double(nameLabel!.frame.maxY + 16),
                                                  width: Double(UIScreen.main.bounds.width - 16),
                                                  height: Double((data?.data.variants?.count)! * 50)))
            
        stackView.distribution = .equalSpacing
        
        for item in data!.data.variants! {
            let button = UIButton()
            button.setTitle(item.text,
                            for: .normal)
            button.backgroundColor = .lightGray
            button.layer.cornerRadius = 5
            map[item.text] = item.id
            buttons.append(button)
            button.addTarget(self,
                             action: #selector(selectorButtonTapped(sender:)),
                             for: .touchUpInside)

            if item.id == data!.data.selectedID {
                
                button.layer.borderWidth = 2
                button.layer.cornerRadius = 4
                button.layer.borderColor = .init(srgbRed: 0,
                                                 green: 255,
                                                 blue: 0,
                                                 alpha: 0.5)
            }
            stackView.axis = NSLayoutConstraint.Axis.vertical
            stackView.addArrangedSubview(button)
        }

        view.addSubview(stackView)
    }
    
    private func getImage(urlString: String){
        guard let imageURL = URL(string: urlString) else { return }

        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else {
                DispatchQueue.main.async {

                    self.imageView?.image = .init(imageLiteralResourceName: "wifi.slash")
                    self.imageView?.tintColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
                }
                return
            }
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.imageView?.image = image
            }
        }
    }
    
    private func setupView() {
        switch data?.name {
        case ArrayEnum.text.rawValue:
            setupTextView()
        case ArrayEnum.picture.rawValue:
            setupPictureView()
        case ArrayEnum.selector.rawValue:
            setupSelectorView()
        default:
            print("Error")
        }
    }
    
    private func setupNameLabel() {
        
        nameLabel = UILabel(frame: CGRect(x: 8,
                                          y: (navigationController?.navigationBar.frame.height)! + 16,
                                          width: UIScreen.main.bounds.width - 16,
                                          height: 80))
        nameLabel?.text = data?.name
        nameLabel?.font = UIFont(name: "Arial Rounded MT Bold",
                                 size: 42)
        view.addSubview(nameLabel!)
        
    }
    
    private func setupTextLabel() {
        
        textLabel = UILabel(frame: CGRect(x: 8,
                                          y: (navigationController?.navigationBar.frame.height)! + 16 + (nameLabel?.frame.size.height)! + 8,
                                          width: UIScreen.main.bounds.width - 16,
                                          height: 80))
        textLabel?.numberOfLines = 0
        textLabel?.text = "text:\r\n\((data?.data.text)!)"
        view.addSubview(textLabel!)
    }
    
    @objc private func selectorButtonTapped(sender: UIButton) {
    
        let alertController = UIAlertController(title: sender.titleLabel?.text,
                                                message: "id: \(String(describing: map[(sender.titleLabel!.text)!]!))",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                     style: .cancel)
        
        alertController.addAction(okAction)
        present(alertController, animated:  true)
    }
}

