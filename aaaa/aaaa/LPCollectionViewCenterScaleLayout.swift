//
//  LPCollectionViewCenterScaleLayout.swift
//  MaiYa
//
//  Created by 路鹏 on 2018/9/26.
//  Copyright © 2018年 LP. All rights reserved.
//

import UIKit

class LPCollectionViewCenterScaleLayout: UICollectionViewLayout {
    
    public var itemSize:CGSize! = CGSize.zero;//item大小
    public var lineSpacing:CGFloat! = 20;//item间距（左右滑动间距会保持不变）
    public var minSacle:CGFloat! = 0.5;//最小缩放倍数
    public var scrollToCount:Int = 0;//当前选中的item
    
    var attrsArray:[UICollectionViewLayoutAttributes] = [];
    
    var itemCount:Int = 0;
    var realLineSpacing:CGFloat! = 0;
    
    override func prepare() {
        super.prepare();
        self.itemCount = self.collectionView?.numberOfItems(inSection: 0) ?? 0;
        self.realLineSpacing = self.lineSpacing-(self.itemSize.width-self.itemSize.width*self.minSacle)*0.5;
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.attrsArray[indexPath.row];
    }
    
    override var collectionViewContentSize: CGSize {
        let inset = (self.collectionView?.frame.size.width ?? 0) - self.itemSize.width;
        let w = inset + self.itemSize.width*CGFloat(self.itemCount)+self.realLineSpacing*CGFloat(self.itemCount-1)
        return CGSize.init(width: w, height: self.collectionView?.bounds.size.height ?? 0);
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attrsArr = attrsArrForVisible(rect: rect, offset: self.collectionView?.contentOffset ?? CGPoint.zero);
        return attrsArr
    }
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true;
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        var rect = CGRect();
        rect.origin = proposedContentOffset;
        rect.size = self.collectionView?.bounds.size ?? CGSize.zero;
        let centerX:CGFloat = (self.collectionView?.frame.size.width ?? 0)*0.5 + (self.collectionView?.contentOffset.x ?? 0);
        let attrsArr = self.attrsArrForVisible(rect: rect, offset: proposedContentOffset);
        var x:CGFloat = CGFloat(MAXFLOAT);
        var returnAttr:UICollectionViewLayoutAttributes!;
        for attr in attrsArr {
            let distance = fabs(attr.center.x-centerX);
            if (distance < x) {
                x = distance;
                returnAttr = attr;
            }
        }
        
        var offsetX = returnAttr == nil ? 0 : returnAttr.center.x-(self.collectionView?.frame.size.width ?? 0)*0.5;
        let maxOffsetX = (self.collectionView?.contentSize.width ?? UIScreen.main.bounds.size.width) - UIScreen.main.bounds.size.width
        if (Int(proposedContentOffset.x) < 10 || fabs(proposedContentOffset.x-maxOffsetX)<10) {
            offsetX = proposedContentOffset.x;
        }
        let point = CGPoint(x: Int(offsetX), y: Int(proposedContentOffset.y))
        
        let itemDistance = self.itemSize.width + self.realLineSpacing;
        self.scrollToCount = Int(offsetX/itemDistance);
        
        return point;
    }
}

extension LPCollectionViewCenterScaleLayout {
    func attrsArrForVisible(rect: CGRect, offset: CGPoint) -> [UICollectionViewLayoutAttributes] {
        var attrsArr:[UICollectionViewLayoutAttributes] = [];
        var arr:[UICollectionViewLayoutAttributes] = [];
        for i in 0..<self.itemCount {
            let indexPath = NSIndexPath.init(item: i, section: 0)
            let attr = layoutAttributesForItem(indexPath: indexPath, offset: offset)
            let isInter = rect.intersects(attr.frame)
            arr.append(attr);
            if isInter {
                attrsArr.append(attr)
            }
        }
        self.attrsArray = arr;
        return attrsArr
    }
    
    func layoutAttributesForItem(indexPath: NSIndexPath, offset: CGPoint) -> UICollectionViewLayoutAttributes {
        
        var x = (self.collectionView?.frame.size.width ?? 0)*0.5;
        x = x + (self.itemSize.width+self.realLineSpacing)*CGFloat(indexPath.row);
        let y = (self.collectionView?.frame.size.height ?? 0)*0.5;
        
        let attr = UICollectionViewLayoutAttributes.init(forCellWith: indexPath as IndexPath)
        attr.center = CGPoint(x: x, y: y)
        attr.size = self.itemSize
        
        let a = self.itemSize.width + self.realLineSpacing;
        let contentOffsetX:CGFloat = (self.collectionView?.contentOffset.x ?? 0);
        let collectionViewCenterX:CGFloat = (self.collectionView?.frame.size.width ?? 0)*0.5;
        var scale = (CGFloat(fabs(attr.center.x - contentOffsetX - collectionViewCenterX)) / a)*(1-self.minSacle);
        scale = 1-scale;

        if (scale < self.minSacle) {
            scale = self.minSacle;
        }
        attr.transform = CGAffineTransform.init(scaleX: scale, y: scale)
        return attr
        
    }
}
