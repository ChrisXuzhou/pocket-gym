import Combine
import SwiftUI

struct Logcontent_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ContentView()
        }
    }
}

func mockbatcheachlog() -> Batcheachlog {
    Batcheachlog(workoutid: -1, batchid: -1, exerciseid: 4005,
                 num: 0,
                 repeats: 15,
                 weight: 30.0,
                 weightunit: .kg
    )
}

let LOG_CONTENT_HEIGHT: CGFloat = 40

let LOG_CONTENT_WIDTH = UIScreen.width - 100
var LOG_CONTENT_EACH_WIDTH: CGFloat = LOG_CONTENT_WIDTH / 3

class Logvalue: ObservableObject {
    @Published var repeats: String = ""
    @Published var weight: String = ""
    
    init(_ batcheachlog: Batcheachlogwrapper) {
        if batcheachlog.batcheachlog.isfinished {
            repeats = "\(batcheachlog.batcheachlog.repeats)"
            weight = String(format: "%.1f", batcheachlog.batcheachlog.weight)
        }
    }
    
}

struct Logcontent: View {
    @EnvironmentObject var trainingpreference: TrainingpreferenceDefinition
    @EnvironmentObject var logfocused: Logfocused
    @EnvironmentObject var values: Logvalue

    init(showprevious: Bool = true,
         fontsize: CGFloat = DEFINE_FONT_SIZE,
         batcheachlog: Batcheachlogwrapper) {
        var type: Logtype = .reps
        if let _exercise = batcheachlog.batcheachlog.relatedexercise {
            type = _exercise.exercise.logtype
        }

        self.type = type
        self.showprevious = showprevious
        self.fontsize = fontsize

        self.batcheachlog = batcheachlog
    }

    var type: Logtype
    var fontsize: CGFloat
    var showprevious: Bool
    @ObservedObject var batcheachlog: Batcheachlogwrapper

    func focus() {
        logfocused.forcefocus(batcheachlog)
    }

    @FocusState private var repeatsfocused: Bool
    @FocusState private var weightfocused: Bool

    var body: some View {
        HStack(spacing: 0) {

            if showprevious {
                previouslable
            }

            repeatlabel

            if type == .repsandweight {
                weightlabel
            }

            SPACE
        }
        .frame(width: LOG_CONTENT_WIDTH, height: LOG_CONTENT_HEIGHT)
    }
}

extension Logcontent {
    var previouslable: some View {
        HStack {
            let _text: String = type.display(batcheachlog.previous,
                                             weightunit: trainingpreference.weightunit)
            Text(_text)
        }
        .multilineTextAlignment(.center)
        .font(.system(size: fontsize - 4))
        .foregroundColor(NORMAL_BUTTON_COLOR)
        .frame(width: LOG_CONTENT_EACH_WIDTH)
    }

    var repeatlabel: some View {
        HStack {
            TextField("\(batcheachlog.batcheachlog.repeats)",
                      text: $values.repeats,
                      onEditingChanged: { editing in
                          if editing {
                              self.$values.repeats.wrappedValue = ""
                          }
                      }
            )
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .focused($repeatsfocused)
        }
        .font(.system(size: fontsize))
        .frame(width: LOG_CONTENT_EACH_WIDTH)
        .contentShape(Rectangle())
        .onTapGesture {
            repeatsfocused = true
            focus()
        }
        .onChange(of: repeatsfocused) { focused in
            if !focused {
                if let _repeats = Int(values.repeats) {
                    batcheachlog.batcheachlog.repeats = _repeats
                    try! AppDatabase.shared.savebatcheachlog(&batcheachlog.batcheachlog)
                } else {
                    self.$values.repeats.wrappedValue = "\(batcheachlog.batcheachlog.repeats)"
                }
            }
        }
    }

    var weightlabel: some View {
        HStack {
            /*
             TextField("\(String(format: "%.1f", batcheachlog.batcheachlog.weight))",
                       value: $values.weight,
                       format: .number
             )
             */
            TextField("\(String(format: "%.1f", batcheachlog.batcheachlog.weight))",
                      text: $values.weight,
                      onEditingChanged: { editing in
                          if editing {
                              self.$values.weight.wrappedValue = ""
                          }
                      }
            )
            .multilineTextAlignment(.center)
            .keyboardType(.decimalPad)
            .focused($weightfocused)
        }
        .font(.system(size: fontsize))
        .frame(width: LOG_CONTENT_EACH_WIDTH)
        .contentShape(Rectangle())
        .onTapGesture {
            weightfocused = true
            focus()
        }
        .onChange(of: weightfocused) { focused in

            if !focused {
                if let _weight = Double(values.weight) {
                    batcheachlog.batcheachlog.weight = _weight
                    try! AppDatabase.shared.savebatcheachlog(&batcheachlog.batcheachlog)

                    values.weight = String(format: "%.1f", _weight)
                } else {
                    self.$values.weight.wrappedValue = String(format: "%.1f", batcheachlog.batcheachlog.weight)
                }
            }
        }
    }
}

struct Logcontentheader: View {
    var weightunit: Weightunit
    var type: Logtype = .repsandweight

    var showprevious: Bool = true
    var showrestime: Bool = false

    var body: some View {
        HStack(alignment: .lastTextBaseline, spacing: 0) {
            if showprevious {
                LocaleText("previous", uppercase: true)
                    .frame(width: LOG_CONTENT_EACH_WIDTH)
            }

            LocaleText("reps", uppercase: true)
                .frame(width: LOG_CONTENT_EACH_WIDTH)

            if type == .repsandweight {
                LocaleText(weightunit.name, uppercase: true)
                    .frame(width: LOG_CONTENT_EACH_WIDTH)
            }

            if showrestime {
                LocaleText("rest", uppercase: true)
                    .frame(width: LOG_CONTENT_EACH_WIDTH)
            }
        }
        .frame(width: LOG_CONTENT_WIDTH, height: LOG_CONTENT_HEIGHT)
        .foregroundColor(BATCH_LABEL_BUTTON_COLOR)
        .font(
            .system(size: DEFINE_FONT_SMALLEST_SIZE, design: .rounded)
                .bold()
        )
    }
}

/*

 */
