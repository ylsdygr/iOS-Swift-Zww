//
//  MapLocationVC.swift
//  Demo-ZWW
//
//  Created by zww on 9/8/16.
//  Copyright © 2016 zww-organ. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

//地图标记点类
class SLocation{
    private var Country : String!
    private var Province : String!
    private var PlaceName : String!
    private var Location : CLLocation!
    init(country : String , province : String , placename : String , location : CLLocation){
        Country = country
        Province = province
        PlaceName = placename
        Location = location
    }
}

class MapLocationVC: UIViewController , MKMapViewDelegate , CLLocationManagerDelegate , UITextFieldDelegate {
    
    var uiLongitude : UILabel!
    var uiLatitude : UILabel!
    var uiAltitude : UILabel!
    var uiDirection : UILabel!
    
    var uiLongitudeTF : UITextField!
    var uiLatitudeTF : UITextField!
    var uiAltitudeTF : UITextField!
    var uiDirectionTF : UITextField!
    
    var uiStartBTN : UIButton!
    var uiStopBTN : UIButton!
    var showResetBTN : UIButton!
    var uiShowPresetBTN : UIButton!
    
    var uiMapView : MKMapView!
    var lmLocationManager : CLLocationManager!
    
    var myLocations : [SLocation] = [SLocation]()
    var isOpenOrClose : Int = 0
    var inputNotice : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialUIInterface()
        initialOriginalData()
        addButtonsEvent()
        startButtonEvent()
    }
    //初始化预置地图标记点
    func initialOriginalData(){
        myLocations = [SLocation(country: "中国",province: "北京",placename: "故宫",location:
            CLLocation(latitude: 39.915096 , longitude: 116.392148)),
            SLocation(country: "中国",province: "北京",placename: "国家大剧院",location:
                CLLocation(latitude: 39.902779 , longitude: 116.384000)),
            SLocation(country: "中国",province: "北京",placename: "人民大会堂",location:
                CLLocation(latitude: 39.902974 , longitude: 116.388000)),
            SLocation(country: "中国",province: "北京",placename: "国家博物馆",location:
                CLLocation(latitude: 39.904052 , longitude: 116.395581)),
        ]

    }
    //界面绑定控件初始化
    func initialUIInterface(){
        
        uiLongitude = UILabel(frame: CGRectMake(15,40,50,20))
        uiLongitude.text = NSLocalizedString("NSL_UILongitude", comment: "")
        self.view.addSubview(uiLongitude)
        
        uiLatitude = UILabel(frame: CGRectMake(15,70,50,20))
        uiLatitude.text = NSLocalizedString("NSL_UILatitude", comment: "")
        self.view.addSubview(uiLatitude)
        
        uiAltitude = UILabel(frame: CGRectMake(15,100,50,20))
        uiAltitude.text = NSLocalizedString("NSL_UIAltitude", comment: "")
        self.view.addSubview(uiAltitude)
        
        uiDirection = UILabel(frame: CGRectMake(15,130,50,20))
        uiDirection.text = NSLocalizedString("NSL_UIDirection", comment: "")
        self.view.addSubview(uiDirection)
        
        uiLongitudeTF = UITextField(frame: CGRectMake(75,40,150,20))
        uiLongitudeTF.placeholder = "可输入自定经度"
//        uiLongitudeTF.backgroundColor = UIColor.grayColor()
        self.view.addSubview(uiLongitudeTF)
        uiLongitudeTF.delegate = self
        
        uiLatitudeTF = UITextField(frame: CGRectMake(75,70,150,20))
        uiLatitudeTF.placeholder = "可输入自定纬度"
        self.view.addSubview(uiLatitudeTF)
        
        uiAltitudeTF = UITextField(frame: CGRectMake(75,100,150,20))
        uiAltitudeTF.placeholder = "启动后的定位海拔"
        self.view.addSubview(uiAltitudeTF)
        
        uiDirectionTF = UITextField(frame: CGRectMake(75,130,150,20))
        uiDirectionTF.placeholder = "暂时无法显示方向"
        self.view.addSubview(uiDirectionTF)
        
        uiStartBTN = UIButton(frame: CGRectMake(265,40,50,20))
        uiStartBTN.setTitle(NSLocalizedString("NSL_LocationStart", comment: ""), forState: UIControlState.Normal)
        uiStartBTN.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.view.addSubview(uiStartBTN)
        
        uiStopBTN = UIButton(frame: CGRectMake(265,70,50,20))
        uiStopBTN.setTitle(NSLocalizedString("NSL_LocationStop", comment: ""), forState: UIControlState.Normal)
        uiStopBTN.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.view.addSubview(uiStopBTN)
        
        uiShowPresetBTN = UIButton(frame: CGRectMake(235,100,110,20))
        uiShowPresetBTN.setTitle(NSLocalizedString("NSL_UIShowPresetBTN", comment: ""), forState: UIControlState.Normal)
        uiShowPresetBTN.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.view.addSubview(uiShowPresetBTN)
        
        showResetBTN = UIButton(frame: CGRectMake(235,130,110,20))
        showResetBTN.setTitle(NSLocalizedString("NSL_UIShowResetBTN", comment: ""), forState: UIControlState.Normal)
        showResetBTN.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.view.addSubview(showResetBTN)
        
    }
    //按钮事件添加
    func addButtonsEvent(){
        uiStartBTN.addTarget(self, action: "startButtonEvent", forControlEvents: UIControlEvents.TouchUpInside)
        uiStopBTN.addTarget(self, action: "stopButtonEvent", forControlEvents: UIControlEvents.TouchUpInside)
        uiShowPresetBTN.addTarget(self, action: "showPresetBTNEvent", forControlEvents: UIControlEvents.TouchUpInside)
        showResetBTN.addTarget(self, action: "readAndShowLocationFromUIEvent", forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    //启动按钮的事件响应
    func startButtonEvent(){
        if (isOpenOrClose % 2 == 1){
            uiDirection.text = NSLocalizedString("NSL_UIDirectionNotice", comment: "")
            uiDirectionTF.text = "无需重复开启服务"
            return
        }
        lmLocationManager = CLLocationManager()
        lmLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        lmLocationManager.requestWhenInUseAuthorization()
        lmLocationManager.distanceFilter = 1
        lmLocationManager.delegate = self
        lmLocationManager.startUpdatingLocation()
        uiDirection.text = NSLocalizedString("NSL_UIDirectionNotice", comment: "")
        uiDirectionTF.text = "已开启位置更新"
        uiDirectionTF.textColor = UIColor.redColor()
        isOpenOrClose += 1
    }
    //位置访问授权变更响应
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.NotDetermined){
            lmLocationManager.requestAlwaysAuthorization()
        }
        if (status == CLAuthorizationStatus.Denied ){
            let nilAlert = UIAlertController(title: NSLocalizedString("NSL_AlertLocaionLimited", comment: "")
                , message: "请前往设置中心修改", preferredStyle: .Alert)
            let okButton = UIAlertAction(title: NSLocalizedString("NSL_AlertIKnow", comment: "")
                , style: UIAlertActionStyle.Default, handler: nil)
            nilAlert.addAction(okButton)
            self.presentViewController(nilAlert, animated: true, completion: nil)
        }
    }
    //位置更新响应动作
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last
        uiLongitudeTF.text = "\(currentLocation!.coordinate.longitude)"
        uiLatitudeTF.text = "\(currentLocation!.coordinate.latitude)"
        uiAltitudeTF.text = "\(currentLocation!.altitude)"
        readAndShowLocationFromUIEvent()
    }
    //停止位置更新服务
    func stopButtonEvent(){
        if (isOpenOrClose % 2 == 0){
            uiDirection.text = NSLocalizedString("NSL_UIDirectionNotice", comment: "")
            uiDirectionTF.text = "无需重复停止服务"
            uiDirectionTF.textColor = UIColor.redColor()
            return
        }
        lmLocationManager.stopUpdatingLocation()
        uiDirectionTF.text = "已停止位置更新"
        isOpenOrClose -= 1
        //延时2秒后恢复提示框为方向框
        let workingQueue = dispatch_queue_create("my_queue", nil)
        dispatch_async(workingQueue){
            NSThread.sleepForTimeInterval(2)
            dispatch_async(dispatch_get_main_queue()){
                self.uiDirectionTF.text = ""
                self.uiDirection.text = NSLocalizedString("NSL_UIDirection", comment: "")
                self.uiDirectionTF.textColor = UIColor.blackColor()
                self.uiLongitudeTF.text = ""
                self.uiLatitudeTF.text = ""
                self.uiAltitudeTF.text = ""
                //先销毁之前有可能已经创建的地图控件
                if (self.uiMapView != nil){
                    self.uiMapView = nil
                }
            }
        }
    }
    //显示预设位置按钮响应
    func showPresetBTNEvent(){
        if (self.uiMapView == nil){
            uiMapView = MKMapView(frame: CGRectMake(0,155,UIScreen.mainScreen().bounds.width,460))
        }
        let longDelta = 0.05 , latDelta = 0.05
        let currentLocationSpan : MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        let TianAnMenLocation : CLLocation = CLLocation(latitude: 39.908712 , longitude: 116.397477)
        let TianAnMenRegion : MKCoordinateRegion = MKCoordinateRegionMake(TianAnMenLocation.coordinate, currentLocationSpan)
        uiMapView.mapType = .Standard
        uiMapView.setRegion(TianAnMenRegion, animated: true)
        //添加定位点标记
        for instance in myLocations {
            let instanceAnnotation = MKPointAnnotation()
            instanceAnnotation.coordinate = instance.Location.coordinate
            instanceAnnotation.title = "\(instance.Country),\(instance.Province)"
            instanceAnnotation.subtitle = instance.PlaceName
            uiMapView.addAnnotation(instanceAnnotation)
        }
        
        self.view.addSubview(uiMapView)
        uiMapView.delegate = self
    }
    //地图区域及信息变更响应
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        uiDirectionTF.text = NSLocalizedString("NSL_MapViewHasChanged", comment: "")
    }
    //显示界面上设定的定位地图
    func readAndShowLocationFromUIEvent(){
        if (self.uiMapView == nil){
            uiMapView = MKMapView(frame: CGRectMake(0,155,UIScreen.mainScreen().bounds.width,UIScreen.mainScreen().bounds.height * 0.689))
        }
        if (uiLatitudeTF.text == "" || uiLongitudeTF == "" ){
            let NilNotice = UIAlertController(title: NSLocalizedString("NSL_AlertError", comment: "")
                , message: NSLocalizedString("NSL_AlertMessagePICLC", comment: ""), preferredStyle: .Alert)
            let okButton = UIAlertAction(title: NSLocalizedString("NSL_AlertIKnow", comment: "")
                , style: .Default , handler: nil)
            NilNotice.addAction(okButton)
            self.presentViewController(NilNotice, animated: true, completion: nil)
            uiLongitudeTF.text = ""
            uiLatitudeTF.text = ""
            return
        }
        let uiReadLatitude = Double(uiLatitudeTF.text!)
        let uiReadLongitude = Double(uiLongitudeTF.text!)
        let longDelta = 0.05 , latDelta = 0.05
        let currentLocationSpan : MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        let defineLocation : CLLocation! = CLLocation(latitude: uiReadLatitude! , longitude: uiReadLongitude!)
        let defineRegion : MKCoordinateRegion = MKCoordinateRegionMake(defineLocation.coordinate, currentLocationSpan)
        uiMapView.mapType = .Standard
        uiMapView.setRegion(defineRegion, animated: true)
        //添加界面输入位置
        let instanceAnnotation = MKPointAnnotation()
        instanceAnnotation.coordinate = defineLocation.coordinate
        if (instanceAnnotation.coordinate.longitude == -122.406417 && instanceAnnotation.coordinate.latitude == 37.785834){
            instanceAnnotation.title = "美国,加利福尼亚州"
            instanceAnnotation.subtitle = "旧金山市,CB2"
        }else{
            instanceAnnotation.title = "未知位置"
            instanceAnnotation.subtitle = "暂时未增加地址解析"
        }
        uiMapView.addAnnotation(instanceAnnotation)
        self.view.addSubview(uiMapView)
        uiMapView.delegate = self
    }
    //UITextField输入坐标格式提示
    func textFieldDidBeginEditing(textField: UITextField) {
        if (inputNotice == 0){
            let NilNotice = UIAlertController(title: NSLocalizedString("NSL_AlertCoordinateNotice", comment: "")
                , message: NSLocalizedString("NSL_AlertMessageCoordinate", comment: ""), preferredStyle: .Alert)
            let okButton = UIAlertAction(title: NSLocalizedString("NSL_AlertIKnow", comment: "")
                , style: .Default , handler: nil)
            NilNotice.addAction(okButton)
            self.presentViewController(NilNotice, animated: true, completion: nil)
            inputNotice = 1
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
