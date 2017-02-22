//
//  PlayerModel.swift
//  Flowers
//
//  Created by Jozsef Romhanyi on 29/03/2016.
//  Copyright © 2016 Jozsef Romhanyi. All rights reserved.
//

import Foundation
import RealmSwift

class PlayerModel: Object {
    dynamic var ID = 0
    dynamic var levelID = 0
    dynamic var name = ""
    dynamic var isActPlayer = false
    dynamic var aktLanguageKey = GV.language.getAktLanguageKey()
    dynamic var soundVolume: Float = 0
    dynamic var musicVolume: Float = 0
//    #if REALM_V1
    dynamic var packages = 0  // new in v1
//    #endif
    dynamic var created = Date()

    override  class func primaryKey() -> String {
        return "ID"
    }

    
}
