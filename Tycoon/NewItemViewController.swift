import Eureka
import RealmSwift

class NewItemViewController: FormViewController {

    var item: Item?

    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss()
    }

    struct RowTags {
        static let description = "description"
        static let brand = "brand"
        static let size = "size"
        static let cost = "cost"
        static let listPrice = "listPrice"
        static let shippingCost = "shippingCost"
        static let suppliesCost = "suppliesCost"
        static let sold = "sold"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if item != nil {
            title = "Edit Item"
        }

        form
        +++ Section("Item Details")
            <<< TextRow() { row in
                row.title = "Description"
                row.placeholder = "Cute T-Rex Sweater"
                row.tag = RowTags.description

                if let item = item, item.itemDescription.characters.count > 0 {
                    row.value = item.itemDescription
                }
            }
            <<< TextRow() { row in
                row.title = "Brand"
                row.placeholder = "Carters"
                row.tag = RowTags.brand

                if let item = item, item.brand.characters.count > 0 {
                    row.value = item.brand
                }
            }
            <<< TextRow() { row in
                row.title = "Size"
                row.placeholder = "2T"
                row.tag = RowTags.size

                if let item = item, item.size.characters.count > 0 {
                    row.value = item.size
                }
            }
        +++ Section("Profit Breakdown")
            <<< DecimalRow() { row in
                row.title = "Cost"
                row.placeholder = "$12.50"
                row.tag = RowTags.cost

                if let value = item?.cost.value {
                    row.value = value
                }
            }
            <<< DecimalRow() { row in
                row.title = "List Price"
                row.placeholder = "$20.00"
                row.tag = RowTags.listPrice

                if let value = item?.listPrice.value {
                    row.value = value
                }
            }
            <<< DecimalRow() { row in
                row.title = "Shipping"
                row.placeholder = "$2.50"
                row.tag = RowTags.shippingCost

                if let value = item?.shippingCost.value {
                    row.value = value
                }
            }
            <<< DecimalRow() { row in
                row.title = "Supplies"
                row.placeholder = "$0.50"
                row.tag = RowTags.suppliesCost

                if let value = item?.suppliesCost.value {
                    row.value = value
                }
            }
            <<< SwitchRow() { row in
                row.title = "Sold?"
                row.tag = RowTags.sold

                if let item = item {
                    row.value = item.sold
                }
            }
            <<< LabelRow() { row in
                row.title = "Profit"

                if let item = item {
                    row.value = String(format: "$%.02f", arguments: [item.profit])
                }

                row.hidden = Condition.function([RowTags.sold]) { form in
                    return !((form.rowBy(tag: RowTags.sold) as? SwitchRow)?.value ?? false)
                }
            }
        +++ Section()
            <<< ButtonRow() { row in
                row.title = item == nil ? "Add" : "Save"
            }.onCellSelection() { (buttonCell, buttonRow) in
                let realm = try! Realm()

                let form = self.form
                let item = self.item ?? Item()

                try! realm.write {
                    if let row = form.rowBy(tag: RowTags.description) as? TextRow,
                        let value = row.value {
                        item.itemDescription = value
                    }

                    if let row = form.rowBy(tag: RowTags.brand) as? TextRow,
                        let value = row.value {
                        item.brand = value
                    }

                    if let row = form.rowBy(tag: RowTags.size) as? TextRow,
                        let value = row.value {
                        item.size = value
                    }

                    if let row = form.rowBy(tag: RowTags.cost) as? DecimalRow,
                        let value = row.value {
                        item.cost.value = value
                    }

                    if let row = form.rowBy(tag: RowTags.listPrice) as? DecimalRow,
                        let value = row.value {
                        item.listPrice.value = value
                    }

                    if let row = form.rowBy(tag: RowTags.shippingCost) as? DecimalRow,
                        let value = row.value {
                        item.shippingCost.value = value
                    }
                    
                    if let row = form.rowBy(tag: RowTags.suppliesCost) as? DecimalRow,
                        let value = row.value {
                        item.suppliesCost.value = value
                    }

                    if let row = form.rowBy(tag: RowTags.sold) as? SwitchRow,
                        let value = row.value {
                        item.sold = value
                    }

                    realm.add(item, update: self.item != nil)
                }

                self.dismiss()
            }
        +++ Section()
            <<< ButtonRow() { row in
                row.title = "Delete"
                row.cell.tintColor = UIColor.red
                row.hidden = Condition.function([]) { _ in
                    self.item == nil
                }
            }.onCellSelection() { (cell, row) in
                let alert = UIAlertController(
                    title: "Do you want to delete this item?",
                    message: nil,
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
                    if let item = self.item {
                        let realm = try! Realm()
                        try! realm.write {
                            realm.delete(item)
                        }
                    }
                    self.dismiss()
                })

                alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))

                self.present(alert, animated: true, completion: nil)
            }
    }

}

fileprivate extension NewItemViewController {

    func dismiss(then: (() -> Void)? = nil) {
        presentingViewController?.dismiss(animated: true, completion: then)
    }

}
