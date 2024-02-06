//
//  AnalysisedmuscleExercises.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/1/28.
//

import SwiftUI

struct AnalysisedmuscleExercises_Previews: PreviewProvider {
    static var previews: some View {
        let mockExercises = mockanalysisedexercise()
        let mock = mockAnalysisedmuscle()
        AnalysisedmuscleExercises(mock[0])
    }
}

struct AnalysisedmuscleExercisesList: View {
    var description: String
    var exerciselist: [Analysisedexercise]

    var body: some View {
        VStack {
            ExerciseTitleLabel(description: description)

            if exerciselist.isEmpty {
                Text("空").frame(height: 130)
                    .foregroundColor(Color(.systemGray4))
                    .font(.system(size: 21))
            } else {
                ForEach(exerciselist, id: \.id) {
                    exercise in

                    analysisedexerciseLabel(analysised: exercise)
                }
            }
        }
    }
}

struct AnalysisedmuscleExercises: View {
    let muscleAnalysised: Analysisedmuscle
    let model: AnalysisedmuscleExerciseModel

    init(_ muscleAnalysised: Analysisedmuscle) {
        self.muscleAnalysised = muscleAnalysised
        model = AnalysisedmuscleExerciseModel(muscleAnalysised)
    }

    var body: some View {
        ScrollView( showsIndicators: false) {
            
            VStack {
                primary

                secondary
            }
        }
    }

    var primary: some View {
        AnalysisedmuscleExercisesList(
            description: "核心动作",
            exerciselist: model.primaryanalysisedlist)
    }

    var secondary: some View {
        AnalysisedmuscleExercisesList(
            description: "复合动作",
            exerciselist: model.secondaryanalysisedlist)
    }
}

struct ExerciseTitleLabel: View {
    var description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(description)
                .font(.system(size: 19))
                .padding(.horizontal)

            LocalDivider(color: .secondary.opacity(0.3), width: 1)
        }
        .foregroundColor(Color(.systemGray))
        .padding(.top, 10)
        .frame(height: MIN_UP_TAB_HEIGHT - 5)
    }
}

struct AnalysisedIndicator: View {
    var img: Image
    var imgWidth: CGFloat = 30
    var imgHeight: CGFloat = 30
    var description: String
    var value: Double
    var valueisDigital = true
    var footer: String?

    var body: some View {
        VStack(spacing: 0) {
            img
                .renderingMode(.template)
                .resizable()
                .frame(width: imgWidth, height: imgHeight)
                .foregroundColor(.white)
                .font(.system(size: 14))
                .frame(width: 45, height: 45)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("Foreground"))
                )
                .padding(5)

            Text(String(format: valueisDigital ? "%.1f" : "%.0f",
                        value))
                .foregroundColor(.primary)
                .font(.system(size: 16).bold())
                .padding(.vertical, 3)

            Text(description)
                .foregroundColor(Color(.systemGray2))
                .font(.system(size: 13).bold())
                .padding(2)
        }
    }
}
