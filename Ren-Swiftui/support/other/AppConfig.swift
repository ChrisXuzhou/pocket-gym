import Foundation
import GRDB

public struct ConfigKeyAndValue: Identifiable, Hashable, Equatable {
    public var id: Int64?
    var createtime: Date = Date()

    var key: String
    var value: String
}

extension ConfigKeyAndValue: Codable, FetchableRecord, MutablePersistableRecord {
    // Define database columns from CodingKeys
    fileprivate enum Columns {
        static let id = Column(CodingKeys.id)
    }

    /// Updates a player id after it has been inserted in the database.
    public mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

extension AppDatabase {
    func saveKeyAndValue(_ keyAndValue: inout ConfigKeyAndValue) throws {
        try dbWriter.write { db in  
            try keyAndValue.save(db)
        }
    }

    func queryKeyAndValue(key: String) -> ConfigKeyAndValue? {
        let keyAndValue: ConfigKeyAndValue? = try! dbWriter.read { db in
            try ConfigKeyAndValue.filter(Column("key") == key).limit(1).fetchOne(db)
        }
        return keyAndValue
    }
}
