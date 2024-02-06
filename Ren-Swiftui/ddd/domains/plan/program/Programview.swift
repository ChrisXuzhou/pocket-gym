//
//  PlanprogramdetailView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/22.
//


import SwiftUI

struct Programview_Previews: PreviewProvider {
    static var previews: some View {
        let mockedworkout = mockworkout()
        let mockedprogrameachlist = mockprogrameachlist()
        let mockedprograms: [Program] = mockprogramlist()

        DisplayedView {
            Programview(
                program: mockedprograms[0],
                useprogram: true
            )
        }
    }
}

class Viewshowsummary: ObservableObject {
    @Published var value: Bool = true

    init(_ showsummary: Bool = true) {
        value = showsummary
    }
}

struct Programview: View {
    @Environment(\.presentationMode) var presentmode

    init(program: Program,
         useprogram: Bool = false, editing: Bool = false) {
        _model = StateObject(wrappedValue: Programmodel(program))

        self.useprogram = useprogram
        initediting = editing
    }

    @EnvironmentObject var preference: PreferenceDefinition
    @StateObject var model: Programmodel

    var useprogram: Bool
    var initediting: Bool

    /*
     * summary header
     */
    @StateObject var showsummary = Viewshowsummary()
    @StateObject var editprogram = Viewedit()

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

            daysview

            let _description: String = preference.language(model.program.programdescription ?? "")

            if !_description.isEmpty {
                VStack(alignment: .leading) {
                    HStack {
                        LocaleText("description", usefirstuppercase: false, linelimit: 1)
                            .font(.system(size: DEFINE_FONT_SMALL_SIZE - 1))
                            .frame(alignment: .leading)
                            .foregroundColor(NORMAL_COLOR)

                        SPACE
                    }
                    .padding(.vertical, 5)

                    Text(_description)
                        .tracking(0.6)
                        .lineLimit(30)
                        .minimumScaleFactor(0.01)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(4)
                        .font(.system(size: DEFINE_FONT_SMALLER_SIZE - 1))
                        .foregroundColor(NORMAL_LIGHTER_COLOR)
                        .padding(.vertical, 5)
                }
                .padding()
                .background(
                    NORMAL_BG_CARD_COLOR
                )
            }

            workoutpreview

            Copyright()

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
        .environmentObject(model)
        .environmentObject(editprogram)
    }
}

extension Programview {
    /*
     * scroll header summary related.
     */
    var operationlayer: some View {
        VStack {
            Programuptab(
                showsummary: $showsummary.value,
                program: model.program
            )
            .onAppear {
                if initediting {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        editprogram.value = true
                    }
                }
            }

            SPACE

            if useprogram {
                Useprogrambutton()
            }
        }
    }

    var summarybackground: some View {
        ZStack {
            if let _programid = model.program.id {
                Imageplanbackground(secondid: _programid)
                    .ignoresSafeArea()
            }
        }
        .clipped()
        .contentShape(Rectangle())
    }

    var summarytitle: some View {
        VStack(alignment: .leading, spacing: 0) {
            SPACE

            LocaleText(model.program.programname)
                .font(
                    .system(size: DEFINE_FONT_BIGGEST_SIZE)
                        .weight(.heavy)
                )
                .frame(minHeight: 50)

            HStack(spacing: 30) {
                LocaleText(model.program.programlevel.rawValue)

                SPACE
            }
            .font(
                .system(size: DEFINE_FONT_SMALLER_SIZE)
                    .bold()
            )
            .frame(height: 30)

            SPACE.frame(height: 50)
        }
        .foregroundColor(.white)
        .padding(.horizontal)
        .frame(width: UIScreen.width)
        .onAppear {
            self.showsummary.value = true
        }
        .onDisappear {
            self.showsummary.value = false
        }
    }

    var summarylabel: some View {
        ZStack {
            summarybackground

            summarytitle
        }
        .clipShape(Rectangle())
        .clipped()
    }
}

/*

     Image("schedule")
         .renderingMode(.template)
         .resizable()
         .frame(width: 20, height: 20)
         .foregroundColor(Color(.systemGray))
         .frame(width: 25, height: 25, alignment: .leading)
         .padding(.trailing, 5)

 */
extension Programview {
    /*
     * program days
     */
    var daysview: some View {
        HStack {
            Text("\(model.program.days)  \(preference.language("days", firstletteruppercase: false))")
                .font(.system(size: DEFINE_FONT_SMALL_SIZE - 1))
                .frame(alignment: .leading)
                .foregroundColor(NORMAL_COLOR)

            SPACE
        }
        .padding(.horizontal)
        .frame(height: LIST_ITEM_HEIGHT)
        .background(
            NORMAL_BG_CARD_COLOR
        )
    }
}

extension Programview {
    /*
     * description
     */
    var plandescriptionview: some View {
        ZStack {
        }
    }
}

extension Programview {
    /*
     * workout preview
     */
    var workoutpreview: some View {
        VStack {
            HStack {
                LocaleText("workoutpreview", usefirstuppercase: false, linelimit: 1)
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE - 1))
                    .frame(alignment: .leading)
                    .foregroundColor(NORMAL_COLOR)
                    
                    

                SPACE
            }
            .padding(.vertical)
            .padding(.top, 5)

            Programeachlist()
        }
        .padding(.horizontal)
        .background(
            NORMAL_BG_CARD_COLOR
        )
    }
}
