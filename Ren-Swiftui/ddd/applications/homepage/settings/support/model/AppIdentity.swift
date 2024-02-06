//
//  AppIdentity.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/17.
//

import Foundation
import GRDB

enum AppState: String, Codable {
    case finished, skipped
}

/*
 * appstate 记录app的初始化状态
 * identity 用来标识客户端的合法性
 */
public struct AppIdentity: Identifiable, Hashable, Equatable {
    public var id: Int64?
    var createtime: Date = Date()

    var appstate: AppState
    var identity: String = "tmp"
}

extension AppIdentity: Codable, FetchableRecord, MutablePersistableRecord {
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
    
    func saveAppIdentity(_ appidentity: inout AppIdentity) throws {
        try dbWriter.write { db in
            try appidentity.save(db)
        }
    }

    func queryAppIdentity() -> AppIdentity? {
        let appidentity: AppIdentity? = try! dbWriter.read { db in
            try AppIdentity
                .order(Column("id").desc)
                .limit(1)
                .fetchOne(db)
        }
        return appidentity
    }
    
    func deleteAppIdentity() throws {
        try dbWriter.write { db in
            _ = try AppIdentity.deleteAll(db)
        }
    }
}
