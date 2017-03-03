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
        cycleScrollView.imageURLs = [ "http://img-1251987965.cossh.myqcloud.com/banner/banner_dazuozhan.png",
                                       "http://img-1251987965.cossh.myqcloud.com/banner/banner_justice.png"]
        cycleScrollView.autoScrollTimeInterval = 5
        cycleScrollView.imageViewContentMode = .scaleAspectFill
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

