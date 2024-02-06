import Foundation
import GRDB

/// AppDatabase lets the application access the database.
///
/// It applies the pratices recommended at
/// <https://github.com/groue/GRDB.swift/blob/master/Documentation/GoodPracticesForDesigningRecordTypes.md>
final class AppDatabase {
    /// Creates an `AppDatabase`, and make sure the database schema is ready.
    init(_ dbWriter: DatabaseWriter) throws {
        self.dbWriter = dbWriter
        try migrator.migrate(dbWriter)
    }

    /// Provides access to the database.
    ///
    /// Application can use a `DatabasePool`, and tests can use a fast
    /// in-memory `DatabaseQueue`.
    ///
    /// See <https://github.com/groue/GRDB.swift/blob/master/README.md#database-connections>
    let dbWriter: DatabaseWriter

    /// The DatabaseMigrator that defines the database schema.
    ///
    /// See <https://github.com/groue/GRDB.swift/blob/master/Documentation/Migrations.md>
    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()

        migrator.eraseDatabaseOnSchemaChange = false

        #if DEBUG
            // Speed up development by nuking the database when migrations change
            // See https://github.com/groue/GRDB.swift/blob/master/Documentation/Migrations.md#the-erasedatabaseonschemachange-option
            migrator.eraseDatabaseOnSchemaChange = true
        #endif

        migrator.registerMigration("createWorkout") { db in

            /*
             * config and selfie
             */
            try db.create(table: "appIdentity") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("createtime", .datetime).notNull()

                t.column("appstate", .text).notNull()
                t.column("identity", .text).notNull()
            }

            try db.create(table: "selfie") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("createtime", .datetime).notNull()

                t.column("nick", .text).notNull()
                t.column("phone", .text).notNull()
                t.column("gender", .text).notNull()

                t.column("weight", .integer).notNull()
                t.column("weightunit", .text).notNull()
                t.column("height", .integer).notNull()

                t.column("birthyear", .integer).notNull()
                t.column("birthmonth", .integer).notNull()
            }

            try db.create(table: "config") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("createtime", .datetime).notNull()

                t.column("preference", .text).notNull()
                t.column("appearence", .text).notNull()
                t.column("themecolor", .text).notNull()

                t.column("weightunit", .text).notNull()
                t.column("intervalrestinsecs", .integer).notNull()
                t.column("finishmode", .text).notNull()
            }

            try db.create(table: "exerciseconfig") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("createtime", .datetime).notNull()

                t.column("exerciseid", .integer).notNull()
                t.column("mark", .text).notNull()
            }

            try db.create(table: "workout") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("createtime", .datetime).notNull().indexed()
                t.column("name", .text)
                t.column("trainingrecord", .text)
                t.column("stats", .text).notNull()
                t.column("source", .text)
                t.column("workday", .datetime).indexed()
                t.column("nomeaning", .text)
                t.column("begintime", .datetime)
                t.column("endTime", .datetime)
            }

            try db.create(table: "batch") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("workoutid", .integer).notNull().indexed()
                t.column("num", .integer).notNull()
                t.column("createtime", .datetime).notNull()
                t.column("batchnote", .text)
                t.column("type", .text)

                t.uniqueKey(["workoutid", "num"], onConflict: .replace)
            }

            try db.create(table: "Batcheachlog") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("createtime", .datetime).notNull()
                t.column("state", .text).notNull()

                t.column("batchid", .integer).notNull().indexed()
                t.column("workoutid", .integer).notNull().indexed()
                t.column("exerciseid", .integer).notNull().indexed()

                t.column("num", .integer).notNull()
                t.column("repeats", .text).notNull()
                t.column("weight", .text).notNull()
                t.column("weightunit", .text).notNull()
                t.column("rest", .integer)

                t.uniqueKey(["num", "batchid", "exerciseid"], onConflict: .replace)
            }

            try db.create(table: "batchexercisedef") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("createtime", .datetime).notNull()

                t.column("workoutid", .integer).notNull().indexed()
                t.column("batchid", .integer).notNull()
                t.column("exerciseid", .integer).notNull()
                t.column("order", .integer).notNull()

                t.column("minreps", .integer)
                t.column("maxreps", .integer)
                t.column("sets", .integer)

                t.uniqueKey(["batchid", "exerciseid", "order"], onConflict: .replace)
            }

            /*
             * program and plans
             */
            try db.create(table: "plan") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("createtime", .datetime).notNull()

                t.column("programid", .integer).notNull()
                t.column("programname", .text)
            }

            try db.create(table: "plantask") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("createtime", .datetime).notNull()

                t.column("planid", .integer).indexed()
                t.column("programname", .text)
                t.column("workoutid", .integer).notNull().indexed()

                t.column("planday", .text) // .notNull()
                t.column("stats", .text) // .notNull()

                t.uniqueKey(["workoutid"], onConflict: .replace)
            }

            try db.create(table: "program") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("createtime", .datetime).notNull()
                t.column("source", .text).notNull()
                // source

                t.column("programname", .text).notNull()
                t.column("programlevel", .text).notNull()
                t.column("programdescription", .text)
                t.column("trainings", .integer).notNull()
                t.column("days", .integer).notNull()
            }

            try db.create(table: "programeach") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("createtime", .datetime).notNull()

                t.column("programid", .integer).notNull().indexed()
                t.column("workoutid", .integer).notNull().indexed()
                t.column("daynum", .integer).notNull()
            }

            try db.create(table: "progressrule") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("createtime", .datetime).notNull()

                t.column("exerciseid", .integer).notNull()

                t.column("increasing", .boolean).notNull()
                t.column("increasedrate", .integer)
                t.column("finisedtimestoincrease", .integer)

                t.uniqueKey(["exerciseid"], onConflict: .replace)
            }

            /*
             * muscle_analysised
             */
            try db.create(table: "analysisedmuscle") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("createtime", .datetime).notNull().indexed()

                t.column("workoutid", .integer).indexed()
                t.column("muscleid", .text).notNull().indexed()

                t.column("workday", .datetime).notNull().indexed()
                t.column("volume", .numeric).notNull()

                t.uniqueKey(["workoutid", "muscleid"], onConflict: .replace)
            }

            try db.create(table: "analysisedexercise") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("createtime", .datetime).notNull().indexed()

                t.column("exerciseid", .integer).notNull().indexed()
                t.column("workoutid", .integer).notNull().indexed()
                t.column("batchid", .integer).notNull()
                t.column("muscleid", .text).indexed()
                
                // muscleid
                t.column("workday", .datetime).notNull().indexed()

                t.column("volume", .numeric).notNull()
                t.column("onerm", .numeric).notNull()

                t.column("sets", .integer).notNull()
                t.column("minrepeats", .integer).notNull()

                t.column("minweight", .numeric).notNull()
                t.column("maxweight", .numeric).notNull()
            }

            try db.create(table: "exercisepersistable") { t in
                t.autoIncrementedPrimaryKey("id")

                t.column("name", .text).notNull()
                t.column("primarymuscle", .text).notNull()
                t.column("secondarymuscles", .text).notNull()

                t.column("equipments", .text).notNull()
                t.column("calc", .text)
                t.column("type", .text)
                t.column("source", .text)
            }
        }

        migrator.registerMigration("0.0.2") { db in
            try db.alter(table: "workout") { t in
                t.add(column: "level", .text)
            }

            try db.alter(table: "exercisepersistable") { t in
                t.add(column: "deleted", .boolean)
                t.add(column: "systemname", .text)
                t.add(column: "imgname", .text)
            }
        }

        migrator.registerMigration("0.0.3") { db in
            try db.create(table: "appcache") { t in
                t.autoIncrementedPrimaryKey("id")

                t.column("cachekey", .text).notNull()
                t.column("cachevalue", .text).notNull()

                t.uniqueKey(["cachekey"], onConflict: .replace)
            }

            try db.alter(table: "workout") { t in
                t.add(column: "routinetype", .text)
            }

            try db.create(table: "backuprecord") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("createtime", .datetime).notNull().indexed()
                t.column("version", .text).notNull()

                t.column("workoutfinishedid", .integer)
                t.column("workoutidlastid", .integer)

                t.column("exercisefinishedid", .integer)
                t.column("exerciselastid", .integer)

                t.column("programfinishedid", .integer)
                t.column("programlastid", .integer)

                t.column("planfinishedid", .integer)
                t.column("planlastid", .integer)

                t.column("success", .boolean)
                t.column("err", .text)

                t.uniqueKey(["version"], onConflict: .replace)
            }

            try db.create(table: "recoverrecord") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("createtime", .datetime).notNull().indexed()
                t.column("version", .text).notNull()

                t.column("workoutfinishedid", .integer)
                t.column("workoutidlastid", .integer)

                t.column("exercisefinishedid", .integer)
                t.column("exerciselastid", .integer)

                t.column("programfinishedid", .integer)
                t.column("programlastid", .integer)

                t.column("planfinishedid", .integer)
                t.column("planlastid", .integer)

                t.column("analysisedmusclefinishedid", .integer)
                t.column("analysisedmusclelastid", .integer)

                t.column("analysisedexercisefinishedid", .integer)
                t.column("analysisedexerciselastid", .integer)

                t.column("success", .boolean)
                t.column("err", .text)

                t.uniqueKey(["version"], onConflict: .replace)
            }
        }

        migrator.registerMigration("2.4") { db in
            try db.alter(table: "config") { t in
                t.add(column: "afterrest", .text)
            }
        }

        migrator.registerMigration("2.8") { db in
            try db.alter(table: "Batcheachlog") { t in
                t.add(column: "type", .text)
            }
        }

        migrator.registerMigration("2.9") { db in
            try db.create(table: "folder") { t in
                t.autoIncrementedPrimaryKey("id")

                t.column("parentid", .integer)
                t.column("name", .text)
            }

            // folderid
            try db.alter(table: "workout") { t in
                t.add(column: "folderid", .integer)
            }
        }

        /*
         var id: Int64?
         var ident: String
         var level: Musclelevel
         var en: String
         var cn: String
         var groupid: String?
         */
        migrator.registerMigration("3.0") { db in
            /*
             * new muscles
             */
            try db.create(table: "newdisplayedmuscle") { t in
                t.autoIncrementedPrimaryKey("id")

                t.column("ident", .text).notNull()
                t.column("level", .text).notNull()
                t.column("en", .text).notNull()
                t.column("cn", .text).notNull()

                t.column("groupid", .text)
            }

            try db.create(table: "newmuscledef") { t in
                t.autoIncrementedPrimaryKey("id")

                t.column("ident", .text)
                t.column("en", .text)
                t.column("cn", .text)

                t.column("displayedid", .text)
            }

            /*
             * new exercises
             */
            try db.create(table: "newexercisedef") { t in
                t.autoIncrementedPrimaryKey("id")

                t.column("ident", .text)
                t.column("exerciseid", .integer)
                t.column("key", .text)

                t.column("name", .text)
                t.column("imgname", .text)
                t.column("muscleid", .text)
                t.column("displayedprimaryid", .text)
                t.column("displayedgroupid", .text)
                t.column("displayedsecondaryids", .text)

                t.column("equipmentidx", .text)
                t.column("equipmentids", .text)
                t.column("weighttype", .text)
                t.column("source", .text)
                t.column("logtype", .text)

                t.column("deleted", .boolean)
                t.column("cn", .text)
                t.column("en", .text)
            }
            
            /*
             * config add use system
             */
            try db.alter(table: "config") { t in
                t.add(column: "usesystemappearence", .boolean)
            }
            
            // analysisedmuscle
            try db.alter(table: "analysisedmuscle") { t in
                t.add(column: "displaygroupid", .text)
                t.add(column: "displaymainid", .text)
            }
            
        }
        
        migrator.registerMigration("3.10") { db in
            try db.alter(table: "config") { t in
                t.add(column: "useresttimer", .boolean)
                t.add(column: "restinterval", .integer)
                t.add(column: "notifysoundeffect", .text)
            }
            
            try db.alter(table: "workout") { t in
                t.add(column: "focused", .boolean)
            }
            
            
            try db.alter(table: "folder") { t in
                t.add(column: "order", .integer)
            }
        }

        return migrator
    }
}

extension AppDatabase {
    /// The database for the application
    static let shared = makeShared()

    private static func makeShared() -> AppDatabase {
        do {
            // Create a folder for storing the SQLite database, as well as
            // the various temporary files created during normal database
            // operations (https://sqlite.org/tempfiles.html).
            let fileManager = FileManager()
            let folderURL = try fileManager
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("database", isDirectory: true)
            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)

            // Connect to a database on disk
            // See https://github.com/groue/GRDB.swift/blob/master/README.md#database-connections
            let dbURL = folderURL.appendingPathComponent("db.sqlite")

            // log("PATH:     " + dbURL.path)

            let dbPool = try DatabasePool(path: dbURL.path)

            // Create the AppDatabase
            let appDatabase = try AppDatabase(dbPool)

            // Populate the database if it is empty, for better demo purpose.
            // try appDatabase.createRandomPlayersIfEmpty()

            return appDatabase
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate.
            //
            // Typical reasons for an error here include:
            // * The parent directory cannot be created, or disallows writing.
            // * The database is not accessible, due to permissions or data protection when the device is locked.
            // * The device is out of space.
            // * The database could not be migrated to its latest schema version.
            // Check the error message to determine what the actual problem was.
            fatalError("Unresolved error \(error)")
        }
    }
}
