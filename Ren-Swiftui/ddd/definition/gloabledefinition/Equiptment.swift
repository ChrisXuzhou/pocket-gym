
import Foundation

/**
 * 定义了 【器械】
 */
struct EquipmentDef: Hashable, Codable, Identifiable {
    var id: String
    var img: String
    var _id: Int
    var type: String
}

extension EquipmentDef {
    var ident: String {
        id
    }
}

class Equipment {
    var definedlist: [EquipmentDef]
    var id2equipment: [String: EquipmentDef]

    init() {
        definedlist = []
        id2equipment = [:]

        initLoad()
        refresh()
    }

    func initLoad() {
        let fileName = "equipment.json"
        let tmp: [EquipmentDef] = load(fileName) ?? []
        if !tmp.isEmpty {
            definedlist.append(contentsOf: tmp)
        }
    }

    func refresh() {
        id2equipment = Dictionary(uniqueKeysWithValues: definedlist.map({ ($0.ident.lowercased(), $0) }))
    }

    var equipmentsnobench: [EquipmentDef] {
        definedlist.filter { !$0.id.contains("bench") }
    }
}

extension Equipment {
    static var shared = Equipment()
}

extension Equipment {
    func ofequipment(_ id: String) -> EquipmentDef {
        id2equipment[id.lowercased().replacingOccurrences(of: " ", with: "_")]!
    }
}
