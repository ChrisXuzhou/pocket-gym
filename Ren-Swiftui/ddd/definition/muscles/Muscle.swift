import Foundation

class Muscle {

    var definedlist: [Muscledef]
    var identitymap: [String: Muscledef]
    var groupedbytypeMuscles: [String: [Muscledef]]
    
    init() {
        self.definedlist = load("muscles.json") ?? []
        self.identitymap = Dictionary(uniqueKeysWithValues: definedlist.map { ($0.identify, $0) })
        groupedbytypeMuscles = Dictionary(grouping: definedlist, by: { $0.type })
    }
    
    var mainmuscles: [Muscledef] {
        groupedbytypeMuscles["main"] ?? []
    }
    
    var accessorymuscles: [Muscledef] {
        groupedbytypeMuscles["accessory"] ?? []
    }
}

extension Muscle {
    func ofmuscle(_ name: String) -> Muscledef? {
        return identitymap[name]
    }
}

extension Muscle {
    static let shared = Muscle()
}


/**
 * 定义了 【肌肉】
 */
struct Muscledef: Hashable, Codable, Identifiable, Equatable {
    /*
     * 核心字段
     */
    var id: String
    var type: String
    
    var _id: Int
}

extension Muscledef {
    var img: String {
        return id
    }
    var identify: String {
        id
    }
}
