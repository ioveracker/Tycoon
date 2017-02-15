import Eureka
import RealmSwift

class NewItemViewController: FormViewController {

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
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        form
        +++ Section("Item Details")
            <<< TextRow() { row in
                row.title = "Description"
                row.placeholder = "Cute T-Rex Sweater"
                row.tag = RowTags.description
            }
            <<< TextRow() { row in
                row.title = "Brand"
                row.placeholder = "Carters"
                row.tag = RowTags.brand
            }
            <<< TextRow() { row in
                row.title = "Size"
                row.placeholder = "2T"
                row.tag = RowTags.size
            }
        +++ Section("Profit Breakdown")
            <<< DecimalRow() { row in
                row.title = "Cost"
                row.placeholder = "$12.50"
                row.tag = RowTags.cost
            }
            <<< DecimalRow() { row in
                row.title = "List Price"
                row.placeholder = "$20.00"
                row.tag = RowTags.listPrice
            }
            <<< DecimalRow() { row in
                row.title = "Shipping"
                row.placeholder = "$2.50"
                row.tag = RowTags.shippingCost
            }
            <<< DecimalRow() { row in
                row.title = "Supplies"
                row.placeholder = "$0.50"
                row.tag = RowTags.suppliesCost
            }
        +++ Section()
            <<< ButtonRow() { row in
                row.title = "Add"
            }.onCellSelection() { (buttonCell, buttonRow) in
                let realm = try! Realm()

                let form = self.form
                let item = Item()

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
                    item.cost = value
                }

                if let row = form.rowBy(tag: RowTags.listPrice) as? DecimalRow,
                    let value = row.value {
                    item.listPrice = value
                }

                if let row = form.rowBy(tag: RowTags.shippingCost) as? DecimalRow,
                    let value = row.value {
                    item.shippingCost = value
                }

                if let row = form.rowBy(tag: RowTags.suppliesCost) as? DecimalRow,
                    let value = row.value {
                    item.suppliesCost = value
                }

                print("item: \(item)")

                try! realm.write {
                    realm.add(item)
                }

                self.dismiss()
            }
    }

}

fileprivate extension NewItemViewController {

    func dismiss(then: (() -> Void)? = nil) {
        presentingViewController?.dismiss(animated: true, completion: then)
    }

}
