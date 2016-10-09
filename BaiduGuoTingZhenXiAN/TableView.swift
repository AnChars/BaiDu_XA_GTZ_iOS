//
//  TableView.swift
//  BaiDu_XA_GTZ_iOS
//
//  Created by AnChar on 16/9/22.
//  Copyright © 2016年 GG. All rights reserved.
//

import UIKit

class TableView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRectMake(0, 64, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        self.backgroundColor=UIColor.whiteColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
