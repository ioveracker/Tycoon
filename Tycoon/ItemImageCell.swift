//
//  ItemImageCell.swift
//  Tycoon
//
//  Created by Isaac Overacker on 2/19/17.
//  Copyright © 2017 Isaac Overacker. All rights reserved.
//

import UIKit
import Eureka

public class ItemImageCell: Cell<String>, CellType {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var tapToAddPhotoLabel: UILabel!

    public override func setup() {
        super.setup()
        self.height = { UIScreen.main.bounds.size.width }
    }

    public override func update() {
        super.update()
    }

}

public final class ItemImageRow: Row<ItemImageCell>, RowType {

    required public init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<ItemImageCell>(nibName: "ItemImageCell")
    }

}
