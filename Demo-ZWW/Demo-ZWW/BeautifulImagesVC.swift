//
//  BeautifulImagesVC.swift
//  Demo-ZWW
//
//  Created by zww on 9/8/16.
//  Copyright © 2016 zww-organ. All rights reserved.
//

import UIKit


class BeautifulImagesVC: UIViewController , UICollectionViewDataSource ,UICollectionViewDelegate {
    
    var showImagesCollectionView : UICollectionView!
    @IBOutlet var uiReloadBTN : UIButton!

    var rectangleImages : [[String]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialCollectionView()
        initialShowData()
        
    }
    func initialCollectionView(){
        uiReloadBTN.setTitle(NSLocalizedString("NSL_UI_BTN_Reload", comment: ""), forState: UIControlState.Normal)
//        let presetlayout = UICollectionViewFlowLayout()
        let presetlayout = CustomLayout()
        showImagesCollectionView = UICollectionView(frame: CGRectMake(0, 45, 375, 573) ,
            collectionViewLayout: presetlayout)
        showImagesCollectionView.registerClass(UICollectionViewCell.self,
            forCellWithReuseIdentifier: "cellIdentifiter")
        showImagesCollectionView.backgroundColor = UIColor(red: 73/255 , green: 190/255, blue: 209/255, alpha: 1.0)
        
        showImagesCollectionView.dataSource = self
        showImagesCollectionView.delegate = self
        self.view.addSubview(showImagesCollectionView)
    }
    func initialShowData(){
        rectangleImages = [[String]]()
        rectangleImages.removeAll()
        let imagesDirPath = NSHomeDirectory() + "/Documents/images"
        let fileManager = NSFileManager.defaultManager()
        let enumerator = fileManager.enumeratorAtPath(imagesDirPath)
        repeat{
            let element = enumerator?.nextObject()
            if (element == nil) {
                break
            }else{
                let fileName : String = String(element!)
                let afterDot : [String] = fileName.componentsSeparatedByString(".")
                var fileType : String!
                for suffix in afterDot {
                    fileType = suffix
                }
                if (fileType == "jpg" || fileType == "jpeg" || fileType == "png"){
                    var imageInformation : [String] = [String]()
                    imageInformation.append(fileName)
                    imageInformation.append(fileType)
                    rectangleImages.append(imageInformation)
                }
            }
//获取文件相关属性,如对文件大小的过滤
//            do{    let attributes = try fileManager.attributesOfItemAtPath(imagesDirPath + "/\(element!)")
//                print(attributes) }catch{  }
            
        }while(true)
    }
    @IBAction func reloadData(){
  //      showImagesCollectionView.
        rectangleImages.removeAll()
        initialShowData()
        showImagesCollectionView.reloadData()
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (rectangleImages.count == 0){
            let alert = UIAlertController(title: NSLocalizedString("NSL_UIDirectionNotice", comment: ""),
                message: NSLocalizedString("NSL_AlertMessage_NoData", comment: ""),
                preferredStyle: UIAlertControllerStyle.Alert)
            let okButton = UIAlertAction(title: NSLocalizedString("NSL_AlertIKnow", comment: ""), style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(okButton)
            self.presentViewController(alert, animated: true, completion: nil)
            return 0
        }
        return rectangleImages.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellID : String = "cellIdentifiter"
        var collectionCell : UICollectionViewCell? = showImagesCollectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath)
        if (collectionCell == nil){
            
            collectionCell = UICollectionViewCell()
            
            let imagePath = NSHomeDirectory() + "/Documents/images/" + rectangleImages[indexPath.item][0]
            let imageView = UIImageView(image: UIImage(contentsOfFile: imagePath))
            imageView.frame = (collectionCell?.bounds)!
            collectionCell?.addSubview(imageView)
            
        }else{
            let imagePath = NSHomeDirectory() + "/Documents/images/" + rectangleImages[indexPath.item][0]
            let imageView = UIImageView(image: UIImage(contentsOfFile: imagePath))
            imageView.frame = (collectionCell?.bounds)!
            collectionCell?.addSubview(imageView)
        }
        return collectionCell!
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
