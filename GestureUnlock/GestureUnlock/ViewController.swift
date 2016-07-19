//
//  ViewController.swift
//  GestureUnlock
//
//  Created by XQ on 16/7/19.
//  Copyright © 2016年 XQ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // 暂存password
    var tempPath:String = ""
    // 提示信息label
    let tipLabel = UILabel()
    // 重置button
    let reBtn = UIButton(type: .System)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initUI()
        self.initUnlockView()
    }
    // MARK: - 获取宽高
    func width(view:UIView)->CGFloat {
        return view.frame.size.width
    }
    func height(view:UIView)->CGFloat {
        return view.frame.size.height
    }
    // MARK: - 初始化界面
    func initUI() {
        // label
        tipLabel.frame = CGRectMake(0, height(self.view) - 300, width(self.view), 50)
        tipLabel.textAlignment = .Center
        // 设置label文字     没有设置的时候设置,设置以后输入解密
        if let _ = NSUserDefaults.standardUserDefaults().valueForKey("password"){
            self.tipLabel.text = "请绘制手势解锁"
        }else {
            self.tipLabel.text = "请设置手势密码"
        }
        self.view.addSubview(tipLabel)
        // button
        reBtn.frame = CGRectMake(0, 0, 200, 40)
        reBtn.center = CGPointMake(width(self.view) / 2, height(self.view) - 200)
        reBtn.setTitle("重置密码", forState: .Normal)
        reBtn.addTarget(self, action: "btnClick:", forControlEvents: .TouchUpInside)
        self.view.addSubview(reBtn)
    }
    // MARK: - 初始化解锁界面
    func initUnlockView() {
        // lockView
        let unlock:UnLockView = UnLockView.init(frame: CGRectMake(0, 0, width(self.view), height(self.view) - 300))
        self.view.addSubview(unlock)
        // 闭包
        unlock.myUnlock = {(path:String)->Void in
            // 不过有的话验证密码,没有的话设置
            if let password = NSUserDefaults.standardUserDefaults().valueForKey("password"){
                if password as! String == path {
                    self.tipLabel.text = "密码正确"
                }else {
                    self.tipLabel.text = "密码错误"
                }
            }else {
                // 设置密码
                self.checkWith(password: path)
            }
        }
    }
    // MARK: - 设置密码
    func checkWith(password password:String) {
       // 小于4个点提示错误
        if password.characters.count < 4 {
            self.tipLabel.text = "至少连接4个点"
            return
        }else {
            // 第一次绘制以后提示第二次绘制
            if tempPath.characters.count == 0 {
                tipLabel.text = "请确定解锁图案"
                tempPath = password
                return
            }else {
                // 第二次绘制如果跟第一次一样,就存入本地,不一样提示错误
                if tempPath == password {
                    NSUserDefaults.standardUserDefaults().setObject(password, forKey: "password")
                    tipLabel.text = "设置成功"
                }else {
                    tipLabel.text = "两次不一样"
                }
            }
        }
    }
    func btnClick(sender:UIButton) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("password")
        self.tipLabel.text = "请设置手势密码"
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

