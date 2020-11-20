//
//  FSRealmEngine.swift
//
//  Created by fengsh998 on 2020/8/15.
//  Copyright © 2020 fengsh998. All rights reserved.
//

import UIKit
import RealmSwift

public protocol FSRealmApi {
    var rm_instance:Realm {set get}
    static var realm_url:URL? { get }
    //MARK: 添加
    func rm_add(object:Object)
    func rm_addList(objects:Array<Object>)
    //MARK: 删除
    func rm_delete(object:Object)
    func rm_deleteList(objects:Array<Object>)
    func rm_deleteAll()
    func rm_deleteByPredicate(object:Object.Type,predicate:NSPredicate)
    //MARK: 更新
    func rm_update(object:Object)
    func rm_updateList(objects:Array<Object>)
    func rm_updateByTranstion(action:(Bool)->Void)
    //MARK: 查询
    func rm_query(object:Object.Type) ->Array<Object>
    func rm_queryWithPredicate(object:Object.Type,predicate:NSPredicate) ->Array<Object>
    func rm_queryWithPredicateAndSorted(object:Object.Type,
                                        predicate:NSPredicate,
                                        sortedKey:String,
                                        isAssending:Bool) -> Array<Object>
    func rm_queryWithPredicateAndSortedForPages(object:Object.Type,
                                                predicate:NSPredicate,
                                                sortedKey:String,isAssending:Bool,
                                                fromIndex:Int,pageSize:Int) -> Array<Object>
    //MARK: 删库
    ///以 xxx.realm文件结尾
    static func rm_deleteRealmFiles(fullpath:URL?) -> Bool
}

//MARK: 实现
class FSRealmEngine : FSRealmApi {
    
    static var realm_url: URL? { return Realm.Configuration.defaultConfiguration.fileURL }
    
    var rm_instance: Realm
    
    init(config:Realm.Configuration,isDefault:Bool) {
        if (isDefault) {
            Realm.Configuration.defaultConfiguration = config
            rm_instance = try! Realm()
            return
        }
        rm_instance = try! Realm(configuration: config)
    }
    
    ///删库
    static func rm_deleteRealmFiles(fullpath:URL?) -> Bool {
        
        let realmURL = fullpath != nil ? fullpath! : Realm.Configuration.defaultConfiguration.fileURL!
        let realmURLs = [
            realmURL,
            realmURL.appendingPathExtension("lock"),
            realmURL.appendingPathExtension("note"),
            realmURL.appendingPathExtension("management")
        ]
        for URL in realmURLs {
            do {
                try FileManager.default.removeItem(at: URL)
            } catch {
                // handle error
                return false
            }
        }
        return true
    }
}

//MARK: 增
extension FSRealmEngine {
    func rm_add(object: Object) {
        try! rm_instance.write {
            rm_instance.add(object)
        }
    }
    
    func rm_addList(objects: Array<Object>) {
        try! rm_instance.write {
            rm_instance.add(objects)
        }
    }
}

//MARK: 删
extension FSRealmEngine {
    func rm_delete(object: Object) {
        try! rm_instance.write {
            rm_instance.delete(object)
        }
    }
    
    func rm_deleteList(objects: Array<Object>) {
        try! rm_instance.write {
            rm_instance.delete(objects)
        }
    }
    
    func rm_deleteAll() {
        try! rm_instance.write {
            rm_instance.deleteAll()
        }
    }
    
    func rm_deleteByPredicate(object: Object.Type, predicate: NSPredicate) {
        let results:Array<Object> = rm_queryWithPredicate(object: object, predicate: predicate)
        if results.count > 0 {
            try! rm_instance.write {
                rm_instance.delete(results)
            }
        }
    }
}

//MARK: 改
extension FSRealmEngine {
    func rm_update(object: Object) {
        try! rm_instance.write {
            rm_instance.add(object, update: .modified)
        }
    }
    
    func rm_updateList(objects: Array<Object>) {
        try! rm_instance.write {
            rm_instance.add(objects, update: .modified)
        }
    }
    
    func rm_updateByTranstion(action: (Bool) -> Void) {
        try! rm_instance.write {
            action(true)
        }
    }
}

//MARK: 查
extension FSRealmEngine {
    func rm_query(object: Object.Type) -> Array<Object> {
        let results = rm_queryWithType(object: object)
        var resultsArray = Array<Object>()
        if results.count > 0 {
            for i in 0...results.count-1{
                resultsArray.append(results[i])
            }
        }
        return resultsArray
    }
    
    func rm_queryWithPredicate(object: Object.Type, predicate: NSPredicate) -> Array<Object> {
        let results =  rm_queryWith(object: object, predicate: predicate)
        var resultsArray = Array<Object>()
        if results.count > 0 {
            for i in 0...results.count-1 {
                resultsArray.append(results[i])
            }
        }
        return resultsArray
    }
    
    func rm_queryWithPredicateAndSorted(object: Object.Type, predicate: NSPredicate, sortedKey: String, isAssending: Bool) -> Array<Object> {
        let results = rm_queryWithSorted(object: object, predicate: predicate,
                                         sortedKey: sortedKey, isAssending: isAssending)
        
        var resultsArray = Array<Object>()
        if results.count > 0 {
            for i in 0...results.count-1{
                resultsArray.append(results[i])
            }
        }
        return resultsArray
    }
    
    func rm_queryWithPredicateAndSortedForPages(object: Object.Type, predicate: NSPredicate, sortedKey: String, isAssending: Bool, fromIndex: Int, pageSize: Int) -> Array<Object> {
        let results = rm_queryWithSorted(object: object, predicate: predicate,
                                         sortedKey: sortedKey, isAssending: isAssending)
        var resultsArray = Array<Object>()
        
        if results.count <= pageSize*(fromIndex - 1) || fromIndex <= 0 {
            return resultsArray
        }
        
        if results.count > 0 {
            for i in pageSize*(fromIndex - 1)...fromIndex*pageSize-1{
                resultsArray.append(results[i])
            }
        }
        
        return resultsArray
    }
}

//MARK: 私有
extension FSRealmEngine {
    /// 查询某个对象数据
    private func rm_queryWithType(object:Object.Type) -> Results<Object>{
        return rm_instance.objects(object)
    }
    /// 根据条件查询数据
    private func rm_queryWith(object:Object.Type,predicate:NSPredicate) -> Results<Object>{
        return rm_instance.objects(object).filter(predicate)
    }
    /// 带排序条件查询
    private func rm_queryWithSorted(object:Object.Type,predicate:NSPredicate,
                                           sortedKey:String,isAssending:Bool) -> Results<Object>{
        return rm_instance.objects(object).filter(predicate)
            .sorted(byKeyPath: sortedKey, ascending: isAssending)
    }
}
