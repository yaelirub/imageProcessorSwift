//
//  MyCollectionViewCell.swift
//  Filterer
//
//  Created by Yael Rubinstein on 2/13/16.
//  Copyright © 2016 UofT. All rights reserved.
//

import UIKit


public class MyCollectionViewCell:UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    var filterName:String!

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView(frame: self.bounds)
        self.addSubview(imageView)
    }
    
}