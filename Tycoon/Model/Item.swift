//
//  Item.swift
//  Tycoon
//
//  Created by Isaac Overacker on 2/5/17.
//  Copyright © 2017 Isaac Overacker. All rights reserved.
//

import RealmSwift

class Item: Object {

    dynamic var id = UUID().uuidString
    dynamic var itemDescription = ""
    dynamic var brand = ""
//    var photo
    dynamic var size = ""

    let cost = RealmOptional<Double>()
    let listPrice = RealmOptional<Double>()
    let shippingCost = RealmOptional<Double>()
    let suppliesCost = RealmOptional<Double>()

    override static func primaryKey() -> String? {
        return "id"
    }

    var profit: Double {
        return
            listPrice.valueOrZero
            - cost.valueOrZero
            - shippingCost.valueOrZero
            - suppliesCost.valueOrZero
    }
    
}

extension RealmOptional {

    var valueOrZero: Double {
        if let double = value as? Double {
            return double
        }

        return 0.0
    }

}
