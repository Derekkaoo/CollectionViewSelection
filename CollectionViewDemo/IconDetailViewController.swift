//
//  IconDetailViewController.swift
//  CollectionViewDemo
//
//  Created by 高士傑 on 2019/12/5.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit

class IconDetailViewController: UIViewController {

    @IBOutlet var nameLabel: UILabel! {
        didSet {
            nameLabel.text = icon?.name
        }
    }
    
    @IBOutlet var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.text = icon?.description
            descriptionLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet var priceLabel: UILabel! {
        didSet {
            if let icon = icon {
                priceLabel.text = "$\(icon.price)"
            }
        }
    }
    
    @IBOutlet var iconImageView: UIImageView! {
        didSet {
            iconImageView.image = UIImage(named: icon?.imageName ?? "")
        }
    }
    
    var icon: Icon?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

}
