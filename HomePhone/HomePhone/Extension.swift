//
//  Extension.swift
//  HomePhone
//
//  Created by HaiPhan on 8/26/19.
//  Copyright © 2019 HaiPhan. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

extension UIViewController {
    
    //setup & Config Navigaiton
    func SetUpNavigation(text: String){
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = text
    }
    
    //setup & Config Right Button
    func RightButtonSetup() -> UIButton {
        let bt = UIButton(type: .system)
        bt.setTitle("Reload Index Path", for: .normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: bt)
        return bt
    }
}
