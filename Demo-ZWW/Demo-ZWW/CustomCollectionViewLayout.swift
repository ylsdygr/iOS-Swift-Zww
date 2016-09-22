//
//  CustomCollectionViewLayout.swift
//  Demo-ZWW
//
//  Created by zww on 9/11/16.
//  Copyright © 2016 zww-organ. All rights reserved.
//

import UIKit

class CustomLayout : UICollectionViewLayout {
    
    //布局前
    override func prepareLayout() {
    }
    //内容区域总大小,不可见
    override func collectionViewContentSize() -> CGSize {
        return CGSizeMake(collectionView!.bounds.size.width,
            CGFloat(collectionView!.numberOfItemsInSection(0) * 200 / 3 + 200))
    }
    
    //所有单元格位置设定
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesArray = [UICollectionViewLayoutAttributes]()
        let totalCells = self.collectionView!.numberOfItemsInSection(0)
        for i in 0..<totalCells {
            
            let indexPath =  NSIndexPath(forItem:i, inSection:0)
            let attributes =  self.layoutAttributesForItemAtIndexPath(indexPath)
            attributesArray.append(attributes!)
        }
        return attributesArray
    }
    
    // 返回每个单元格的位置和大小
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let currentCellAttribute =  UICollectionViewLayoutAttributes(forCellWithIndexPath:indexPath)
        let lineSpacing = 5
        let insets = UIEdgeInsetsMake(2, 2, 2, 2)
        //边长
        let cellHeight:CGFloat = ((collectionView!.bounds.size.width - 2 * insets.left) / 3 * 2)
        let cellLength:CGFloat = ((collectionView!.bounds.size.width - 3 * insets.right) / 3 )
        //当前行数，每行显示3个图片，1大2小
        let line : Int =  Int(indexPath.item / 3)
        //当前行的Y坐标
        let lineOriginY =  cellHeight * CGFloat(line) + CGFloat(lineSpacing * line) + insets.top
        //右侧单元格X坐标，这里按左右对齐，所以中间空隙大
//        let rightLargeX =  collectionView!.bounds.size.width - cellHeight - insets.right
//        let rightSmallX =  collectionView!.bounds.size.width - cellLength - insets.right
        let rightLargeX = cellLength + (insets.left * 2)
        let rightSmallX =  cellHeight + (insets.left * 2)
        // 每行2+1个图片，2行循环一次，一共6种位置
        switch (indexPath.item % 6){
        case 0 : currentCellAttribute.frame = CGRectMake(insets.left, lineOriginY, cellHeight, cellHeight)
        case 1 : currentCellAttribute.frame = CGRectMake(rightSmallX, lineOriginY, cellLength, cellLength)
        case 2 : currentCellAttribute.frame = CGRectMake(rightSmallX, lineOriginY + cellLength + insets.top, cellLength, cellLength)
            
        case 3 : currentCellAttribute.frame = CGRectMake(insets.left, lineOriginY, cellLength, cellLength )
        case 4 : currentCellAttribute.frame = CGRectMake(insets.left, lineOriginY + cellLength + insets.top, cellLength, cellLength)
        default : currentCellAttribute.frame = CGRectMake(rightLargeX, lineOriginY, cellHeight, cellHeight)
        }
        return currentCellAttribute
    }
}

