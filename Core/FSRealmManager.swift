//
//  FSRealmManager.swift
//
//  Created by fengsh998 on 2020/8/15.
//  Copyright © 2020 fengsh998. All rights reserved.
//

import UIKit
import RealmSwift

class FSRealmManager: NSObject {
    static var engines:[String:FSRealmApi] = [:]
    
    static func rm_initRealmConfig(dbname:String,currentVersion:UInt64,key:String,
                                   processing:((_ mt:Migration,_ oldversion:UInt64) -> ())?) {
        
        if (engines.keys.contains(key)) {
            return
        }
        
        var config = Realm.Configuration()
        config.migrationBlock = { migration, oldSchemaVersion in
            if let process = processing {
                process(migration,UInt64(oldSchemaVersion))
            }
        }
        config.schemaVersion = currentVersion
        config.fileURL = config.fileURL!.deletingLastPathComponent()
            .appendingPathComponent("\(dbname).realm")
        let rmengine = FSRealmEngine.init(config: config, isDefault: false)
        engines[key] = rmengine
    }
    
    static func rm_delRealmFiles(file:URL?) ->Bool {
        return FSRealmEngine.rm_deleteRealmFiles(fullpath: file)
    }
}

