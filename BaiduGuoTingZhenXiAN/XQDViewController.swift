//
//  XQDViewController.swift
//  BaiduGuoTingZhenXiAN
//
//  Created by AnChar on 16/9/27.
//  Copyright © 2016年 GG. All rights reserved.
//

import UIKit

class XQDViewController: UIViewController {

    let w = UIScreen.mainScreen().bounds.width
    let h = UIScreen.mainScreen().bounds.height
    var collection : UICollectionView?
    private lazy var dataArray = ["小吃","酒店","旅游","书店","超市","网吧","酒吧","KTV","肯德基","车站","小吃","小吃","小吃","小吃","小吃","小吃",]
    private lazy var nameArray = ["pin_green@2x","pin_purple@2x","pin_red@2x"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.whiteColor()
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 30
        layout.minimumLineSpacing = 30
        layout.sectionInset = UIEdgeInsetsMake(30, 30, 30, 30)
        layout.itemSize = CGSizeMake(80, 100)
        self.collection=UICollectionView(frame: CGRectMake(100, 0, w-200, h), collectionViewLayout: layout)
        self.view.addSubview(self.collection!)
        self.collection?.registerNib(UINib(nibName: "XQDCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        self.collection?.backgroundColor=UIColor.whiteColor()
        self.collection?.delegate=self
        self.collection?.dataSource=self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension XQDViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collection?.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)as! XQDCollectionViewCell
        cell.namLable.text=self.dataArray[indexPath.row]
        cell.nameImageView.image=UIImage(named: self.nameArray[indexPath.row%3])
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        NSNotificationCenter.defaultCenter().postNotificationName("搜周边", object: nil, userInfo: ["keyword":self.dataArray[indexPath.row]])
        self.navigationController?.popViewControllerAnimated(true)
    }
}