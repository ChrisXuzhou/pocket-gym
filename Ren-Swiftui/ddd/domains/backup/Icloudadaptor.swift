//
//  ICloudadaptor.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/7/23.
//

import CloudKit
import Foundation
import os.log

let CLOUD_ID_KEY = "iCloud.com.quantumbubble.pocketfit"

class Icloudadaptor {
    private let container = CKContainer(identifier: CLOUD_ID_KEY)
    lazy var database = container.privateCloudDatabase

    private func reportError(_ error: Error) -> String {
        guard let ckerror = error as? CKError else {
            return "Not a CKError: \(error.localizedDescription)"
        }

        var err: String = ""

        switch ckerror.code {
        case .partialFailure:
            let dict = ckerror.userInfo[CKPartialErrorsByItemIDKey] as? [NSObject: CKError]
            if let errorDictionary = dict {
                for (_, error) in errorDictionary {
                    err += reportError(error)
                }
            }

        case .unknownItem:
            err += "CKError: Record not found."

        case .notAuthenticated:
            err += "CKError: An iCloud account must be signed in on device or Simulator to write to a PrivateDB."

        case .permissionFailure:
            err += "CKError: An iCloud account permission failure occured."

        case .networkUnavailable:
            err += "CKError: The network is unavailable."

        default:
            err += "CKError: \(error.localizedDescription)"
        }

        return err
    }

    func save(_ records: [CKRecord], deleteds: [CKRecord.ID] = [], oncomplete: ((Bool, String?) -> Void)? = nil) {
        let semp = DispatchSemaphore(value: 0)

        Task {
            do {
                var err: String = ""
                var success = true

                defer {
                    semp.signal()
                }

                let (saveResults, _) = try await database.modifyRecords(
                    saving: records,
                    deleting: deleteds,
                    savePolicy: .allKeys
                )

                for recordResult in saveResults.values {
                    switch recordResult {
                    case .success:
                        log("[backup] successed.")
                    case let .failure(recordError):
                        err += reportError(recordError)
                        success = false
                    }
                }

                if let _oncomplete = oncomplete {
                    _oncomplete(success, err)
                }

            } catch let functionError {
                let err = self.reportError(functionError)
                if let _oncomplete = oncomplete {
                    _oncomplete(false, err)
                }
            }
        }
        semp.wait()
    }

    internal func queryRecords(query: CKQuery,
                               completionHandler: @escaping (_ results: [CKRecord]) -> Bool) {
        /*
         if !(query.sortDescriptors != nil) {
             query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
         }

         */
        let operation = CKQueryOperation(query: query)
        var results = [CKRecord]()

        operation.recordMatchedBlock = { _, record in
            switch record {
            case let .failure(error):
                debugPrint(error)
            case let .success(ckrecord):
                results.append(ckrecord)
            }
        }

        operation.queryCompletionBlock = { [weak self] (cursor: CKQueryOperation.Cursor?, error: Error?) in
            // Continue if there are no errors
            guard error == nil else {
                debugPrint(error)
                return
            }

            if completionHandler(results) {
                if cursor != nil {
                    self?.queryRecords(cursor: cursor!,
                                       continueWithResults: results,
                                       completionHandler: completionHandler)
                }
            }
        }
        operation.resultsLimit = CKQueryOperation.maximumResults
        database.add(operation)
    }

    private func queryRecords(cursor: CKQueryOperation.Cursor,
                              continueWithResults: [CKRecord],
                              completionHandler: @escaping (_ results: [CKRecord]) -> Bool) {
        var results = continueWithResults
        let operation = CKQueryOperation(cursor: cursor)

        operation.recordMatchedBlock = { _, record in
            switch record {
            case let .failure(error):
                debugPrint(error)
            case let .success(ckrecord):
                results.append(ckrecord)
            }
        }

        operation.queryCompletionBlock = { [weak self] (cursor: CKQueryOperation.Cursor?, error: Error?) in
            // Continue if there are no errors
            guard error == nil else {
                debugPrint(error)
                return
            }
            // Invoke completion if there is no cursor
            guard cursor != nil else {
                debugPrint(error)
                return
            }

            if completionHandler(results) {
                if cursor != nil {
                    self?.queryRecords(cursor: cursor!, continueWithResults: results, completionHandler: completionHandler)
                }
            }
        }

        operation.resultsLimit = CKQueryOperation.maximumResults
        database.add(operation)
    }
}

extension Icloudadaptor {
    public static var shared = Icloudadaptor()
}

extension Icloudadaptor {
    func fetchuserid(handleuserid: @escaping (_ userid: String) -> Void) {
        CKContainer.default().requestApplicationPermission(.userDiscoverability) { _, _ in
            CKContainer.default().fetchUserRecordID { record, _ in
                if let _record = record {
                    CKContainer.default().discoverUserIdentity(withUserRecordID: _record, completionHandler: { userID, _ in
                        print(userID?.hasiCloudAccount)
                        print(userID?.lookupInfo?.phoneNumber)
                        print(userID?.lookupInfo?.emailAddress)

                        let userid = (userID?.nameComponents?.givenName) ?? "" + " " + (userID?.nameComponents?.familyName ?? "")
                        handleuserid(userid)
                    })
                }
            }
        }
    }
}
