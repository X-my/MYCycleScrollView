//
//  ViewController.swift
//  MYCycleScrollView
//
//  Created by Obj on 2017/2/4.
//  Copyright © 2017年 梦阳 许. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cycleScrollView = MYCycleScrollView(frame: CGRect(x: 0, y: 50, width: view.bounds.width, height: 200))
        cycleScrollView.imageURLs = [ "https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                       "https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                        "http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"]
        cycleScrollView.delegate = self
        self.view.addSubview(cycleScrollView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: MYCycleScrollViewDelegate {
    func cycleScrollView(_ cycleScrollView: MYCycleScrollView, didScrollTo index: Int) {
        print("didScrollTo: \(index)")
    }
    func cycleScrollView(_ cycleScrollView: MYCycleScrollView, didSelectItemAt index: Int) {
        print("didSelectItemAt: \(index)")
    }
}

