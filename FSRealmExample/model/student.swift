//
//  student.swift
//  realm
//
//  Created by fengsh998 on 2020/8/14.
//  Copyright © 2020 fengsh998. All rights reserved.
//

import UIKit
import RealmSwift
/*
  V0 版本
 */
/*
class Student: Object {

    @objc dynamic var id = 0
    @objc dynamic var name:String = ""
    @objc dynamic var age: Int = 28
    @objc dynamic var desc:String = "a man"
    
    /// 主键
    ///
    /// - Returns: 增删改查只要依赖对象
    override static func primaryKey() -> String? {
        return "id"
    }
}
*/
/*
  V1 版本
  新增sex字段，默认值设置为1
 */
/*
class Student: Object {

    @objc dynamic var id = 0
    @objc dynamic var name:String = ""
    @objc dynamic var age: Int = 28
    @objc dynamic var sex: Int = 1
    @objc dynamic var desc:String = "a man"
    
    /// 主键
    ///
    /// - Returns: 增删改查只要依赖对象
    override static func primaryKey() -> String? {
        return "id"
    }
}
*/
/*
  V2 版本
  新增 grade 属性
 */
/*
class Student: Object {

    @objc dynamic var id = 0
    @objc dynamic var name:String = ""
    @objc dynamic var age: Int = 28
    @objc dynamic var sex: Int = 1
    @objc dynamic var grade: Int = 5
    @objc dynamic var desc:String = "a man"
    
    /// 主键
    ///
    /// - Returns: 增删改查只要依赖对象
    override static func primaryKey() -> String? {
        return "id"
    }
}
*/

/*
  V3 版本
  修改 grade 属性为 level,
  修改 desc 的默认址为 a good
  删除 age属性
 */
/*
class Student: Object {

    @objc dynamic var id = 0
    @objc dynamic var name:String = ""
    @objc dynamic var sex: Int = 1
    @objc dynamic var level: Int = 0
    @objc dynamic var desc:String = "a good"
    
    /// 主键
    ///
    /// - Returns: 增删改查只要依赖对象
    override static func primaryKey() -> String? {
        return "id"
    }
}
*/

/*
  V4 版本
  添加索引
 */

class Student: Object {

    @objc dynamic var id = 0
    @objc dynamic var name:String = ""
    @objc dynamic var sex: Int = 1
    @objc dynamic var level: Int = 0
    @objc dynamic var desc:String = "a good"
    
    /// 主键
    ///
    /// - Returns: 增删改查只要依赖对象
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["name"]
    }
}


