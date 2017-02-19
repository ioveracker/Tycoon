import Eureka
import RealmSwift

class NewItemViewController: FormViewController {

    var item: Item!
    var editingItem = false
    var notificationToken: NotificationToken?

    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        // Only delete the item on cancel if this is the first time the item is being added, not
        // when it is being edited.
        if !editingItem, let realm = item.realm {
            try! realm.write {
                realm.delete(item)
            }
        }

        dismiss()
    }

    struct RowTags {
        static let description = "description"
        static let brand = "brand"
        static let size = "size"
        static let cost = "cost"
        static let dateListed = "dateListed"
        static let listPrice = "listPrice"
        static let shippingCost = "shippingCost"
        static let suppliesCost = "suppliesCost"
        static let breakEven = "breakEven"
        static let fee = "fee"
        static let profit = "profit"
        static let sold = "sold"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if item != nil {
            editingItem = true
            title = "Edit Item"
        } else {
            item = Item()
        }

        form
        +++ Section("Item Details")
            <<< TextRow() { row in
                row.title = "Description"
                row.placeholder = "Cute T-Rex Sweater"
                row.tag = RowTags.description

                if item.itemDescription.characters.count > 0 {
                    row.value = item.itemDescription
                }
            }.onChange { row in
                if let value = row.value {
                    let realm = try! Realm()
                    try! realm.write {
                        realm.add(self.item, update: true)
                        self.item.itemDescription = value
                    }
                }
            }
            <<< TextRow() { row in
                row.title = "Brand"
                row.placeholder = "Carters"
                row.tag = RowTags.brand

                if item.brand.characters.count > 0 {
                    row.value = item.brand
                }
            }.onChange { row in
                if let value = row.value {
                    try! Realm().write {
                        self.item.brand = value
                    }
                }
            }
            <<< TextRow() { row in
                row.title = "Size"
                row.placeholder = "2T"
                row.tag = RowTags.size

                if item.size.characters.count > 0 {
                    row.value = item.size
                }
            }.onChange { row in
                if let value = row.value {
                    try! Realm().write {
                        self.item.size = value
                    }
                }
            }
            <<< DateInlineRow() { row in
                row.title = "Date Listed"
                row.tag = RowTags.dateListed
                row.value = item.dateListed
            }.onChange { row in
                if let value = row.value {
                    try! Realm().write {
                        self.item.dateListed = value
                    }
                }
            }
            <<< SwitchRow() { row in
                row.title = "Sold?"
                row.tag = RowTags.sold

                if let item = item {
                    row.value = item.sold
                }
                }.onChange { row in
                    if let value = row.value {
                        try! Realm().write {
                            self.item.sold = value
                        }
                    }
            }
        +++ Section("Costs")
            <<< DecimalRow() { row in
                row.title = "Item Cost"
                row.tag = RowTags.cost

                if let value = item.cost.value {
                    row.value = value
                }
            }.onChange { row in
                let value = row.value ?? 0.0
                try! Realm().write {
                    self.item.cost.value = value
                }
            }
            <<< DecimalRow() { row in
                row.title = "Shipping"
                row.tag = RowTags.shippingCost

                if let value = item.shippingCost.value {
                    row.value = value
                }
            }.onChange { row in
                let value = row.value ?? 0.0
                try! Realm().write {
                    self.item.shippingCost.value = value
                }
            }
            <<< DecimalRow() { row in
                row.title = "Supplies"
                row.tag = RowTags.suppliesCost

                if let value = item.suppliesCost.value {
                    row.value = value
                }
            }.onChange { row in
                let value = row.value ?? 0.0
                try! Realm().write {
                    self.item.suppliesCost.value = value
                }
            }
        +++ Section("Pricing")
            <<< LabelRow() { row in
                row.title = "Break Even At"
                row.tag = RowTags.breakEven
                row.value = self.item.breakEven.presentableString
            }.cellUpdate { cell, row in
                row.value = self.item.breakEven.presentableString
                cell.update()
            }
            <<< DecimalRow() { row in
                row.title = "List Price"
                row.tag = RowTags.listPrice

                if let value = item.listPrice.value {
                    row.value = value
                }
            }.onChange { row in
                let value = row.value ?? 0.0
                try! Realm().write {
                    self.item.listPrice.value = value
                }
            }
            <<< LabelRow() { row in
                row.title = "Kidizen Fee"
                row.tag = RowTags.fee
                row.value = self.item.fee.presentableString
                }.cellUpdate { cell, row in
                    row.value = self.item.fee.presentableString
                    cell.update()
            }
            <<< LabelRow() { row in
                row.title = "Profit"
                row.tag = RowTags.profit
                row.value = self.item.profit.presentableString
            }.cellUpdate { cell, row in
                row.value = self.item.profit.presentableString
                cell.update()
            }
        +++ Section()
            <<< ButtonRow() { row in
                row.title = item == nil ? "Add" : "Save"
            }.onCellSelection() { (buttonCell, buttonRow) in
                self.dismiss()
            }
        +++ Section()
            <<< ButtonRow() { row in
                row.title = "Delete"
                row.cell.tintColor = UIColor.red
                row.tag = "delete"

                row.hidden = Condition.function([]) { form in
                    return !self.editingItem
                }
            }.onCellSelection() { (cell, row) in
                let alert = UIAlertController(
                    title: "Do you want to delete this item?",
                    message: nil,
                    preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))

                alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
                    if let item = self.item {
                        let realm = try! Realm()
                        try! realm.write {
                            realm.delete(item)
                        }
                    }
                    self.dismiss()
                })

                self.present(alert, animated: true, completion: nil)
            }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        notificationToken = try! Realm().addNotificationBlock() { _, _ in
            if self.item.isInvalidated {
                return
            }

            DispatchQueue.main.async {
                if let profitRow = self.form.rowBy(tag: RowTags.profit) as? LabelRow {
                    profitRow.updateCell()
                }

                if let feeRow = self.form.rowBy(tag: RowTags.fee) as? LabelRow {
                    feeRow.updateCell()
                }

                if let breakEvenRow = self.form.rowBy(tag: RowTags.breakEven) as? LabelRow {
                    breakEvenRow.updateCell()
                }

                if let deleteRow = self.form.rowBy(tag: "delete") as? ButtonRow {
                    deleteRow.updateCell()
                }
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        notificationToken?.stop()
        notificationToken = nil
        super.viewWillDisappear(animated)
    }

}

fileprivate extension NewItemViewController {

    func dismiss(then: (() -> Void)? = nil) {
        presentingViewController?.dismiss(animated: true, completion: then)
    }

}

extension Double {

    static let numberFormatter = NumberFormatter()

    var presentableString: String {
        Double.numberFormatter.numberStyle = .currency
        return Double.numberFormatter.string(from: self as NSNumber) ?? ""
    }

}
