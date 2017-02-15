//
//  Item.swift
//  Tycoon
//
//  Created by Isaac Overacker on 2/5/17.
//  Copyright © 2017 Isaac Overacker. All rights reserved.
//

import RealmSwift

class Item: Object {

    dynamic var itemDescription = ""
    dynamic var brand = ""
//    var photo
    dynamic var size = ""
    dynamic var cost: Double = 0.0
    dynamic var listPrice: Double = 0.0
    dynamic var shippingCost: Double = 0.0
    dynamic var suppliesCost: Double = 0.0
//    var materials = List<Material>()

    var profit: Double {
        return listPrice - cost - shippingCost - suppliesCost // materials.reduce(0, { $0 + $1.cost })
    }
    
}

//class Material: Object {
//
//    var name = ""
//    var cost: Double = 0.0
//
//}
