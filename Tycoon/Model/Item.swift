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
    dynamic var dateListed = Date()
    dynamic var sold = false

    let cost = RealmOptional<Double>()
    let listPrice = RealmOptional<Double>()
    let shippingCost = RealmOptional<Double>()
    let suppliesCost = RealmOptional<Double>()

    override static func primaryKey() -> String? {
        return "id"
    }

    var fee: Double {
        return listPrice.valueOrZero * 0.18
    }

    var profit: Double {
        return
            listPrice.valueOrZero
            - cost.valueOrZero
            - shippingCost.valueOrZero
            - suppliesCost.valueOrZero
            - fee
    }

    /// The point at which the sale breaks even given the costs and fees.
    /// Let l = list price,
    ///     c = item cost,
    ///     s = shipping cost,
    ///     u = supplies cost,
    ///     f = fee
    /// Then, the break-even point can be represented as:
    ///     0 = l - c - s - u - (l * f)
    /// Solving for l, we arrive at:
    ///     l = (c + s + u) / (1 - f)
    var breakEven: Double {
        return
            (cost.valueOrZero + shippingCost.valueOrZero + suppliesCost.valueOrZero)
            / (1 - 0.18)
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
