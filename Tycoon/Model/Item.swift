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

    var imagePath: String {
        return "\(getImagesDirectory())/\(id).png"
    }

    var imageURL: URL {
        return URL(fileURLWithPath: imagePath)
    }

    func delete() {
        if let realm = self.realm {
            if FileManager.default.fileExists(atPath: imagePath) {
                try! FileManager.default.removeItem(atPath: imagePath)
            }

            try! realm.write {
                realm.delete(self)
            }
        }
    }

}

// MARK: Private
fileprivate extension Item {

    fileprivate func getImagesDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let imagesDirectory = "\(paths.first!)/Images"
        let imagesURL = URL(fileURLWithPath: imagesDirectory)

        if !FileManager.default.fileExists(atPath: imagesDirectory) {
            try! FileManager.default.createDirectory(at: imagesURL,
                                                     withIntermediateDirectories: true,
                                                     attributes: nil)
        }

        return imagesDirectory
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
