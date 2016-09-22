//
//  IterativeCalcVC.swift
//  Demo-ZWW
//
//  Created by zww on 9/8/16.
//  Copyright © 2016 zww-organ. All rights reserved.
//

import UIKit

class IterativeCalcVC: UIViewController , UITableViewDataSource , UITableViewDelegate {
//    @IBOutlet var everyDayMoreEat : UITextField!

    let DEFINE_eatDays : Int = 10
    var totalPeaches : Int = 0
    @IBOutlet var resultPeaches : UILabel!
    @IBOutlet var needsDaysToEat : UITextField!
    
    var showTableView : UITableView!
    var history : [[String]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initialUIBindControllers()
        calcDependOnInput()
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    //初始化绑定控件
    func initialUIBindControllers(){
//        everyDayMoreEat.text = "1"
        history = [[String]]()
        resultPeaches.textAlignment = .Center
        needsDaysToEat.text = "10"
        showTableView = UITableView(frame: CGRectMake(0, 310, 370, 320), style: UITableViewStyle.Plain)
        
        showTableView.delegate = self
        showTableView.dataSource = self
        self.view.addSubview(showTableView)

    }
    //表格中包含的组
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //表格中每组所包含的单元格
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    //表格内容填充
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID = "cellIdentifier"
        var cell : UITableViewCell? = showTableView.dequeueReusableCellWithIdentifier(cellID)
        if (cell == nil ){
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellID)
            cell?.textLabel?.font = UIFont.systemFontOfSize(18)
            cell?.selectionStyle = .Gray
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell?.textLabel?.text = history[indexPath.row][0]
            cell?.detailTextLabel?.text = history[indexPath.row][1]
        }
        else if (cell != nil){
            cell?.textLabel?.font = UIFont.systemFontOfSize(18)
            cell?.selectionStyle = .Gray
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell?.textLabel?.text = history[indexPath.row][0]
            cell?.detailTextLabel?.text = history[indexPath.row][1]
        }
        return cell!
    }
    //选定某单元格后响应事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        var ICVC = IterativeCalcVC()
//        self.navigationController?.pushViewController(ICVC, animated: true)
//　添加界面用于显示当天数过多时数值较大的情况
        let reportAlert = UIAlertController(title: "提示", message: "\(history[indexPath.row][1])", preferredStyle: UIAlertControllerStyle.Alert)
        let okButton = UIAlertAction(title: "知道了", style: UIAlertActionStyle.Default, handler: nil)
        reportAlert.addAction(okButton)
        self.presentViewController(reportAlert, animated: true, completion: nil)
    }
    //自定天数重新计算事件
    @IBAction func calcDependOnInput(){
//        let paraEveryDayMoreEat : Int = stringToInt(everyDayMoreEat.text!)
        let paraNeedsDaysToEat : Int = stringToInt(needsDaysToEat.text!)
        totalPeaches = iterativeCalc(paraNeedsDaysToEat)
        resultPeaches.text = "第一天共有\(totalPeaches)个桃子"
        
        //正向计算并输出桃数历史,使用表格来记录历史存量
        history.removeAll()
        var leftPeaches = totalPeaches
        var dayCount : Int = 0
        while(dayCount < paraNeedsDaysToEat){
            let eatedPeaches = leftPeaches / 2 + 1
            leftPeaches -= eatedPeaches
            dayCount += 1
            var element : [String] = [String]()
            element.append("第 \(dayCount) 天")
            element.append("吃了 \(eatedPeaches) 桃,剩下 \(leftPeaches) 桃")
            history.append(element)
        }
        showTableView.reloadData()
    }
    //逆向迭代计算总数量
    func iterativeCalc(eatedDays : Int) -> Int {
        var total : Int = 1
        var days  = eatedDays
        while(days >= 1){
            total = (total + 1) * 2
            days -= 1
        }
        return total
    }
    //字符串转为整形
    func stringToInt(para : String) -> Int {
        var value : Int = 0
        for character in para.characters{
            value *= 10
            switch character{
            case "0" :
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
            default :
                let nilAlert = UIAlertController(title: "错误", message: "输入错误,天数只能为整数",
                preferredStyle: .Alert)
                let okButton = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
                nilAlert.addAction(okButton)
                self.presentViewController(nilAlert, animated: true, completion: nil)
                self.needsDaysToEat.text = "10"
            }
        }
        if (value == 0){
            return 0
        }
        return value
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
