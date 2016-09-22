//
//  BinaryFindVC.swift
//  Demo-ZWW
//
//  Created by zww on 9/8/16.
//  Copyright © 2016 zww-organ. All rights reserved.
//

import UIKit

class BinaryFindVC: UIViewController , UITextFieldDelegate {
    
    @IBOutlet var newData : UITextField!
    @IBOutlet var findElement : UITextField!
    @IBOutlet var findResult : UITextField!
    @IBOutlet var findLog : UITextView!
    
    var originalData : UITextView!
    var arrayData : [Int]!
    var compareCount : Int = 0
    let DEFINE_DepartOperator : String = ","
    let DEFINE_OriginalDataCount : Int = 49
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialBindControllers()
        createAndInitialTextView()
    }
    //--------二分查找算法界面绑定--------
    func initialBindControllers(){
        arrayData = [Int]()
        for _ in 0...DEFINE_OriginalDataCount {
            arrayData.append(BasicArithmeticVC.randomInt())
        }
        arrayData = buddlingSortA(arrayData)

        newData.keyboardAppearance = UIKeyboardAppearance.Dark
        newData.keyboardType = .NumbersAndPunctuation
        newData.textAlignment = NSTextAlignment.Right
        newData.placeholder = "在此输入新数据,以\" , \"为分隔"
        newData.clearButtonMode = .Always
        newData.returnKeyType = .Done
        newData.delegate = self
        
        findElement.keyboardAppearance = UIKeyboardAppearance.Dark
        findElement.keyboardType = .NumbersAndPunctuation
        findElement.placeholder = "在此输入需要查找数据"
        findElement.textAlignment = .Right
        
        findResult.textAlignment = .Right
        findResult.enabled = false
        
        findLog.text = ""
        findLog.scrollEnabled = true
        findLog.clearsOnInsertion = false
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    //创建并初始化一个文本视图
    func createAndInitialTextView(){
        originalData = UITextView(frame: CGRectMake(12, 100, 350, 200))
        //12, 80, 300, 150
        originalData.scrollEnabled = true
//        originalData.backgroundColor = UIColor.grayColor()
        originalData.font = UIFont.systemFontOfSize(20)
//        originalData.autoresizingMask = .FlexibleHeight
        originalData.editable = false
        originalData.text = BasicArithmeticVC.arrayToString(arrayData)
        self.view.addSubview(originalData)
    }
    //重新生成一次数据
    @IBAction func regenerateData(){
        arrayData.removeAll()
        originalData.text = ""
        for _ in 0...DEFINE_OriginalDataCount {
            arrayData.append(BasicArithmeticVC.randomInt())
        }
        arrayData = buddlingSortA(arrayData)
        originalData.text = BasicArithmeticVC.arrayToString(arrayData)
    }
    //添加新数据
    @IBAction func addNewData(){
        if (newData.text! == ""){
            SCNilAlert("提示", paraMessage: "请先输入需要添加的元素")
            return
        }
        var preData : [Int] = stringToArray(originalData.text!)
        let tempData : [Int] = stringToArray(newData.text!)
        preData.appendContentsOf(tempData)
        arrayData = preData
        arrayData = buddlingSortA(arrayData)
        newData.text = ""
        originalData.text = BasicArithmeticVC.arrayToString(arrayData)
    }
    //查找并显示查找结果
    @IBAction func findAndShowResult(){
        findLog.text = ""
        compareCount = 0
        if (findElement.text! == ""){
            SCNilAlert("提示", paraMessage: "请先输入需要查找的元素")
            return
        }
//        let findArray : [Int] = stringToArray(findElement.text!)
        let wantsToFind : Int = stringToArray(findElement.text!)[0]
        print(wantsToFind)
        let returnedFindResult : Int = binaryFind(arrayData , para: wantsToFind)
        if (returnedFindResult == -1){
            findResult.text = "源数据中无此数据"
        }else {
            findResult.text = "查找到数据,所在位置为\(returnedFindResult + 1)"
        }
        
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
    //--------二分查找算法开始--------
    func binaryFind(paraArray : [Int] ,para : Int) -> Int {
        var inPara = -1 , low = 0 , high = paraArray.count - 1
        var temp = ""
        repeat{
            if (para == paraArray[low]){
                inPara = low
                compareCount += 1
                temp = temp + "第\(compareCount)次：与第 \(low + 1) 位 \(paraArray[low]) 对比,成功\n"
                findLog.text = temp
                return inPara
            }
            if (para == paraArray[high]){
                inPara = high
                compareCount += 1
                temp = temp + "第\(compareCount)次：与第 \(high + 1) 位 \(paraArray[high]) 对比,成功\n"
                findLog.text = temp
                return inPara
            }
            let mid = low + Int((high - low)/2);
            if (para == paraArray[mid]){
                inPara = mid
                compareCount += 1
                temp = temp + "第\(compareCount)次：与第 \(mid + 1) 位 \(paraArray[mid]) 对比,成功\n"
                findLog.text = temp
                return inPara
            }
            if (para > paraArray[mid]) {
                compareCount += 1
                temp = temp + "第\(compareCount)次：与第 \(mid + 1) 位 \(paraArray[mid]) 对比,待查值较大\n"
                findLog.text = temp
                low = mid + 1
            }else {
                compareCount += 1
                temp = temp + "第\(compareCount)次：与第 \(mid + 1) 位 \(paraArray[mid]) 对比,待查值较小\n"
                findLog.text = temp
                high = mid - 1
            }
        }while(low < high && inPara == -1)
        return inPara
    }
    //--------二分查找算法结束--------
    func buddlingSortA(para : [Int]) -> [Int] {
        var inPara = para
        var i = 0 , j = 1
        for i = 0 ; i < j ; i += 1 {
            for j = i + 1 ; j < inPara.count ; j += 1{
                if inPara[i] > inPara[j]{
                    let temp = inPara[i]
                    inPara[i] = inPara[j]
                    inPara[j] = temp
                }
            }
        }
        return inPara
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
