//
//  UnLockButton.swift
//  GestureUnlock
//
//  Created by XQ on 16/7/19.
//  Copyright © 2016年 XQ. All rights reserved.
//

import UIKit

class UnLockButton: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    // 判断手势范围
    var touchFrame:CGRect = CGRectZero
    // MARK: - 重写初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initButton()
    }
    
    func initButton() {
        self.userInteractionEnabled = false
        self.setBackgroundImage(UIImage(named: "btn_normal"), forState: .Normal)
        self.setBackgroundImage(UIImage(named: "btn_selected"), forState: .Selected)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let touchX = self.center.x - 24
        let touchY = self.center.y - 24
        self.touchFrame = CGRectMake(touchX, touchY, 48, 48)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
