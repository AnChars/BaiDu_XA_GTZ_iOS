//
//  DHViewController.swift
//  BaiduGuoTingZhenXiAN
//
//  Created by AnChar on 16/9/23.
//  Copyright © 2016年 GG. All rights reserved.
//

import UIKit

class DHViewController: UIViewController {

    let k = UIScreen.mainScreen().bounds.width
    let h = UIScreen.mainScreen().bounds.width
    var okButton : UIButton?
    var backButton:UIButton?
    lazy var dataArray = [String]()
    var tableView:UITableView?
    var subview:UIView?
    lazy var ptLiat = [NSValue]()
    var search : BMKSuggestionSearch?
    var op : BMKSuggestionSearchOption?
    var customSearchBar1:UITextField?
    var customSearchBar2:UITextField?
    var x:(Double,Double) = (0.01,0.01)
    var y:(Double,Double) = (0.01,0.01)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.search=BMKSuggestionSearch()
        self.op = BMKSuggestionSearchOption()
        self.search!.delegate=self
        self.subview = UIView(frame: CGRectMake(0, 114, k, h))
        
        self.view.backgroundColor=UIColor.whiteColor()
        let title = ["🚌","🚘","🚶"]
        let seg = UISegmentedControl(items: title)
        seg.frame = CGRectMake(0, 64, k, 50)
        seg.addTarget(self, action: #selector(segAcion(_:)), forControlEvents: .ValueChanged)
        seg.selectedSegmentIndex = 2
        seg.backgroundColor=UIColor.whiteColor()
        self.view.addSubview(seg)
        
        let label1 = UILabel(frame: CGRectMake(20, 250, (k-30)/3, 50))
        label1.text = "出发地:"
        self.view.addSubview(label1)
        let label2 = UILabel(frame: CGRectMake(20, 350, (k-30)/3, 50))
        label2.text = "目的地:"
        self.view.addSubview(label2)
        self.customSearchBar1 = self.customSearchBar(CGRectMake(20+(k-30)/3, 250, (k-30)*2/3, 50), string: "icon_nav_start@2x.png")
        customSearchBar1!.delegate=self
        self.view.addSubview(customSearchBar1!)
        
        customSearchBar2 = self.customSearchBar(CGRectMake(20+(k-30)/3, 350, (k-30)*2/3, 50), string: "icon_nav_end@2x.png")
        customSearchBar2!.delegate=self
        self.view.addSubview(customSearchBar2!)
        
        self.okButton=UIButton(type: .System)
        self.okButton?.frame=CGRectMake(207, 500, 200, 50)
        self.okButton?.setTitle("规划路线", forState:.Normal)
        self.okButton?.addTarget(self, action: #selector(okButtonAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(self.okButton!)
        self.backButton=UIButton(type: .System)
        self.backButton?.frame=CGRectMake(7, 500, 200, 50)
        self.backButton?.setTitle("返回地图", forState:.Normal)
        self.backButton?.addTarget(self, action: #selector(backButtonAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(self.backButton!)
    }
    
    func perpareTableView(frame:CGRect){
        self.tableView=UITableView(frame: frame, style: .Plain)
        self.tableView?.delegate=self
        self.tableView?.dataSource=self
        if self.subview != nil {
            self.view!.addSubview(self.tableView!)
        }
    }

    func backButtonAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func okButtonAction(){
        if self.customSearchBar1?.text != "" && self.customSearchBar2?.text != ""{
            if self.customSearchBar2?.text != self.customSearchBar1?.text{
                NSNotificationCenter.defaultCenter().postNotificationName("导航", object: nil, userInfo: [self.x.0:self.x.1,self.y.0:self.y.1])
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    func customSearchBar(frame:CGRect,string:String)->UITextField{
        let customSearchBar = UITextField()
        customSearchBar.frame=frame
        customSearchBar.rightView=UIImageView(image: UIImage(named: string))
        customSearchBar.autocorrectionType = .No
        customSearchBar.autocapitalizationType = .None
        customSearchBar.borderStyle = .RoundedRect
        customSearchBar.rightViewMode = .Always
        customSearchBar.clearsOnBeginEditing = true
        return customSearchBar
    }
    
    func segAcion(seg:UISegmentedControl){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissSubView(){
        if self.subview != nil {
            self.tableView?.removeFromSuperview()
            self.view.frame.origin.y = 0
        }
    }
    
}


extension DHViewController : UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        
        self.dataArray.removeAll()
        self.ptLiat.removeAll()
        self.dataArray.append("我的位置")
        self.tableView?.reloadData()
        self.ptLiat.append(NSValue(CGPoint: CGPointMake(0.01, 0.01)))
        textField.text = ""
        if textField == self.customSearchBar1{
            self.view.frame.origin.y = -190
//            self.view.addSubview(subview!)
            self.perpareTableView(CGRectMake(0, 290, 414, 736))
        }else if textField == self.customSearchBar2{
            self.view.frame.origin.y = -290
            self.perpareTableView(CGRectMake(0, 390, 414, 736))
        }
        return true
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
            if textField.text != ""{
                op?.keyword = textField.text
                self.search?.suggestionSearch(op)
                self.dataArray.removeAll()
                self.ptLiat.removeAll()
            }
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
       
        if textField.text != ""{
            op?.keyword = textField.text
            self.search?.suggestionSearch(op)
            self.dataArray.removeAll()
            self.ptLiat.removeAll()
        }
        textField.resignFirstResponder()
        return true
    }
}
extension DHViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView?.dequeueReusableCellWithIdentifier("cell")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = self.dataArray[indexPath.row]
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.view.frame.origin.y > -250 {
            self.customSearchBar1?.text = self.dataArray[indexPath.row]
            self.customSearchBar1?.resignFirstResponder()
            self.x.0 = Double((self.ptLiat[indexPath.row].CGPointValue()).x)
            self.y.0 = Double((self.ptLiat[indexPath.row].CGPointValue()).y)
        }else{
            self.customSearchBar2?.text = self.dataArray[indexPath.row]
            self.customSearchBar2?.resignFirstResponder()
            self.x.1 = Double((self.ptLiat[indexPath.row].CGPointValue()).x)
            self.y.1 = Double((self.ptLiat[indexPath.row].CGPointValue()).y)
        }
        self.dismissSubView()
    }
}
extension DHViewController : BMKSuggestionSearchDelegate{
    func onGetSuggestionResult(searcher: BMKSuggestionSearch!, result: BMKSuggestionResult!, errorCode error: BMKSearchErrorCode) {
        if BMK_SEARCH_NO_ERROR == error {
            
            for i in 0..<result.cityList.count{
                let str = (result.cityList[i] as! String) + (result.districtList[i] as! String)+(result.keyList[i]as!String)
                self.dataArray.append(str)
                self.ptLiat.append(result.ptList[i] as! NSValue)
            }
            self.tableView?.reloadData()
        }else{
            print("未找到")
        }
    }
}
