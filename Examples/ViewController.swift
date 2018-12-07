//
//  ViewController.swift
//  YTTMenuView
//
//  Created by AndyCui on 2018/12/7.
//  Copyright © 2018 AndyCuiYTT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

      
        
        
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setTitle("menu", for: UIControl.State.normal)
        btn.frame = CGRect(x: 300, y: 10, width: 50, height: 40)
        btn.backgroundColor = UIColor.purple
        btn.addTarget(self, action: #selector(addMenuView(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(btn)
        
        

    }
    
    @objc func addMenuView(_ sender: UIButton) {
        let menuView = YTTMenuView()
        menuView.delegate = self
        menuView.backgroundColor = UIColor.orange
        menuView.addToSuperView(sender)
    }


}

extension ViewController: YTTMenuViewDelegate {
    func menuView(_ menuView: YTTMenuView, didSelectRowAt index: Int) {
        
    }
    
    func widthOfMenuView(_ menuView: YTTMenuView) -> CGFloat {
        return 100
    }
    
    func numberOfRows(in menuView: YTTMenuView) -> Int {
        return 4
    }
    
    func menuView(_ menuView: YTTMenuView, heightForRowAt index: Int) -> CGFloat {
        return 40
    }
    
    func menuView(_ menuView: YTTMenuView, viewForRowAt index: Int) -> UIView {
        let v = UIView()
        if #available(iOS 10.0, *) {
            v.backgroundColor = UIColor.init(displayP3Red: CGFloat(arc4random() % 225) / 225, green: CGFloat(arc4random() % 225) / 225, blue: CGFloat(arc4random() % 225) / 225, alpha: 1)
        } else {
            v.backgroundColor = UIColor(red: CGFloat(arc4random() % 225) / 225, green: CGFloat(arc4random() % 225) / 225, blue: CGFloat(arc4random() % 225) / 225, alpha: 1)
        }
        return v
    }
    
    
}
