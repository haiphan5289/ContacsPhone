//
//  ExpandableNames.swift
//  HomePhone
//
//  Created by HaiPhan on 8/27/19.
//  Copyright © 2019 HaiPhan. All rights reserved.
//

import Foundation
import Contacts

struct ExpandableNames {
    var isExpand: Bool
    var names: [FavoritesContact]
}

//tạo 1 struct
//để kiểm tra xem Contact đó có đang bật Favorite
struct FavoritesContact {
    //tạo biên name là contact
    //để chứa dữ liệu contact từ device trả về 
    var name: CNContact
    var hasFavorite: Bool
}
