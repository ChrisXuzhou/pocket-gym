//
//  Routinebetaview.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/9/29.
//

import SwiftUI

struct Routinebetaview_Previews: PreviewProvider {
    static var previews: some View {
        let mockedtemplate = mocktemplate()

        DisplayedView {
            Routinebetaview(
                routine: Routine(mockedtemplate)
            )
        }
    }
}

let SAFEAREA_UP_HEIGHT: CGFloat = 20
let ROUTINE_VIEW_UP_HEIGHT: CGFloat = MAX_UP_TAB_HEIGHT
let ROUTINE_VIEW_UP_FULL_HEIGHT: CGFloat = ROUTINE_VIEW_UP_HEIGHT

/*
 * all workout state here in routinebetaview is template.  NOT WORKOUT !
 */
struct Routinebetaview: View {
    @Binding var present: Bool
    @Environment(\.presentationMode) var presentmode

    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var trainingmodel: Trainingmodel

    @StateObject var viewmodel: Routineviewmodel
    @StateObject var routine: Routine

    init(present: Binding<Bool> = .constant(false),
         routineusage: Routineusage? = .onlyview,
         routine: Routine) {
        _present = present

        _viewmodel =
            StateObject(wrappedValue:
                Routineviewmodel(
                    state: .template,
                    templateusage: routineusage,
                    editing: false
                )
            )

        _routine =
            StateObject(wrappedValue: routine)

        _showsummary = StateObject(wrappedValue: Viewshowsummary())
    }

    /*
     * view variables
     */
    @StateObject var showsummary: Viewshowsummary
    @FocusState private var editingname: Bool
    
    var summarytitle: some View = Routinebetasummary()
        .padding(.leading)
        .frame(width: UIScreen.width)

    var contentlayer: some View {
        ScrollView(.vertical, showsIndicators: false) {
            GeometryReader {
                geometry in

                if geometry.frame(in: .global).minY < 0 {
                    summarybackground
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .offset(y: geometry.frame(in: .global).minY / 9)
                        .clipped()

                } else {
                    summarylabel
                        .frame(width: geometry.size.width, height: geometry.size.height + geometry.frame(in: .global).minY)
                        .clipped()
                        .offset(y: -geometry.frame(in: .global).minY)
                }
            }
            .frame(height: UIScreen.height * UPHEADER_FACTOR)

            equipmentslabel

            muscleslabel

            routinebatchlabels

            SPACE

            COPYRIGHT

            SPACE.frame(height: MIN_UP_TAB_HEIGHT)
        }
        .edgesIgnoringSafeArea([.top])
    }

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.ignoresSafeArea()

            contentlayer

            operationlayer
        }
        .environmentObject(routine)
        .environmentObject(viewmodel)
        .onTapGesture {
            endtextediting()
        }
    }
}

extension Routinebetaview {
    var operationlayer: some View {
        VStack(spacing: 0) {
            Routinebetaviewuptab(
                present: $present,
                showsummary: $showsummary.value
            )

            SPACE

            routinedowntab
        }
    }

    var routinedowntab: some View {
        VStack {
            if viewmodel.vieweditatble == .onlyview {
                if viewmodel.templateusage == .usetemplate {
                    Routineusebutton()
                }
            }

            if viewmodel.vieweditatble == .editable {
                Routineaddexercisebutton()
            }
        }
    }
}

/*
 * routine content related.
 */
extension Routinebetaview {
    var equipmentslabel: some View {
        VStack(alignment: .leading) {
            bartitle("equipments")

            let namestrlist = routine.equipments.map({ preference.language($0) }).joined(separator: preference.ofcomma)

            if namestrlist.isEmpty {
                Emptycontentpanel()
            } else {
                HStack {
                    Text(namestrlist)
                        .font(.system(size: DEFINE_FONT_SMALLER_SIZE + 1))
                        .foregroundColor(NORMAL_LIGHTER_COLOR)
                        .lineLimit(3)
                        .lineSpacing(5)

                    SPACE
                }
            }
        }
        .padding()
        .background(
            NORMAL_BG_CARD_COLOR
        )
    }

    var muscleslabel: some View {
        VStack(alignment: .leading) {
            bartitle("targetarea")

            let muscledefs = routine.muscledefs

            if muscledefs.isEmpty {
                Emptycontentpanel()
            } else {
                HStack(spacing: 0) {
                    Text(muscledefs.joined(separator: preference.ofcomma))
                        .font(.system(size: DEFINE_FONT_SMALLER_SIZE + 1))
                        .foregroundColor(NORMAL_LIGHTER_COLOR)
                        .lineLimit(3)
                        .lineSpacing(5)

                    SPACE
                }
            }
        }
        .padding()
        .background(
            NORMAL_BG_CARD_COLOR
        )
    }

    var routinebatchlabels: some View {
        VStack(alignment: .leading) {
            bartitle("exerciselist")

            if routine.batchs.isEmpty {
                Emptycontentpanel()
            }

            VStack(spacing: 0) {
                ForEach(0 ..< routine.batchs.count, id: \.self) {
                    idx in

                    VStack(spacing: 0) {
                        Routinebetabatchpanel(batch: routine.batchs[idx])

                        if idx != routine.batchs.count - 1 {
                            LOCAL_DIVIDER.padding(.top)
                        }
                    }
                }
            }
            
            SPACE
        }
        .frame(minHeight: 120)
        .padding()
        .background {
            NORMAL_BG_CARD_COLOR
        }
    }
}

extension Routinebetaview {
    var summarybackground: some View {
        ZStack {
            if let _routineid = routine.routine.id {
                ofbgtemplateimage(_routineid)
                    .resizable()
                    .aspectRatio(contentMode: .fill)

                Color.gray.opacity(0.6).ignoresSafeArea()
            }
        }
        .clipped()
        .contentShape(Rectangle())
    }

    var summarylabel: some View {
        ZStack {
            summarybackground

            summarytitle
                .id(routine.routine.name)
        }
        .clipShape(Rectangle())
        .clipped()
        .onAppear {
            self.showsummary.value = true
        }
        .onDisappear {
            self.showsummary.value = false
        }
    }
}

extension Routinebetaview {
    var routinetypenotes: some View {
        HStack {
            LocaleText("routinetypedesc",
                       usefirstuppercase: false, linelimit: 4)

                .font(.system(size: DEFINE_FONT_SMALLER_SIZE - 2))
                .lineSpacing(5)

            SPACE
        }
        .foregroundColor(NORMAL_LIGHTER_COLOR)
        .padding(.horizontal)
        .padding(.top)
    }
}

extension Routinebetaview {
    var exportsummaryview: some View {
        VStack {
            /*
             if showexportview {
                 if let _id = model.workout.id {
                     Workoutfinishedlabel(present: $showexportview, workoutid: _id)
                 }
             }
             */
        }
    }
}
