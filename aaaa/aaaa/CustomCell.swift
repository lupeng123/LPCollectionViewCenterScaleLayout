//
//  CustomCell.swift
//  aaaa
//
//  Created by 路鹏 on 2018/11/12.
//  Copyright © 2018 路鹏. All rights reserved.
//

import UIKit

class CustomCell: UICollectionViewCell {
    public var model:String! {
        didSet{
            self.img.image = UIImage.init(named: model);
        }
    }
    
    public var img:UIImageView!;
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = UIColor.red;
        self.setUI();
    }
    
    func setUI() {
        let img = UIImageView();
        img.layer.cornerRadius = 6;
        img.layer.masksToBounds = true;
        self.addSubview(img);
        self.img = img;
        self.img.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height);
    }
}
