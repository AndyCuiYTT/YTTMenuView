//
//  YTTMenuView.swift
//  YTTMenuView
//
//  Created by AndyCui on 2018/12/7.
//  Copyright © 2018 AndyCuiYTT. All rights reserved.
//

import UIKit

protocol YTTMenuViewDelegate {
    
    func widthOfMenuView(_ menuView: YTTMenuView) -> CGFloat
    
    func numberOfRows(in menuView: YTTMenuView) -> Int
    
    func menuView(_ menuView: YTTMenuView, heightForRowAt index: Int) -> CGFloat
    
    func menuView(_ menuView: YTTMenuView, viewForRowAt index: Int) -> UIView
    
    func menuView(_ menuView: YTTMenuView, didSelectRowAt index: Int)
    
    
}


class YTTMenuView: UIView {
    
    var delegate: YTTMenuViewDelegate? {
        didSet {
           setupSubviews()
        }
    }

    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    func addToSuperView(_ parentView: UIView) {
        
        guard let width = delegate?.widthOfMenuView(self) else {
            assertionFailure("failed to get width of menuView")
            return
        }

        // viewDidLoad 中获取失败
        guard let keyWindow = UIApplication.shared.keyWindow else {
            assertionFailure("failed to get keyWindow")
            return
        }
        
        // 转换坐标
        let reactOfSuperViewInKeywindow = self.convert(parentView.frame, to: keyWindow)
        
        let rect = self.frame
        var x = reactOfSuperViewInKeywindow.minX + (parentView.frame.width - width) / 2
        let y = reactOfSuperViewInKeywindow.maxY + 2
        
        if x + width > keyWindow.bounds.width - 10 {
            x = keyWindow.bounds.width - 10 - width
        }
        
        self.frame = CGRect(origin: CGPoint(x: x, y: y), size: rect.size)
        let parentCenterX = parentView.frame.midX - x
        self.alpha = 0.1
        keyWindow.addSubview(self)
        
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1
        }
        
        // 添加遮罩层
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath()
        
        print(parentCenterX)
        
        path.move(to: CGPoint(x: 0, y: 10))
        path.addLine(to: CGPoint(x: parentCenterX - 7, y: 10))
        path.addLine(to: CGPoint(x: parentCenterX, y: 0))
        path.addLine(to: CGPoint(x: parentCenterX + 7, y: 10))
        path.addLine(to: CGPoint(x: width, y: 10))
        path.addLine(to: CGPoint(x: width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: 10))
        path.close()
        
        shapeLayer.path = path.cgPath
        self.layer.mask = shapeLayer
        
    }
    
    override func removeFromSuperview() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0.1
        }) { (flag) in
            super.removeFromSuperview()
        }
    }
    
    
    func setupSubviews() {
        
        guard let width = delegate?.widthOfMenuView(self) else {
            assertionFailure("failed to get width of menuView")
            return
        }
        
        guard let numberOfRows = delegate?.numberOfRows(in: self) else {
            assertionFailure("failed to get number of rows")
            return
        }
        
        var nextItemViewY: CGFloat = 10
        for index in 0 ..< numberOfRows {
            if let itemView = delegate?.menuView(self, viewForRowAt: index), let itemHeight = delegate?.menuView(self, heightForRowAt: index) {
                itemView.frame = CGRect(x: 0, y: nextItemViewY, width: width, height: itemHeight)
                nextItemViewY += itemHeight
                itemView.tag = 100 + index
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
                itemView.addGestureRecognizer(tapGestureRecognizer)
                self.addSubview(itemView)
            } else {
                assertionFailure("failed to get View or height for Row At \(index)")
            }
        }
        self.frame = CGRect(x: 0, y: 0, width: width, height: nextItemViewY)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let resultView = super.hitTest(point, with: event) {
            return resultView
        }
        self.removeFromSuperview()
        return nil
    }
    
    @objc func tapAction(_ gestureRecognizer: UIGestureRecognizer) {
        guard let index = gestureRecognizer.view?.tag else {
            assertionFailure("fialed to selected row")
            return
        }
        self.removeFromSuperview()
        delegate?.menuView(self, didSelectRowAt: index)
    }
  
    
    
    

}





