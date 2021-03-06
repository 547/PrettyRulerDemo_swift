//
//  ViewController.swift
//  PrettyRulerDemo_swift
//
//  Created by SevenWang on 2017/3/8.
//  Copyright © 2017年 SevenWang. All rights reserved.
//

import UIKit

class ViewController: UIViewController,TXHRrettyRulerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let ruler = TXHRrettyRuler.init(frame: CGRect.init(x: 20, y: 200, width: UIScreen.main.bounds.width - 20 * 2, height: 40))
//        ruler.arcColor = UIColor.red
        ruler.textFont = UIFont.systemFont(ofSize: 10.0)
        ruler.spaceOfScales = 32
        ruler.widthOfScales = 0.5;
        ruler.rulerDeletate = self;
        ruler.showScrollView(withCount: 100, average: NSNumber.init(value: 1.0), currentValue: 18, smallMode: true ,type: .int)
        self.view.addSubview(ruler)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func txhRrettyRuler(_ rulerScrollView: TXHRulerScrollView!) {
        print("\(rulerScrollView.rulerValue)")
    }

}

