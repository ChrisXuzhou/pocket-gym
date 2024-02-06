import AVKit
import Foundation
import SwiftUI
import UIKit

func decideschemecolor(
    usesystem: Bool = PreferenceDefinition.shared.ofusesystemappearance,
    appearance: Appearence = PreferenceDefinition.shared.ofappearence) {
    UIApplication.shared.windows.first?.overrideUserInterfaceStyle =
        usesystem == true ? .unspecified :
        (
            appearance == .dark ? .dark : .light
        )
}

class Viewopenswitch: ObservableObject {
    @Published var value: Bool = false

    init(_ value: Bool = false) {
        self.value = value
    }
}

/*
 * threads
 */
extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Double) async throws {
        let duration = UInt64(seconds * 1000000000)
        try await Task.sleep(nanoseconds: duration)
    }
}

let CLOSE_IMG: some View = Image(systemName: "multiply")
    .font(.system(size: DEFINE_FONT_BIG_SIZE + 2).bold())
    .foregroundColor(NORMAL_LIGHTER_COLOR)

/*
 * definitions
 */

public var FREE_WORKOUTS_LIMIT: Int = 8
public var UPHEADER_FACTOR: CGFloat = 0.38

public var DEFAULT_ID: Int = -1
public var ONE_DAY_SECONDS: Int = 60 * 60 * 24

/*
  content related
 */
let CONTENT_PADDING: CGFloat = 15
let MIN_LIST_HEIGHT: CGFloat = 72

/*
 * down tab related
 */
let DOWN_TAB_PADDING: CGFloat = 20

/*
 * popup related
 */
let NORMAL_POPUP_HEIGHT: CGFloat = UIScreen.height / 2
let OVERLAYED_GRAY: some View = Color(.systemGray4).opacity(0.8).ignoresSafeArea()

extension UIScreen {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let size = UIScreen.main.bounds.size
}

public func log(_ str: String) {
    // NSLog(str)
    // print(str)
}

public func load<T: Decodable>(_ filename: String) -> T? {
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        // log("could not find\(filename) in main bundle.")
        return nil
    }

    let data: Data
    do {
        data = try Data(contentsOf: file)
    } catch {
        log("could not load \(filename) from main bundle.")
        return nil
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch let jsonError as NSError {
        log("JSON decode failed: \(jsonError), \(filename)")
        return nil
    } catch {
        log("decode data error:  \(filename) ")
        return nil
    }
}

public func loadStr(_ filename: String) -> String {
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError("could not find\(filename) in main bundle.")
    }

    let data: Data
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("could not load \(filename) from main bundle.")
    }

    let str = String(decoding: data, as: UTF8.self)
    return str
}

extension UIColor {
    static let aluminum = UIColor(red: 153 / 255, green: 153 / 255, blue: 153 / 255, alpha: 1.0)
    static let aqua = UIColor(red: 0 / 255, green: 128 / 255, blue: 255 / 255, alpha: 1.0)
    static let asparagus = UIColor(red: 128 / 255, green: 120 / 255, blue: 0 / 255, alpha: 1.0)
    static let banana = UIColor(red: 255 / 255, green: 255 / 255, blue: 102 / 255, alpha: 1.0)
    static let blueberry = UIColor(red: 0 / 255, green: 0 / 255, blue: 255 / 255, alpha: 1.0)
    static let bubblegum = UIColor(red: 255 / 255, green: 102 / 255, blue: 255 / 255, alpha: 1.0)
    static let cantalope = UIColor(red: 255 / 255, green: 204 / 255, blue: 102 / 255, alpha: 1.0)
    static let carnation = UIColor(red: 255 / 255, green: 111 / 255, blue: 207 / 255, alpha: 1.0)
    static let cayenne = UIColor(red: 128 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1.0)
    static let clover = UIColor(red: 0 / 255, green: 128 / 255, blue: 0 / 255, alpha: 1.0)
    static let eggplant = UIColor(red: 64 / 255, green: 0 / 255, blue: 128 / 255, alpha: 1.0)
    static let fern = UIColor(red: 64 / 255, green: 128 / 255, blue: 0 / 255, alpha: 1.0)
    static let flora = UIColor(red: 102 / 255, green: 255 / 255, blue: 102 / 255, alpha: 1.0)
    static let grape = UIColor(red: 128 / 255, green: 0 / 255, blue: 255 / 255, alpha: 1.0)
    static let honeydew = UIColor(red: 204 / 255, green: 255 / 255, blue: 102 / 255, alpha: 1.0)
    static let ice = UIColor(red: 102 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1.0)
    static let iron = UIColor(red: 76 / 255, green: 76 / 255, blue: 76 / 255, alpha: 1.0)
    static let lavender = UIColor(red: 204 / 255, green: 102 / 255, blue: 255 / 255, alpha: 1.0)
    static let lead = UIColor(red: 25 / 255, green: 25 / 255, blue: 25 / 255, alpha: 1.0)
    static let lemon = UIColor(red: 255 / 255, green: 255 / 255, blue: 0 / 255, alpha: 1.0)
    static let licorice = UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1.0)
    static let lime = UIColor(red: 128 / 255, green: 255 / 255, blue: 0 / 255, alpha: 1.0)
    static let magenta = UIColor(red: 255 / 255, green: 0 / 255, blue: 255 / 255, alpha: 1.0)
    static let magnesium = UIColor(red: 179 / 255, green: 179 / 255, blue: 179 / 255, alpha: 1.0)
    static let maraschino = UIColor(red: 255 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1.0)
    static let maroon = UIColor(red: 128 / 255, green: 0 / 255, blue: 64 / 255, alpha: 1.0)
    static let mercury = UIColor(red: 230 / 255, green: 230 / 255, blue: 230 / 255, alpha: 1.0)
    static let midnight = UIColor(red: 0 / 255, green: 0 / 255, blue: 128 / 255, alpha: 1.0)
    static let mocha = UIColor(red: 128 / 255, green: 64 / 255, blue: 0 / 255, alpha: 1.0)
    static let moss = UIColor(red: 0 / 255, green: 128 / 255, blue: 64 / 255, alpha: 1.0)
    static let nickel = UIColor(red: 128 / 255, green: 128 / 255, blue: 128 / 255, alpha: 1.0)
    static let ocean = UIColor(red: 0 / 255, green: 64 / 255, blue: 128 / 255, alpha: 1.0)
    static let orchid = UIColor(red: 102 / 255, green: 102 / 255, blue: 255 / 255, alpha: 1.0)
    static let plum = UIColor(red: 128 / 255, green: 0 / 255, blue: 128 / 255, alpha: 1.0)
    static let salmon = UIColor(red: 255 / 255, green: 102 / 255, blue: 102 / 255, alpha: 1.0)
    static let seafoam = UIColor(red: 0 / 255, green: 255 / 255, blue: 128 / 255, alpha: 1.0)
    static let silver = UIColor(red: 204 / 255, green: 204 / 255, blue: 204 / 255, alpha: 1.0)
    static let sky = UIColor(red: 102 / 255, green: 204 / 255, blue: 255 / 255, alpha: 1.0)
    static let snow = UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1.0)
    static let spindrift = UIColor(red: 102 / 255, green: 255 / 255, blue: 204 / 255, alpha: 1.0)
    static let spring = UIColor(red: 0 / 255, green: 255 / 255, blue: 0 / 255, alpha: 1.0)
    static let steel = UIColor(red: 102 / 255, green: 102 / 255, blue: 102 / 255, alpha: 1.0)
    static let strawberry = UIColor(red: 255 / 255, green: 0 / 255, blue: 128 / 255, alpha: 1.0)
    static let tangerine = UIColor(red: 255 / 255, green: 128 / 255, blue: 0 / 255, alpha: 1.0)
    static let teal = UIColor(red: 0 / 255, green: 128 / 255, blue: 128 / 255, alpha: 1.0)
    static let tin = UIColor(red: 127 / 255, green: 127 / 255, blue: 127 / 255, alpha: 1.0)
    static let tungsten = UIColor(red: 51 / 255, green: 51 / 255, blue: 51 / 255, alpha: 1.0)
    static let turquoise = UIColor(red: 0 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1.0)
}

extension View {
    func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> TupleView<(Self?, Content?)> {
        if conditional {
            return TupleView((nil, content(self)))
        } else {
            return TupleView((self, nil))
        }
    }
}

public func getLunarDay(solarDate: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "zh-Tw_POSIX")
    formatter.dateStyle = .medium

    formatter.dateFormat = "dd"

    let lunarCalendar = Calendar(identifier: .chinese)
    formatter.calendar = lunarCalendar
    return formatter.string(from: solarDate)
}

public func getYearMongth(solarDate: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy年M月"
    return formatter.string(from: solarDate)
}

public func getYearMonthDay(solarDate: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy年M月d日"
    return formatter.string(from: solarDate)
}

public func getShortYearMonthDay(solarDate: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMdd"
    return formatter.string(from: solarDate)
}

public func getShortYearMonthDayHourMinuts(_ solarDate: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM-dd HH:mm"
    return formatter.string(from: solarDate)
}

public func getHourMinuts(_ solarDate: Date) -> String {
    let outputFormatter = DateFormatter()
    outputFormatter.timeStyle = .short
    outputFormatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "en")

    let output = outputFormatter.string(from: solarDate)
    log(output)
    return output
}

public func getYearMonth(solarDate: Date) -> String {
    let outputFormatter = DateFormatter()
    outputFormatter.dateStyle = .medium
    outputFormatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "en")

    let output = outputFormatter.string(from: solarDate)
    log(output)
    return output
}

public func getYearMonthDayHourMinuts(solarDate: Date) -> String {
    let outputFormatter = DateFormatter()
    outputFormatter.dateStyle = .medium
    outputFormatter.timeStyle = .short
    outputFormatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "en")

    let output = outputFormatter.string(from: solarDate)
    log(output)
    return output
}

public func displayShortTime(_ solarDate: Date) -> String {
    let outputFormatter = DateFormatter()
    outputFormatter.dateStyle = .short
    outputFormatter.timeStyle = .short
    outputFormatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "en")

    let output = outputFormatter.string(from: solarDate)
    log(output)
    return output
}

public func secondstohoursminutesseconds(_ seconds: Int) -> (Int, Int, Int) {
    return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
}

public func secondsToDaysHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int, Int) {
    return (seconds / 86400, (seconds % 86400) / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
}

public func startOfCurrentMonth() -> Date {
    var currentMonth = Date()
    if let monthInterval = Calendar.current.dateInterval(of: .month, for: Date()) {
        currentMonth = monthInterval.start
    }
    return currentMonth
}

func seconds2HourMinutsOrSeconds(_ seconds: Int) -> String {
    let ret = secondstohoursminutesseconds(seconds)
    let hours = ret.0
    let minuts = ret.1
    let seconds = ret.2

    if hours == 0 && minuts == 0 {
        return seconds.description + "s"
    }

    var display = ""
    if minuts > 0 {
        display = minuts.description + "m"
    }
    if hours > 0 {
        display = hours.description + "h" + display
    }

    if display.isEmpty {
        return "0m"
    }

    return display
}

func seconds2dayshourminuts(_ seconds: Int) -> String {
    let ret = secondsToDaysHoursMinutesSeconds(seconds)
    let days = ret.0
    let hours = ret.1
    let minuts = ret.2
    let seconds = ret.3

    var display = ""

    if days > 0 {
        display += (days.description + "d")
        return display
    }
    if hours > 0 {
        display += (hours.description + "h")
        return display
    }
    if minuts > 0 {
        display += (minuts.description + "m")
        return display
    }
    if seconds > 0 {
        display += (seconds.description + "s")
        return display
    }

    if seconds == 0 {
        return "0s"
    }

    return "-"
}

func _dayshoursMinutsFromNow(_ date: Date) -> String {
    let seconds = Date().seconds(from: date)
    return seconds2dayshourminuts(seconds)
}

func readDateinstring(_ dateinstring: String) -> Date {
    let dateFormatter = DateFormatter()

    // Set Date Format
    dateFormatter.dateFormat = "yyyyMMdd"
    return dateFormatter.date(from: dateinstring) ?? Date()
}

func fetchdevicelanguage() -> Language {
    let systemlanguage = NSLocale.preferredLanguages[0]

    return
        systemlanguage.hasPrefix("zh-Hans") ? .simpledchinese : .english
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

func getSafeImage(named: String) -> Image? {
    if let uiImage = UIImage(named: named) {
        return Image(uiImage: uiImage)
    }
    return nil
}

func transformmp4() {
    for each in Libraryexercisemodel.shared.all {
        let imgname = each.exercise.imgname
        log("\(each.realname), \(imgname)")

        if let url = Bundle.main.url(forResource: imgname, withExtension: "mp4") {
            AVAsset(url: url).generateThumbnail {
                image in

                guard let image = image else { return }
                let img = Image(uiImage: image)

                if let data = image.pngData() {
                    if let docurl = getDocumentsDirectory() {
                        let filename = docurl.appendingPathComponent("\(imgname).png")
                        try? data.write(to: filename)
                    }
                }
            }
        }
    }
}
