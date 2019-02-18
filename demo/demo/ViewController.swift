//
//  ViewController.swift
//  demo
//
//  Created by 路鹏 on 2019/2/18.
//  Copyright © 2019 路鹏. All rights reserved.
//

import UIKit

public let AppWidth: CGFloat = UIScreen.main.bounds.size.width
public let AppHeight: CGFloat = UIScreen.main.bounds.size.height

class ViewController: UIViewController {
    
    var dataArr:[String]! = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true;
        self.automaticallyAdjustsScrollViewInsets = false;
        
        self.dataArr = ["1","2","3","4","5","6",]
        
        let layout = LPCollectionViewCenterScaleLayout();
        let w = AppWidth-83;
        let h = (1334*w)/750
        layout.itemSize = CGSize.init(width: w, height: h);
        layout.lineSpacing = 20;
        layout.minSacle = 0.8;
        
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 64, width: AppWidth, height: h), collectionViewLayout: layout);
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.showsHorizontalScrollIndicator = false;
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "cell");
        self.view.addSubview(collectionView);
    }
    
    
}

extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CustomCell else {
            return UICollectionViewCell();
        }
        let model = self.dataArr[indexPath.row]
        cell.model = model;
        return cell;
    }
}

