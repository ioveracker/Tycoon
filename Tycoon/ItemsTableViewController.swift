//
//  ItemsTableViewController.swift
//  Tycoon
//
//  Created by Isaac Overacker on 2/14/17.
//  Copyright © 2017 Isaac Overacker. All rights reserved.
//

import UIKit
import RealmSwift

class ItemsTableViewController: UITableViewController {

    var items: Results<Item>!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let realm = try! Realm()
        items = realm.objects(Item.self)
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard let identifier = segue.identifier else {
            return
        }

        if identifier == "ShowItem" {
            guard let nav = segue.destination as? UINavigationController,
                  let itemViewController = nav.viewControllers.first as? NewItemViewController else {
                return
            }

            if let row = tableView.indexPathForSelectedRow?.row {
                itemViewController.item = items[row]
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell")!
        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let itemCell = cell as? ItemCell {
            let item = items[indexPath.row]
            itemCell.descriptionLabel.text = item.itemDescription
            itemCell.moneyLabel.text = String(
                format: "$%.02f",
                arguments: [item.listPrice.valueOrZero])
        }
    }

}
