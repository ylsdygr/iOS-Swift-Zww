//
//  WebViewVC.swift
//  Demo-ZWW
//
//  Created by zww on 9/10/16.
//  Copyright © 2016 zww-organ. All rights reserved.
//

import UIKit

class WebViewVC: UIViewController ,UITextFieldDelegate , UIWebViewDelegate , UIScrollViewDelegate {
    
    var myWebView : UIWebView!
    var tabBarContainer : UIView!
    var networkAddress : UITextField!
    var goToAddress : UIButton!
    
    let DEF_Controllers_Span : CGFloat = (UIScreen.mainScreen().bounds.width * 0.05) / 4
    let DEF_StateBar_Height : CGFloat = 18
    let DEF_Left_Width = UIScreen.mainScreen().bounds.width * 0.95
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialBindControllers()
        initialWebView()
        addGoToAddressEvent()
    }
    func initialBindControllers(){
        //在titleView中添加View用以承载地址栏和按钮
        tabBarContainer = UIView(frame: CGRectMake(0,DEF_StateBar_Height,
            UIScreen.mainScreen().bounds.width,
            (self.navigationController?.navigationBar.bounds.height)! - DEF_StateBar_Height
        ))
        
        networkAddress = UITextField(frame: CGRectMake(0,(tabBarContainer.bounds.height - 20) / 2 ,
            DEF_Left_Width * 0.8,20))
        networkAddress.backgroundColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 0.5)
        networkAddress.clearsOnBeginEditing = true   //编辑开始时清空地址
        networkAddress.keyboardType = UIKeyboardType.Default
        networkAddress.returnKeyType = .Go
        networkAddress.autocapitalizationType = .None    //取消默认的英文首字母大写
        networkAddress.text = "file://demo.pdf"    //默认内容，指向内置PDF
        networkAddress.delegate = self    //用委托事件textFieldShouldReturn来添加按钮上的Return事件
        
        goToAddress = UIButton(frame: CGRectMake(networkAddress.bounds.width + DEF_Controllers_Span * 2,
            (tabBarContainer.bounds.height - 20) / 2 , DEF_Left_Width * 0.2 , 20))
        goToAddress.setTitle("前往", forState: UIControlState.Normal)
        //修改按钮上的字体颜色
        goToAddress.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        //设置按钮上字体的对齐方式
        goToAddress.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        
        tabBarContainer.addSubview(networkAddress)
        tabBarContainer.addSubview(goToAddress)
        
        //下句注意不用使用self.navigationController.titleView,无效
        self.navigationItem.titleView = tabBarContainer
        //启动时是否显示地址栏
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    func addGoToAddressEvent(){
        //设置点击“前往”按钮时所执行的事件
        goToAddress.addTarget(self, action: "goToTheURL", forControlEvents: UIControlEvents.TouchUpInside)
    }
    //加载指定的URL
    func goToTheURL(){
        if (networkAddress.text == ""){
            return
        }
        var webString = networkAddress.text!
        let startIndex = webString.startIndex.advancedBy(0)
        let endIndex = webString.endIndex.advancedBy(webString.characters.count * -1 + 4)
        let range = Range<String.Index>(start: startIndex, end: endIndex)
        let judgeHead = webString.substringWithRange(range)
        if (judgeHead == "file"){
            openTheSpecifiedFile(webString)
            return
        }
        if (judgeHead != "http"){
            webString = "http://" + webString
            networkAddress.text = webString
        }
        let webURL : NSURL! = NSURL(string: webString)
        let request = NSURLRequest(URL: webURL)
        myWebView.loadRequest(request)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    func openTheSpecifiedFile(fileURL : String){
        //获取全文件名，除去file://
        var startIndex = fileURL.startIndex.advancedBy(7)
        var endIndex = fileURL.endIndex.advancedBy(0)
        var range = Range<String.Index>(start: startIndex, end: endIndex)
        let fileFullName = fileURL.substringWithRange(range)
        
        //获取文件名，不包括后缀
        startIndex = fileURL.startIndex.advancedBy(7)
        endIndex = fileURL.endIndex.advancedBy(-4)
        range = Range<String.Index>(start: startIndex, end: endIndex)
        let filePreName = fileURL.substringWithRange(range)
        
        //获取文件后缀名
        startIndex = fileURL.startIndex.advancedBy(fileURL.characters.count - 3)
        endIndex = fileURL.endIndex.advancedBy(0)
        range = Range<String.Index>(start: startIndex, end: endIndex)
        let fileSufName = fileURL.substringWithRange(range)
        
        var filePath = "/" + filePreName
        let file : String? = NSBundle.mainBundle().pathForResource(filePath, ofType: fileSufName)
        //非程序内置文件则去Documents/files下读取
        if (file == nil){
            
            filePath = NSHomeDirectory() + "/Documents" + "/files/" + fileFullName
            let fileManager = NSFileManager.defaultManager()
            if (fileManager.fileExistsAtPath(filePath)){
                let fileNSURL : NSURL! = NSURL(string: filePath)
                let fileRequest : NSURLRequest = NSURLRequest(URL: fileNSURL)
                myWebView.loadRequest(fileRequest)
            }else{
                let alert = UIAlertController(title: NSLocalizedString("NSL_AlertError", comment: ""),
                    message: "没有该文件", preferredStyle: .Alert)
                let alertIKnow = UIAlertAction(title: NSLocalizedString("NSL_AlertIKnow", comment: ""),
                    style: .Default, handler: nil)
                alert.addAction(alertIKnow)
                self.presentViewController(alert, animated: true, completion: nil)
            }
            return
        }
        let fileNSURL : NSURL! = NSURL(string: file!)
        let fileRequest : NSURLRequest = NSURLRequest(URL: fileNSURL)
        myWebView.loadRequest(fileRequest)
        
        //
}
    //键盘上按回车时执行跳转动作
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        goToTheURL()
        return true
    }
    //初始化UIWebView控件
    func initialWebView(){
        myWebView = UIWebView(frame: CGRectMake(0,DEF_StateBar_Height,
            UIScreen.mainScreen().bounds.width,
            UIScreen.mainScreen().bounds.height - DEF_StateBar_Height + 6))
        self.view.addSubview(myWebView)
        
        let webString = "https://www.baidu.com"
        let webURL : NSURL! = NSURL(string: webString)
        let request : NSURLRequest = NSURLRequest(URL: webURL)
        myWebView.loadRequest(request)
        myWebView.scalesPageToFit = true
        myWebView.delegate = self
        myWebView.scrollView.delegate = self
    }
    //拖动实现地址栏的显示与隐藏
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (myWebView.scrollView.bounds.minY <= -100){
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        if (myWebView.scrollView.bounds.minY >= 50){
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
