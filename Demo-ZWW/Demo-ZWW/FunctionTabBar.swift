//
//  FunctionTabBar.swift
//  Demo-ZWW
//
//  Created by zww on 9/8/16.
//  Copyright © 2016 zww-organ. All rights reserved.
//

import UIKit

class FunctionTabBar: UITabBarController {
    
    var BA : BasicArithmeticVC!
    var ML : MapLocationVC!
    var BI : BeautifulImagesVC!
    var WV : WebViewVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialTabBar()
    }
    func initialTabBar(){
        BA = BasicArithmeticVC()
        let itemBA : UITabBarItem = UITabBarItem(title: NSLocalizedString("NSL_mainPage0", comment: "我对基础的算法理解"),
            image: UIImage(named: "HomeC"), selectedImage: UIImage(named: "HomeG"))
//        itemBA.imageInsets = UIEdgeInsets(top: 1, left: 1, bottom: -1, right: 1)
//        BA.tabBarItem = itemBA  //不添加UINavigationController时使用
        let UINCBA = UINavigationController(rootViewController: BA)
        UINCBA.tabBarItem = itemBA
        //UICBA.tabBarItem.image = UIImage(named: "HomeC40")
        
        ML = MapLocationVC()
        let itemML : UITabBarItem = UITabBarItem(title: NSLocalizedString("NSL_mainPage1", comment: "GPS定位功能地使用"),
            image: UIImage(named: "MapC"), selectedImage: UIImage(named: "MapG"))
        ML.tabBarItem = itemML
        
        BI = BeautifulImagesVC()
        let itemBI : UITabBarItem = UITabBarItem(title: NSLocalizedString("NSL_mainPage2", comment: "UICollectionView"), image: UIImage(named: "ImageC"), selectedImage: UIImage(named: "ImageG"))
        BI.tabBarItem = itemBI
        
        WV = WebViewVC()
        let itemWV : UITabBarItem = UITabBarItem(title: "Web",
            image: UIImage(named: "WebC"), selectedImage: UIImage(named: "WebG"))
        let UINCWV = UINavigationController(rootViewController: WV)
        UINCWV.tabBarItem = itemWV
        
        let itemArray = [UINCBA,ML,BI,UINCWV]
        self.viewControllers = itemArray
        self.tabBar.tintColor = UIColor.orangeColor()
        self.selectedIndex = 0
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
