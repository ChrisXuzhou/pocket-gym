import GRDB
import SwiftUI
import UIKit

struct Workoutview_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ContentView()
        }
    }
}

func mockemptyworkout() -> Workout {
    try! AppDatabase.shared.deleteworkout(id: -2)

    var mockedworkout = Workout(id: -2,
                                stats: .progressing,
                                name: "",
                                begintime: Date(), endTime: Date())

    try! AppDatabase.shared.saveworkout(&mockedworkout)

    return mockedworkout
}

struct Workoutfacadeview: View {
    @EnvironmentObject var restmodel: Workoutrestmodel
    @EnvironmentObject var model: Workoutmodel

    @StateObject var batchfocused = Logfocused()

    @Binding var present: Bool

    var contentview: some View {
        Workoutview(present: $present)
    }

    var displaypanel: some View {
        VStack {
            if let _timer = restmodel.restimer {
                SPACE
                
                KSTimerView(
                    completedTime: _timer.ofcompletetime,
                    timerInterval: _timer.limittimeinterval) {
                    counter in

                    _timer.callback(counter)

                    withAnimation {
                        restmodel.restimer = nil
                        restmodel.objectWillChange.send()
                    }
                }
                
                SPACE.frame(height: MIN_DOWN_TAB_HEIGHT)
            }
        }
        .padding(.horizontal, 10)
        
    }

    var body: some View {
        ZStack {
            contentview

            displaypanel
            
        }
        .environmentObject(restmodel)
        .environmentObject(batchfocused)
    }
}

let WORKOUTVIEW_EMPTY_HEIGHT: CGFloat = UIScreen.height - (MIN_UP_TAB_HEIGHT + MIN_DOWN_TAB_HEIGHT + WORKOUT_DATA_HEIGHT + 50)

struct Workoutview: View, KeyboardReadable {
    @EnvironmentObject var preference: PreferenceDefinition

    @EnvironmentObject var trainingpreference: TrainingpreferenceDefinition
    @EnvironmentObject var trainingmodel: Trainingmodel
    @EnvironmentObject var model: Workoutmodel

    /*
     * variables
     */
    @Binding var present: Bool

    @State private var isKeyboardVisible = false

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.ignoresSafeArea()

            if model.batchnumberdictionary.isEmpty {
                emptydesc
            }

            VStack(spacing: 0) {
                SPACE.frame(height: MIN_UP_TAB_HEIGHT)

                batchslabel

                SPACE
            }

            if isKeyboardVisible {
                Color.clear
                    .frame(width: UIScreen.width)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        endtextediting()
                    }
                    .ignoresSafeArea(.keyboard)
            }

            operatelayer
        }
        .onTapGesture(perform: {
            endtextediting()
        })
        .onReceive(keyboardPublisher) { newIsKeyboardVisible in
            isKeyboardVisible = newIsKeyboardVisible
        }
    }

    var operatelayer: some View {
        VStack(spacing: 0) {
            Workoutviewuptab(
                present: $present,
                name: preference.language(model.workout.name ?? "")
            )

            SPACE

            Workoutviewdowntab()
        }
        .ignoresSafeArea(.keyboard)
    }

    var emptydesc: some View {
        VStack(alignment: .center, spacing: 30) {
            SPACE.frame(height: UIScreen.height / 3)

            VStack(alignment: .leading, spacing: 20) {
                LocaleText("emptyworkoutreminder1", usefirstuppercase: false, alignment: .leading)

                LocaleText("emptyworkoutreminder2", usefirstuppercase: false, alignment: .leading)
            }

            SPACE
        }
        .frame(width: 220)
        .font(.system(size: DEFINE_FONT_SMALL_SIZE - 1, design: .rounded))
        .foregroundColor(NORMAL_LIGHT_TEXT_COLOR)
        .opacity(0.6)
    }
}

extension Workoutview {
    
    var batchslabel: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ScrollViewReader { proxy in
                VStack(spacing: 10) {
                    if let maxnumber = model.batchnumberdictionary.keys.max() {
                        ForEach(0 ... maxnumber, id: \.self) {
                            number in

                            if let _batch = model.batchnumberdictionary[number]?.first {
                                Batchlabel(batchmodel: _batch)
                            }
                        }
                    }

                    SPACE.frame(height: UIScreen.height / 3)
                }
                .padding(.top, 10)
                .onChange(of: model.unpackedbatchid) { _ in
                    withAnimation {
                        if let _unpackedbatchid = model.unpackedbatchid {
                            proxy.scrollTo(_unpackedbatchid, anchor: .bottom)
                        }
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
    }

    /*
     
     var batchslabel: some View {
         ScrollViewReader {
             reader in

             List {
                 if let maxnumber = model.batchnumberdictionary.keys.max() {
                     ForEach(0 ... maxnumber, id: \.self) {
                         number in

                         if let _batch = model.batchnumberdictionary[number]?.first {
                             Batchlabel(batchmodel: _batch).listRowInsets(.init(top: 10, leading: 0, bottom: 0, trailing: 0))
                                 .listRowSeparator(.hidden)
                                 .listRowBackground(NORMAL_BG_COLOR)
                         }
                     }
                     .onChange(of: model.unpackedbatchid) { _ in
                         withAnimation {
                             if let _unpackedbatchid = model.unpackedbatchid {
                                 reader.scrollTo(_unpackedbatchid, anchor: .bottom)
                             }
                         }
                     }
                 }
             }
             .background(NORMAL_BG_COLOR)
             .listStyle(.plain)
             .buttonStyle(BorderlessButtonStyle())
         }
     }
     

     */
}
