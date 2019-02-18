//
//  Task.swift
//  taskapp
//
//  Created by ふるふる on 2019/02/18.
//  Copyright © 2019 Tsuyoshi Furuhata. All rights reserved.
//

import RealmSwift

class Task: Object{
    //管理用 ID,プライマルキー
    @objc dynamic var id = 0
    
    //タイトル
    @objc dynamic var title = ""
    
    //内容
    @objc dynamic var contents = ""
    
    //日時
    @objc dynamic var date = Date()
    
    /**
     id をプライマルキーとして設定
    */
    override static func primaryKey() -> String?
    {
        return "id"
    }
}
