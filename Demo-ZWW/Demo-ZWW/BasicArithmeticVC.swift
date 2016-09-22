//
//  BasicArithmeticVC.swift
//  Demo-ZWW
//
//  Created by zww on 9/8/16.
//  Copyright © 2016 zww-organ. All rights reserved.
//

import UIKit

class BasicArithmeticVC: UIViewController , UITextFieldDelegate {
    
    @IBOutlet var uiCurrentData : UILabel!
    @IBOutlet var uiAddData : UIButton!
    @IBOutlet var uiSortExe : UIButton!
    @IBOutlet var originalData : UITextField!
    @IBOutlet var newData : UITextField!
    @IBOutlet var sortResult : UITextField!
    @IBOutlet var bubblingLog : UITextView!
    
    var SC : UISegmentedControl!
    var arrayData : [Int]!
    var sortConverse : Int = 0
    let DEFINE_DepartOperator : String = ","
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSegmentedControl()
        initialBindControllers()
    }
    //初始化分段控件
    func initialSegmentedControl(){
        //Bubbling Sort
/*        SC = UISegmentedControl(items: [NSLocalizedString("NSL_navigationItem1", comment: "冒泡排序基本算法"),
            NSLocalizedString("NSL_navigationItem2", comment: "二分查找及过程演示"),
            NSLocalizedString("NSL_navigationItem3", comment: "迭代算桃子及过程记录"),
            NSLocalizedString("NSL_navigationItem4", comment: "基础进制转换演示"),
            NSLocalizedString("NSL_navigationItem5", comment: "矩阵转置及过程演示")])
*/
        SC = UISegmentedControl(items: [NSLocalizedString("NSL_navigationItem1", comment: "冒泡排序基本算法"),
            NSLocalizedString("NSL_navigationItem2", comment: "二分查找及过程演示"),
            NSLocalizedString("NSL_navigationItem3", comment: "迭代算桃子及过程记录")])
        self.navigationItem.titleView = SC
        self.navigationController?.navigationBar.tintColor = UIColor.blueColor()
//        self.navigationController?.navigationBar.barTintColor = UIColor.grayColor()
        self.navigationController?.setNavigationBarHidden(false , animated: true)
        SC.selectedSegmentIndex = 0
        SC.addTarget(self, action: "segmentValueChanged", forControlEvents: UIControlEvents.ValueChanged)
        
        //暂时隐藏NavigationController的Toolbar
        self.navigationController?.setToolbarHidden(true, animated: true)
//        self.navigationController?.setToolbarHidden(false, animated: true)
//        let one = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: nil, action: nil)
//        let two = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Bookmarks, target: nil, action: nil)
//        let three = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: nil, action: nil)
//        let four = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: nil, action: nil)
//        self.toolbarItems = [one,two,three,four]
    }
    //分段控件选择事件执行体
    func segmentValueChanged(){
        switch SC.selectedSegmentIndex {
//        case 0 : let BS = BubblingSortVC() //此算法直接写在第一段页了
//            self.navigationController?.pushViewController(BS, animated: true)
        case 1 : let BF = BinaryFindVC()
            BF.title = NSLocalizedString("NSL_navigationItem2", comment: "")
            self.navigationController?.pushViewController(BF, animated: true)
            SC.selectedSegmentIndex = 0
        case 2 : let IC = IterativeCalcVC()
            IC.title = NSLocalizedString("NSL_navigationItem3", comment: "")
            self.navigationController?.pushViewController(IC, animated: true)
            SC.selectedSegmentIndex = 0
        case 3 : let RC = RadixConvertVC()
            RC.title = NSLocalizedString("NSL_navigationItem4", comment: "")
            self.navigationController?.pushViewController(RC, animated: true)
            SC.selectedSegmentIndex = 0
        case 4 : let MC = MatrixConvertVC()
            MC.title = NSLocalizedString("NSL_navigationItem5", comment: "")
            self.navigationController?.pushViewController(MC, animated: true)
            SC.selectedSegmentIndex = 0
        default : SCNilAlert("错误提示", paraMessage: "未能找到当前标签")
        }
    }
    //控件异常提示信息
    func SCNilAlert(paraTitle : String , paraMessage : String){
        let nilAlert = UIAlertController(title: paraTitle, message: paraMessage, preferredStyle: .Alert)
        let okButton = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
        let cancelButton = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        nilAlert.addAction(okButton)
        nilAlert.addAction(cancelButton)
        self.presentViewController(nilAlert, animated: true, completion: nil)
    }
    //--------冒泡排序算法界面绑定--------
    func initialBindControllers(){
        uiCurrentData.text = NSLocalizedString("NSL_currentDataLabel", comment: "")
        uiCurrentData.textAlignment = .Center
        uiAddData.setTitle(NSLocalizedString("NSL_addDataButton", comment: ""), forState: .Normal)
        uiSortExe.setTitle(NSLocalizedString("NSL_showResultButton", comment: ""), forState: .Normal)
        
        originalData.enabled = false
        sortResult.enabled = false
        arrayData = [Int]()
        for _ in 0...7{
            arrayData.append(BasicArithmeticVC.randomInt())
        }
        originalData.text = BasicArithmeticVC.arrayToString(arrayData)
        newData.keyboardAppearance = UIKeyboardAppearance.Dark
        newData.keyboardType = .NumbersAndPunctuation
        newData.textAlignment = NSTextAlignment.Right
        newData.placeholder = "在此输入新数据,以\" , \"为分隔"
        newData.clearButtonMode = .Always
        newData.delegate = self
        
        
        bubblingLog.text = ""
        bubblingLog.textColor = UIColor.lightGrayColor()
        bubblingLog.textAlignment = .Center
        bubblingLog.font = UIFont.systemFontOfSize(16)
        bubblingLog.scrollEnabled = true
        bubblingLog.editable = false
        bubblingLog.clearsOnInsertion = false
    }
    //将数组以字符串显示
    class func arrayToString(para : [Int]) -> String {
        var result : String = ""
        for character in para{
            result += "\(character),"
        }
        
        //--------字符串截取,这里需要删除最后一个","-----------
        let startIndex = result.startIndex.advancedBy(0)
        let endIndex = result.endIndex.advancedBy(-1)
        let range = Range<String.Index>(start: startIndex, end: endIndex)
        result = result.substringWithRange(range)
        //---------字符串截取,类函数内函数不可以是实例函数------
        
        return result
    }
    

    //将字符串以数组组装
    func stringToArray(para : String) -> [Int] {
        let resultString : [String] = para.componentsSeparatedByString(DEFINE_DepartOperator)
        var result : [Int] = [Int]()
        for element in resultString {
            var value : Int = 0, positiveOrNegative = 1 , isZero = 0
            for character in element.characters{
                value *= 10
                switch character{
                case "0" : value += 0 ; isZero = 1
                    continue
                case "1" : value += 1
                    continue
                case "2" : value += 2
                    continue
                case "3" : value += 3
                    continue
                case "4" : value += 4
                    continue
                case "5" : value += 5
                    continue
                case "6" : value += 6
                    continue
                case "7" : value += 7
                    continue
                case "8" : value += 8
                    continue
                case "9" : value += 9
                    continue
                case "-" : value = 0 ; positiveOrNegative = -1
                    continue
                default : print("转换错误")
                }
            }
            if (value != 0 ){
                result.append(value * positiveOrNegative)
            }else if (value == 0 && isZero == 1) {
                result.append(0)
            }
        }
        return result
    }
    //添加新的元素用以排序
    @IBAction func addData(){
        if (newData.text! == ""){
            SCNilAlert("错误",paraMessage: "请输入数据后再添加")
            return
        }
        var preData : [Int] = stringToArray(originalData.text!)
        let tempData : [Int] = stringToArray(newData.text!)
        preData.appendContentsOf(tempData)
        arrayData = preData
        newData.text = ""
        originalData.text = BasicArithmeticVC.arrayToString(arrayData)
    }
    //只接受输入数字和英文逗号
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if (string >= "0" && string <= "9"){
            return true
        }else if (string == ",") {
            return true
        }else if (string == "-" ){
            return true
        }
        return false
    }
    @IBAction func sortExe(){
        let compareLog = UILabel(frame: CGRectMake(140,220,110,10))
        compareLog.text = "冒泡历史记录"
        compareLog.textColor = UIColor.blueColor()
        self.view.addSubview(compareLog)
        bubblingLog.text = ""
        sortConverse += 1
        var dataArray : [Int] = stringToArray(originalData.text!)
        if (sortConverse % 2 == 1){
            dataArray = buddlingSortA(dataArray)
        }
        else{
            dataArray = buddlingSortB(dataArray)
        }
        sortResult.text = BasicArithmeticVC.arrayToString(dataArray)
    }
    //--------冒泡排序算法从小到大开始--------
    func buddlingSortA(para : [Int]) -> [Int] {
        var inPara = para
        var i = 0 , j = 1
        var logString : String = ""
        var isBubbling = 0
        for (i = 0 ; i < j ; i += 1) {
            for j = i + 1 ; j < inPara.count ; j += 1{
                if inPara[i] > inPara[j]{
                    let temp = inPara[i]
                    inPara[i] = inPara[j]
                    inPara[j] = temp
                    logString += " \(inPara[i]) 比 \(inPara[j]) 小,两者换位\n"
                    isBubbling = 1
                }
            }
            if (isBubbling == 1){
                logString += "第 \(i+1) 位最小值 \(inPara[i]) 冒泡至第 \(i+1) 位\n"
                logString += BasicArithmeticVC.arrayToString(inPara) + "\n\n"
                isBubbling = 0
            }
        }
        bubblingLog.text = logString
        return inPara
    }
    //--------冒泡排序算法从大到小开始--------
    func buddlingSortB(para : [Int]) -> [Int] {
        var inPara = para
        var i = 0 , j = 1
        var logString : String = ""
        var isBubbling = 0
        for (i = 0 ; i < j ; i += 1) {
            for j = i + 1 ; j < inPara.count ; j += 1{
                if inPara[i] < inPara[j]{
                    let temp = inPara[i]
                    inPara[i] = inPara[j]
                    inPara[j] = temp
                    logString += " \(inPara[i]) 比 \(inPara[j]) 大,两者换位\n"
                    isBubbling = 1
                }
            }
            if (isBubbling == 1){
                logString += "第 \(i+1) 位最大值 \(inPara[i]) 冒泡至第 \(i+1) 位\n"
                logString += BasicArithmeticVC.arrayToString(inPara) + "\n\n"
                isBubbling = 0
            }
        }
        bubblingLog.text = logString
        return inPara
    }
    //--------冒泡排序算法结束--------
    //随机数生成，范围, -100 ... 1000
    class func randomInt() -> Int{
        var rInt = Int(random() % 1000)
        let para = Int(random() % 10)
        if (para % 4 == 1 ){
            rInt *= -1
        }
        return rInt
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
