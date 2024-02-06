import SwiftUI

struct analysisedexerciseView: View {
    var exercise: Exercisedef

    init(exercise: Exercisedef) {
        self.exercise = exercise
        log("init ...  analysised view refreshed... ")
    }

    var content: some View {
        analysisedexerciseContentView(exercise: exercise)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .foregroundColor(
                        Color(.systemGray6)
                    )
                    .ignoresSafeArea()
            )
    }

    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 50, height: 5)
                .foregroundColor(Color("Background"))
                .padding(.vertical)

            Text(exercise.realname)
                .font(.system(size: 16).bold())
                .foregroundColor(Color(.systemGray))
                .padding(.bottom)

            VideoView(v: exercise._vName, rate: 1.5)
                .frame(height: 200)
                .padding(.bottom, 30)

            content

            Spacer(minLength: 0)
        }
    }
}

struct analysisedexerciseContentView: View {
    @ObservedObject var model: analysisedexerciseDataViewModel

    init(exercise: Exercisedef) {
        model = analysisedexerciseDataViewModel(exercise)

        log("init ...  analysised view content... ")
    }

    var divider: some View {
        Divider().padding(3)
    }

    var time: some View {
        VStack(spacing: 5) {
            if let f = model.focused {
                /*

                 Text(getShortYearMonthDayHourMinuts(f.trainedTime))
                     .foregroundColor(.primary.opacity(0.7))
                     .font(.system(size: 18))

                  */

                Text("(训练时间)")
                    .foregroundColor(Color(.systemGray2))
                    .font(.system(size: 14).bold())
            }
        }
        .padding(.vertical)
    }

    var body: some View {
        VStack {
            time

            data

            recentAnalysised

            Spacer()
            HStack {
                Spacer()
            }
        }
        .environmentObject(model)
    }

    var recentAnalysised: some View {
        ScrollView(showsIndicators: false) {
            analysisedexerciseGraph()
        }
        .padding()
    }

    func digit(_ value: Double?) -> String {
        if value != nil {
            return String(format: "%.1f", value!)
        } else {
            return "-"
        }
    }

    var volume: some View {
        VStack {
            let _c = model.focused?.volume
            Indicator(value: digit(_c), description: "容量(kg)")
                .onTapGesture {
                    if model.type != .volume {
                        model.type = .volume
                    }
                }
                .foregroundColor(model.type == .volume ? .blue : .clear)
                .frame(width: 80)
        }
    }

    var onerm: some View {
        VStack {
            let _o = model.focused?.onerm
            Indicator(value: digit(_o), description: "1RM(kg)")
                .onTapGesture {
                    if model.type != .onerm {
                        model.type = .onerm
                    }
                }
                .foregroundColor( model.type == .onerm ? .blue : .clear)
                .frame(width: 80)
        }
    }

    var maxweight: some View {
        VStack {
        }
    }

    var data: some View {
        HStack {
            volume

            divider

            onerm

            divider

            maxweight
        }
        .foregroundColor(Color(.systemGray2))
        .frame(height: 50)
        .padding(.vertical)
    }
}

/*
 
 struct analysisedexerciseDataView_Previews: PreviewProvider {
     static var previews: some View {
         analysisedexerciseView(exercise: mockexercisedef())
     }
 }

 
 */

class analysisedexerciseDataViewModel: ObservableObject {
    let exercise: Exercisedef
    var analysisedlist: [Analysisedexercise]
    var id2Analysised: [Int64: Analysisedexercise]

    @Published var type: IndicatorType
    @Published var focused: Analysisedexercise?

    func focus(_ id: Int64) {
        if let found = id2Analysised[id] {
            focused = found
        }
    }

    init(_ exercise: Exercisedef, type: IndicatorType = .volume) {
        self.exercise = exercise
        self.type = type

        analysisedlist = []
        volumeValues = []
        onermValues = []
        maxweights = []
        id2Analysised = [:]

        refresh()
    }

    func refresh() {
        let end = Date()
        let start = Calendar.current.date(byAdding: .day, value: -60, to: end) ?? end
        let interval = DateInterval(start: start, end: end)

        let analysisedlist = AppDatabase.shared.queryanalysisedexercise(interval, exerciseid: exercise.id!)
        if !analysisedlist.isEmpty {
            self.analysisedlist = analysisedlist
            id2Analysised = Dictionary(uniqueKeysWithValues: analysisedlist.map({ ($0.id!, $0) }))
            focused = analysisedlist.last
        }
    }

    var volumeValues: [TimelineGraphValue]
    var onermValues: [TimelineGraphValue]
    var maxweights: [TimelineGraphValue]

    func fetchVolumeValues() -> [TimelineGraphValue] {
        if volumeValues.isEmpty {
            doFetch()
        }
        return volumeValues
    }

    func fetchOneRMValues() -> [TimelineGraphValue] {
        if volumeValues.isEmpty {
            doFetch()
        }
        return onermValues
    }

    func fetchMaxWeights() -> [TimelineGraphValue] {
        if volumeValues.isEmpty {
            doFetch()
        }
        return maxweights
    }

    func doFetch() {
        /*

         analysisedlist.forEach { analysised in

             volumeValues.append(
                 TimelineGraphValue(id: analysised.id!,
                                    time: analysised.trainedTime,
                                    value: analysised.volume)
             )

             onermValues.append(
                 TimelineGraphValue(id: analysised.id!,
                                    time: analysised.trainedTime,
                                    value: analysised.onerm)
             )

             maxweights.append(
                 TimelineGraphValue(id: analysised.id!,
                                    time: analysised.trainedTime,
                                    value: analysised.maxweight)
             )
         }

          */
    }

    var timelineValues: [TimelineGraphValue] {
        switch type {
        case .onerm:
            return fetchOneRMValues()
        case .volume:
            return fetchVolumeValues()
        case .maxweight:
            return fetchMaxWeights()
        }
    }
}

extension analysisedexerciseDataViewModel: TimelineGraphAware {
    func focusedid() -> Int64 {
        focused?.id ?? -1
    }
}

enum IndicatorType {
    case onerm, volume, maxweight
}

struct analysisedexerciseGraph: View {
    @EnvironmentObject var model: analysisedexerciseDataViewModel

    var volume: some View {
        VStack {
            TimelineGraph(model.timelineValues,
                          aware: model,
                          base: model.type == .volume ? 1.0 :
                              (model.type == .onerm ? 0.6 : 0.5)
            )
            .padding(.leading, 30)
        }
    }

    var body: some View {
        VStack {
            volume
        }
    }
}
