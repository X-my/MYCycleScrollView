//
//  MYCycleScrollView.swift
//  MYCycleScrollView
//
//  Created by Obj on 2017/2/4.
//  Copyright © 2017年 梦阳 许. All rights reserved.
//

import UIKit

private let kCellReuseIdentifier = "MYCollectionViewCell"

public enum PageContolAliment {
    case center
    case right
}

@objc public protocol MYCycleScrollViewDelegate: NSObjectProtocol {
    @objc optional
    func cycleScrollView(_ cycleScrollView: MYCycleScrollView, didSelectItemAt index: Int)
    func cycleScrollView(_ cycleScrollView: MYCycleScrollView, didScrollTo index: Int)
}

public class MYCycleScrollView: UIView, UICollectionViewDataSource,UICollectionViewDelegate {

    // MARK: - Public Properties
    public var imageURLs = [String]() {
        didSet {
            if imageURLs.count < oldValue.count {
                collectionView.setContentOffset(CGPoint.zero, animated: false)
            }
            totalItemsCount = isInfiniteLoop ? imageURLs.count * 100 : imageURLs.count
            
            invalidateTimer()
            if imageURLs.count == 1 {
                collectionView.isScrollEnabled = false
            }else {
                collectionView.isScrollEnabled = true
                if isAutoScroll {
                    setupTimer()
                }
            }
            setupPageControl()
            collectionView.reloadData()
            
        }
    
    }
    public var isAutoScroll = true {
        didSet {
            invalidateTimer()
            if isAutoScroll {
                setupTimer()
            }
        }
    }
    
    public var placehoder: UIImage?
    public var imageTransition = ImageTransition.fade(0.3)
    public var imageViewContentMode: UIViewContentMode = .scaleToFill
    public weak var delegate: MYCycleScrollViewDelegate?
    public private (set)  var pageControl: UIPageControl = UIPageControl()
    public var isInfiniteLoop = true
    public var autoScrollTimeInterval: TimeInterval = 3.0
    public var pageContolAliment: PageContolAliment = .right
    
    
    // MARK: - Private Properties
    fileprivate var totalItemsCount = 0
    fileprivate var currentIndex: Int {
        if collectionView.frame.width == 0 || collectionView.frame.height == 0 {
            return 0
        }
        var index = 0
        switch flowLayout.scrollDirection {
        case .horizontal:
            index = Int((collectionView.contentOffset.x + flowLayout.itemSize.width * 0.5) / flowLayout.itemSize.width)
        case.vertical:
            index = Int((collectionView.contentOffset.y + flowLayout.itemSize.height * 0.5) / flowLayout.itemSize.height)
        }
        return max(0, index)
    }
    weak var timer: Timer?
    
    // MARK: - 初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubview()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubview()
    }
    public override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview == nil {
            self.invalidateTimer()
        }
    }
    deinit {
        collectionView.delegate = nil
        collectionView.dataSource = nil
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        flowLayout.itemSize = self.frame.size
        collectionView.frame = self.bounds
        if collectionView.contentOffset.x == 0 && totalItemsCount > 0 {
            var targetIndex = 0
            if self.isInfiniteLoop {
                targetIndex = totalItemsCount / 2
            }
            collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: .init(rawValue: 0), animated: false)
        }
        pageControl.frame.size = pageControl.size(forNumberOfPages: imageURLs.count)
        var x: CGFloat = 0
        switch pageContolAliment {
        case .center:
            x = (self.bounds.width - pageControl.bounds.width) / 2
        case .right:
            x = self.bounds.width - pageControl.bounds.width - 10
        }
        let y = self.bounds.height - pageControl.bounds.height
        pageControl.frame.origin = CGPoint(x: x, y: y)
    }
    // MARK: - Private Methods
    private func setupSubview() {
        self.backgroundColor = UIColor.lightGray
        self.addSubview(collectionView)
        self.addSubview(pageControl)
        pageControl.hidesForSinglePage = true
        pageControl.isUserInteractionEnabled = false
    }
    private func setupPageControl() {
        pageControl.numberOfPages = imageURLs.count
        pageControl.currentPage = self.currentIndex % self.imageURLs.count
    }
    fileprivate func invalidateTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    fileprivate func setupTimer() {
        let timer = Timer(timeInterval: autoScrollTimeInterval, target: self, selector: #selector(automaticScroll), userInfo: nil, repeats: true)
        self.timer = timer
        RunLoop.main.add(timer, forMode: .commonModes)
    }
    @objc private func automaticScroll() {
        if totalItemsCount == 0 { return }
        var targetIndex = self.currentIndex + 1
        if targetIndex >= totalItemsCount {
            if self.isInfiniteLoop {
                targetIndex = totalItemsCount/2
                collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: .init(rawValue: 0), animated: false)
            }
            return
        }
        collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: .init(rawValue: 0), animated: true)
    }
    // MARK: - Lazy Properties
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: self.flowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MYCollectionViewCell.self, forCellWithReuseIdentifier: kCellReuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.scrollsToTop = false
        return collectionView
    }()
}
// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
public extension MYCycleScrollView{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.totalItemsCount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellReuseIdentifier, for: indexPath) as! MYCollectionViewCell
        let index = indexPath.item % self.imageURLs.count
        cell.imageView.kf.setImage(with: URL(string: self.imageURLs[index]), placeholder:self.placehoder, options: [.transition(self.imageTransition)])
        cell.imageView.contentMode = self.imageViewContentMode
        return cell
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let delegate = self.delegate,
            delegate.responds(to: #selector(MYCycleScrollViewDelegate.cycleScrollView(_:didSelectItemAt:))) else {
                return
        }
        delegate.cycleScrollView!(self, didSelectItemAt: indexPath.item % self.imageURLs.count)
    }
}
// MARK: - UIScrollViewDelegate
public extension MYCycleScrollView {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard self.imageURLs.count > 0 else { return }
        guard !self.pageControl.isHidden else { return }
        self.pageControl.currentPage = self.currentIndex % self.imageURLs.count
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.isAutoScroll {
            self.invalidateTimer()
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.isAutoScroll {
            self.setupTimer()
        }
    }
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard self.imageURLs.count > 0 else { return }
        guard let delegate = self.delegate,
            delegate.responds(to: #selector(MYCycleScrollViewDelegate.cycleScrollView(_:didScrollTo:))) else {
                return
        }
        let index = self.currentIndex % self.imageURLs.count
        delegate.cycleScrollView(self, didScrollTo: index)
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidEndScrollingAnimation(self.collectionView)
    }
}
fileprivate class MYCollectionViewCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
    }
}
