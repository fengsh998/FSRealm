//
//  ViewController.swift
//  FSRealmExample
//
//  Created by fengsh998 on 2020/8/15.
//  Copyright © 2020 fengsh998. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.testDeleteFile()
        self.testUpdateDatabase()
        print("---------------------------------数据库操作---------------------------------")
        self.testOpt()
    }
    
    func testDeleteFile() {
        var url = FSRealmEngine.realm_url
        print("url = \(url!)")
        url = url?.deletingLastPathComponent()
        url = url?.appendingPathComponent("RMDemo.realm")
        print("url = \(String(describing: url))")
        let ok = FSRealmManager.rm_delRealmFiles(file: url)
        print("删除了？\(ok)")
    }
    
    func testUpdateDatabase() {
        FSRealmManager.rm_initRealmConfig(dbname: "RMDemo", currentVersion: 4, key: "fsh.db") { (mt, oldversion) in
            print("上一版本号:\(oldversion)")
            if (oldversion < 1) {
               print("升级至V1")
               ///给新增的属性设置默认值
               mt.enumerateObjects(ofType: Student.className()) { (oldobj, newobj) in
                   newobj!["sex"] = 0
               }
            }

            if (oldversion < 2) { ///新增 grade 属性啥也不需要做
               print("升级至V2")
            }

            if (oldversion < 3) {
                /*
                 修改 grade 属性为 level,
                 修改 desc 的默认址为 a good
                 删除 age属性
                 */
                print("升级至V3")
                mt.renameProperty(onType: Student.className(), from: "grade", to: "level")

            }

            if (oldversion < 4) { ///添加索引啥也不需要做
                print("升级至V4")
            }
        }
        
        print("数据库:\(FSRealmManager.engines)")
        
        let arr = FSRealmManager.engines["fsh.db"]?.rm_query(object: Student.self)
        print("Array is \(String(describing: arr))")
        let aa = NSPredicate.init(format: "level = 5", argumentArray: nil)
        let array = FSRealmManager.engines["fsh.db"]?.rm_queryWithPredicate(object: Student.self, predicate: aa)
        print("Array techs \(String(describing: array))")
    }
    
    func testOpt() {
        FSRealmManager.engines["fsh.db"]?.rm_deleteAll()
        
        let s = Student()
        s.id = 99
        s.name = "张三"
        ///添加一条
        FSRealmManager.engines["fsh.db"]?.rm_add(object: s)
        
        let s1 = Student()
        s1.id = 100;
        s1.name = "李四"
        
        let s2 = Student()
        s2.id = 101;
        s2.name = "王五"
        ///添加多条
        FSRealmManager.engines["fsh.db"]?.rm_addList(objects: [s1,s2])
        
        ///查询
        let students = FSRealmManager.engines["fsh.db"]?.rm_query(object: Student.self)
        print("Students is \(String(describing: students))")
        
        let first = students?[0] as! Student
        let newfirst = Student()
        newfirst.id = first.id     //修改时必须要带主键
        newfirst.name = "李嘉诚"
        ///更新
        FSRealmManager.engines["fsh.db"]?.rm_update(object: newfirst)
        
        ///按条件查询
        let founds = FSRealmManager.engines["fsh.db"]?.rm_queryWithPredicate(object: Student.self, predicate: NSPredicate(format: "id = 99"))
        print("Students id 99 is : \(String(describing: founds))")
        
        ///直接在事条中对查询出来的数据更新
        FSRealmManager.engines["fsh.db"]?.rm_updateByTranstion(action: { (isSave) in
            first.level = 500
        })
        
        let ups = FSRealmManager.engines["fsh.db"]?.rm_queryWithPredicate(object: Student.self, predicate: NSPredicate(format: "id = 99"))
        print("Students id 99 update后 : \(String(describing: ups))")
        
        ///删除
        FSRealmManager.engines["fsh.db"]?.rm_delete(object: s2)
        ///删除按条件
        FSRealmManager.engines["fsh.db"]?.rm_deleteByPredicate(object: Student.self, predicate: NSPredicate(format: "id = 101", argumentArray: nil))
        
        let alls = FSRealmManager.engines["fsh.db"]?.rm_query(object: Student.self)
        print("删除后数据 is \(String(describing: alls))")
        
        ///删除所有
        FSRealmManager.engines["fsh.db"]?.rm_deleteAll()
        
    }

}

