//
//  ContactCell.swift
//  HomePhone
//
//  Created by HaiPhan on 8/28/19.
//  Copyright © 2019 HaiPhan. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    var viewController: ViewController?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    func setupViews(){
        let bt = UIButton(type: .system)
        bt.setImage(UIImage(named: "star"), for: .normal)
        bt.tintColor = .lightGray
        bt.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        bt.addTarget(self, action: #selector(handleFavorite), for: .touchUpInside)
        //xác định frame của bt bên phải
        self.accessoryView = bt
    }
    
    @objc func handleFavorite(){
        //đá về metho của vc
        viewController?.MethodCheckFavoriteWhenClick(cell: self)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
