//
//  Backup+AppDatabase.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/6/28.
//

import Foundation
import GRDB
import Zip

let DATABASE_BAK_DIRECTORY: String = "databasebak"

extension AppDatabase {
    public static func ofdatabasepool(_ name: String) -> DatabasePool {
        assert(!name.isEmpty)

        do {
            let fileManager = FileManager()
            let folderURL = try fileManager
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(DATABASE_BAK_DIRECTORY, isDirectory: true)
                .appendingPathComponent(name, isDirectory: true)

            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)

            let dbURL = folderURL.appendingPathComponent(name + ".sqlite")

            let dbPool = try DatabasePool(path: dbURL.path)

            return dbPool
        } catch {
            fatalError("Unresolved error \(error)")
        }
    }
}

private func ofdatabasebakparentfolderurl() -> URL {
    let fileManager = FileManager()
    let folderURL = try! fileManager
        .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        .appendingPathComponent(DATABASE_BAK_DIRECTORY, isDirectory: true)

    return folderURL
}

private func ofdatabasebakfolderurl(_ name: String) -> URL {
    assert(!name.isEmpty)

    let fileManager = FileManager()
    let folderURL = try! fileManager
        .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        .appendingPathComponent(DATABASE_BAK_DIRECTORY, isDirectory: true)
        .appendingPathComponent(name, isDirectory: true)

    return folderURL
}

class Backup: NSObject {
    let lock = NSLock()

    var query: NSMetadataQuery!

    override init() {
        super.init()

        initialiseQuery()
        addNotificationObservers()
    }

    func initialiseQuery() {
        query = NSMetadataQuery()
        query.operationQueue = .main
        query.searchScopes = [NSMetadataQueryUbiquitousDataScope]
        query.predicate = NSPredicate(format: "%K LIKE %@", NSMetadataItemFSNameKey, "_bak.zip")
    }

    private func zippack(_ name: String) -> URL {
        let dbfolderurl = ofdatabasebakfolderurl(name)
        let destfolderurl = dbfolderurl

        let zipFilePath = destfolderurl.appendingPathComponent("\(name)_bak.zip")
        try! Zip.zipFiles(paths: [dbfolderurl], zipFilePath: zipFilePath, password: nil, progress: { (progress) -> Void in
            log(progress)
        })

        return zipFilePath
    }

    func backup() {
        lock.lock()
        defer {
            lock.unlock()
        }

        keeplast5bakups()
        
        let bakdbname = "\(Date().secondsSince1970)"
        
        // 1、migrate db
        migratebakdb(bakdbname)

        // 2、zip pack
        let zipurl = zippack(bakdbname)

        // 3、upload to icloud
        try! uploadtoicloud(zipurl, bakname: bakdbname)

        // 4、remove all bakup files
        clearalltmpfiles()

        log("\(bakdbname) finished ...")
    }
    
    func migratebakdb(_ bakdbname: String) {
        let destination = AppDatabase.ofdatabasepool(bakdbname)
        let source = AppDatabase.shared.dbWriter

        try! source.backup(to: destination)
    }

    func clearalltmpfiles() {
        let parentURL = ofdatabasebakparentfolderurl()
        let fileManager = FileManager()
        
        try! FileManager.default.removeItem(at: parentURL)
    }

    func uploadtoicloud(_ fileURL: URL, bakname: String) throws {
        guard let containerURL = FileManager.default.url(forUbiquityContainerIdentifier: "iCloud.com.quantumbubble.pocketfit") else { return }
        let folderurl = containerURL.appendingPathComponent("Documents", isDirectory: true)

        if !FileManager.default.fileExists(atPath: folderurl.path) {
            try FileManager.default.createDirectory(at: folderurl, withIntermediateDirectories: true, attributes: nil)
        }

        let backupFileURL = folderurl.appendingPathComponent("\(bakname).bak")
        if FileManager.default.fileExists(atPath: backupFileURL.path) {
            try FileManager.default.removeItem(at: backupFileURL)
            try FileManager.default.copyItem(at: fileURL, to: backupFileURL)
        } else {
            try FileManager.default.copyItem(at: fileURL, to: backupFileURL)
        }

        query.operationQueue?.addOperation({ [weak self] in
            _ = self?.query.start()
            self?.query.enableUpdates()
        })
    }

    func keeplast5bakups() {
        guard let containerURL = FileManager.default.url(forUbiquityContainerIdentifier: "iCloud.com.quantumbubble.pocketfit") else { return }
        let folderurl = containerURL.appendingPathComponent("Documents", isDirectory: true)

        let directoryContents = try! FileManager.default.contentsOfDirectory(at: folderurl, includingPropertiesForKeys: nil)

        var rawbakups: [String] = []
        for url in directoryContents {
            let fileName = FileManager.default.displayName(atPath: url.absoluteString)
            rawbakups.append(fileName)
        }

        if rawbakups.count < 5 {
            return
        }

        // only keep the last 4 backups
        let sortedbackups = rawbakups.sorted { l, r in
            l > r
        }

        for each in sortedbackups {
            log(each)
        }

        for idx in 4 ..< sortedbackups.count {
            let todelete = sortedbackups[idx]
            let todeleteurl = folderurl.appendingPathComponent(todelete)
            try! FileManager.default.removeItem(atPath: todeleteurl.path)
        }
    }

    func addNotificationObservers() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSMetadataQueryDidStartGathering, object: query, queue: query.operationQueue) { _ in
            self.processCloudFiles()
        }

        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSMetadataQueryDidUpdate, object: query, queue: query.operationQueue) { _ in
            self.processCloudFiles()
        }
    }

    @objc func processCloudFiles() {
        if query.results.count == 0 { return }
        var fileItem: NSMetadataItem?
        var fileURL: URL?

        for item in query.results {
            guard let item = item as? NSMetadataItem else { continue }
            guard let fileItemURL = item.value(forAttribute: NSMetadataItemURLKey) as? URL else { continue }
            if fileItemURL.lastPathComponent.contains(".bak") {
                fileItem = item
                fileURL = fileItemURL
            }
        }

        let fileValues = try? fileURL!.resourceValues(forKeys: [URLResourceKey.ubiquitousItemIsUploadingKey])
        if let fileUploaded = fileItem?.value(forAttribute: NSMetadataUbiquitousItemIsUploadedKey) as? Bool, fileUploaded == true, fileValues?.ubiquitousItemIsUploading == false {
            log("backup upload complete")

        } else if let error = fileValues?.ubiquitousItemUploadingError {
            log("upload error--- \(error.localizedDescription)" )

        } else {
            if let fileProgress = fileItem?.value(forAttribute: NSMetadataUbiquitousItemPercentUploadedKey) as? Double {
                log("uploaded percent --- \(fileProgress)")
            }
        }
    }
}

extension Backup {
    static let shared = Backup()
}
