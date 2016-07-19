//
//  UnLockView.swift
//  GestureUnlock
//
//  Created by XQ on 16/7/19.
//  Copyright © 2016年 XQ. All rights reserved.
//

import UIKit

class UnLockView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    // 按钮总个数
    let BUTTON_COUNT = 9
    // 按钮行数
    let BUTTON_COL_COUNT = 3
    // 屏幕宽度
    let KSCREEN_SIZE = UIScreen.mainScreen().bounds.size
    // button数组
    var buttons = Array<UnLockButton>()
    // 被选择的button数组
    var selectBtns = Array<UnLockButton>()
    // 当前触摸位置
    var currentTouchLoc:CGPoint = CGPointZero
    // frame
    func frame(view:UIView) ->CGRect{
        return view.frame
    }
    // MARK: - 闭包回传值
    typealias unlockStr = (path:String) ->Void
    var myUnlock:unlockStr?
    // MARK: - 重写init方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    // MARK: - 初始化按钮视图
    func initView() {
        
        self.backgroundColor = UIColor.grayColor()        
        for i in 0..<BUTTON_COUNT {
            let button:UnLockButton = UnLockButton(type: .Custom)
            button.frame = self.getFrame(withIndex: i)
            button.tag = i
            self.addSubview(button)
            self.buttons.append(button)
        }
        
    }
    
    func getFrame(withIndex index:Int) ->CGRect {
        // button大小
        var buttonSize:CGFloat?
        var interval:CGFloat?
        let col = index % BUTTON_COL_COUNT
        let row = index / BUTTON_COL_COUNT
        if KSCREEN_SIZE.height == 480 {
            buttonSize = 56
        }else {
            buttonSize = 74
        }
        interval = (self.frame(self).size.width - buttonSize!*CGFloat(BUTTON_COL_COUNT)) / CGFloat(BUTTON_COL_COUNT + 1)
        let buttonX = interval! + CGFloat(col) * (buttonSize! + interval!)
        let buttonY = interval! + CGFloat(row) * (buttonSize! + interval!)
        let frame = CGRectMake(buttonX, buttonY, buttonSize!, buttonSize!)
        return frame
    }
    // MARK: - 触摸事件
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.touchesMoved(touches, withEvent: event)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 获得当前触摸的位置
        let touch = touches.first
        let touchLocation = touch?.locationInView(touch?.view)
        // 对比
        for btn in self.buttons {
            if CGRectContainsPoint(btn.touchFrame, touchLocation!) {
                btn.selected = true
                if !self.selectBtns.contains(btn){
                    self.selectBtns.append(btn)
                }
                
            }
            self.currentTouchLoc = touchLocation!
        }
        // 重绘
        self.setNeedsDisplay()
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 拼接划过的路径
        var passStr:String = ""
        for btn in self.selectBtns {
            btn.selected = false
            passStr.appendContentsOf("\(btn.tag)")
        }
        // 闭包
        if self.myUnlock != nil {
            self.myUnlock!(path: passStr)
        }
        // 清空数组
        self.selectBtns.removeAll()
        // 重绘
        self.setNeedsDisplay()
    }
    // MARK: - 绘画方法
    override func drawRect(rect: CGRect) {
        let path:UIBezierPath = UIBezierPath()
        for (index,btn) in self.selectBtns.enumerate() {
            if index == 0 {
                path.moveToPoint(btn.center)
            }else {
                path.addLineToPoint(btn.center)
            }
        }
        if self.selectBtns.count > 0 {
            path.addLineToPoint(self.currentTouchLoc)
        }
        UIColor.greenColor().set()
        path.lineWidth = 10
        path.lineCapStyle = .Round
        path.lineJoinStyle = .Bevel
        
        path.stroke()
    }
    // MARK: - 系统自带重写
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }

}
