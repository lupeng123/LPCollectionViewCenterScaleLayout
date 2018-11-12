# LPCollectionViewCenterScaleLayout
collectionview的layout，滑动两边缩小中间正常，自动滚动到中间，自定义间距，缩放大小，item大小

###使用方法
```objc
public var itemSize:CGSize! = CGSize.zero;//item大小
public var lineSpacing:CGFloat! = 20;//item间距（左右滑动间距会保持不变）
public var minSacle:CGFloat! = 0.5;//最小缩放倍数
public var scrollToCount:Int = 0;//当前选中的item
```
