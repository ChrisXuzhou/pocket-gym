//
//  Routinebetabatchpanel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/9/30.
//

import SwiftUI

struct Routinebetabatchpanel: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var viewmodel: Routineviewmodel
    @EnvironmentObject var routine: Routine

    var editing: Bool
    @ObservedObject var batch: Routinebetabatch

    init(editing: Bool = false,
         batch: Routinebetabatch) {
        self.editing = editing
        self.batch = batch
    }

    @StateObject var showreplacelibrary = Showreplacelibrary()
    @StateObject var shownoteseditor = Shownoteseditor()
    @StateObject var viewmore = Viewmore()
    @StateObject var reorderexercises = Viewopenswitch()

    /*
     * funtion variables
     */
    var headerfontsize: CGFloat = DEFINE_FONT_SMALL_SIZE + 1
    var fontsize: CGFloat = DEFINE_FONT_SMALL_SIZE - 1

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            batchheader

            VStack(alignment: .leading, spacing: 15) {
                ForEach(0 ..< batch.batchexercisedefs.count, id: \.self) {
                    idx in

                    let def = batch.batchexercisedefs[idx]
                    Routinebetaexercisedefpanel(
                        editing: editing,
                        displayexercisename: batch.batchexercisedefs.count > 1,
                        displayoverloadingbutton: !editing,
                        batchexercisedef: def
                    )
                    .id(idx)
                }
                
            }
        }
    }
}

/*
 * view related
 */
extension Routinebetabatchpanel {
    var batchheader: some View {
        HStack(alignment: .center, spacing: 3) {
            if batch.batchexercisedefs.count == 1 {
                LocaleText(batch.batchexercisedefs.first?.batchexercisedef.ofexercisedef?.realname ?? "")
                    .foregroundColor(NORMAL_LIGHTER_COLOR)
                    .font(.system(size: fontsize - 1))
            } else if batch.batchexercisedefs.count > 1 {
                LocaleText(batch.batchexercisedefs.count < 3 ? LANGUAGE_SUPERGROUP : LANGUAGE_GIANTGROUP, uppercase: true)
                    .foregroundColor(NORMAL_LIGHTER_COLOR)
                    .font(.system(size: fontsize))
                Text("x \(batch.batchexercisedefs.count)").foregroundColor(Color.orange).bold()
                    .font(.system(size: fontsize))
            }

            SPACE

            if editing {
                morebutton
            }
        }
        .foregroundColor(NORMAL_LIGHT_TEXT_COLOR)
        .frame(height: 40)
        .padding(.top, 5)
    }
    
    var morebutton: some View {
        Menu {
            /*
             Button("\(preference.language("replaceexercise"))") {
                 showreplacelibrary.value = true
             }
             
             Button("\(preference.language("reorderexercise"))") {
                 reorderexercises.value = true
             }
             
             Button("\(preference.language("duplicateexercise"))") {
                 copybatch()
             }
             
             Button("\(preference.language("delete"))", role: .destructive) {
                 deletebatch()
             }
             */
            
            Button {
                showreplacelibrary.value = true
            } label: {
                Label("\(preference.language("replaceexercise"))", systemImage: "arrow.left.arrow.right")
            }
            
            Button {
                reorderexercises.value = true
            } label: {
                Label("\(preference.language("reorderexercise"))", systemImage: "arrow.up.arrow.down")
            }
            
            Button {
                copybatch()
            } label: {
                Label("\(preference.language("duplicateexercise"))", systemImage: "square.on.square")
            }
            
            Button(role: .destructive) {
                deletebatch()
            } label: {
                Label("\(preference.language("delete"))", systemImage: "trash")
            }

        } label: {
            Label("", systemImage: "ellipsis")
        }
        .menuStyle(Localmenustyle())
        .frame(height: 16)
        .contentShape(Rectangle())
        .fullScreenCover(isPresented: $showreplacelibrary.value) {
            NavigationView {
                LibraryreplaceView() {
                    libraryusage in
                    
                    let list = libraryusage.libraryaction?.selectedarray ?? []
                    if !list.isEmpty {
                        batch.replaceexercises(list)
                    }
                    
                    showreplacelibrary.value = false
                }
                .environmentObject(batch)
                .environmentObject(TrainingpreferenceDefinition.shared)
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
            }
        }
        .fullScreenCover(isPresented: $reorderexercises.value) {
            Batchlistreorderview(batchs: routine.rawbatchs, fetcher: routine) {
                reorderedbatchs in

                routine.reorderbatchs(reorderedbatchs)
            }
        }
    }

}

extension Routine: Batchnumber2batchexercisedefsfetcher {
    func fetch(_ num: Int) -> [Batchexercisedef] {
        for batch in batchs {
            if batch.batch.num == num {
                return batch.batchexercisedefs.map({ $0.batchexercisedef })
            }
        }

        return []
    }
}

extension Routinebetabatchpanel {
    func copybatch() {
        routine.copybatch(batch)
    }

    func deletebatch() {
        routine.deletebatch(batch)
    }
}
