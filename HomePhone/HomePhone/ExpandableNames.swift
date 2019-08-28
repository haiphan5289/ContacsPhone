//
//  ExpandableNames.swift
//  HomePhone
//
//  Created by HaiPhan on 8/27/19.
//  Copyright © 2019 HaiPhan. All rights reserved.
//

import Foundation

struct ExpandableNames {
    var isExpand: Bool
    var names: [Contact]
}

//tạo 1 struct
//để kiểm tra xem Contact đó có đang bật Favorite
struct Contact {
    var name: String
    var hasFavorite: Bool
}
