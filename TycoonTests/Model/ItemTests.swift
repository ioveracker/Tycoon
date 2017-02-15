import Quick
import Nimble
import RealmSwift
@testable import Tycoon

class ItemSpec: QuickSpec {

    override func spec() {
        describe("an item") {
            var item: Item!

            beforeEach {
                item = Item()
                item.itemDescription = "Test Item"
                item.size = "2T"
                item.cost = 42
                item.listPrice = 50
                item.shippingCost = 3.50

//                let shippingEnvelope = Material()
//                shippingEnvelope.name = "Shipping envelope"
//                shippingEnvelope.cost = 0.25

//                item.materials.append(shippingEnvelope)
            }

//            it("can calculate profit") {
//                expect(item.profit) == 4.25
//            }
        }
    }

}
