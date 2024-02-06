//
//  AchievementsModel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/28.
//

import Foundation

class Exerciseresultmodel: ObservableObject {
    let exercise: ExerciseDef

    var lastAnalysisedList: [Analysisedexercise]
    var yearmonthandanalysisedlistsList: [(YearAndMonth, [Analysisedexercise])]
    var yearmonthdayAndanalysisedlistsList: [(YearAndMonth, [(Int, [Analysisedexercise])])]

    /*
     * processed values [results for display]
     * yearmonth, day, span
     */
    var yearmonthdayandspans: [(YearAndMonth, [(Int, Int)])]

    var last: Analysisedexercise?
    var capacitymax: Double
    var capacityvalues: [Histogramvalue]

    var onermmax: Double
    var onermvalues: [Histogramvalue]

    var maxweightmax: Double
    var maxweightvalues: [Histogramvalue]

    var ashistogramlistsList: [Histogramvaluelist] {
        return [
            Histogramvaluelist(description: "1rm", footer: "KG", valuelist: onermvalues, emptyspacing: 30),
            Histogramvaluelist(description: "maxweight", footer: "KG", valuelist: maxweightvalues, emptyspacing: 40),
            Histogramvaluelist(description: "capacity", footer: "KG", valuelist: capacityvalues, emptyspacing: 18),
        ]
    }

    init(_ exercise: ExerciseDef) {
        self.exercise = exercise

        lastAnalysisedList = []
        yearmonthandanalysisedlistsList = []
        yearmonthdayAndanalysisedlistsList = []

        last = nil

        yearmonthdayandspans = []

        capacitymax = 0.0
        capacityvalues = []

        onermmax = 0.0
        onermvalues = []

        maxweightmax = 0.0
        maxweightvalues = []

        fetch1()
        generatemax2()
        groupingintodateandvaluelist3()

        generategraphvalus4()
        reverseandcaculatepercent5()
    }

    func fetch1() {
        let end = Date()
        let start = Calendar.current.date(byAdding: .day, value: -60, to: end) ?? end
        let interval = DateInterval(start: start, end: end)

        let analysisedlist = AppDatabase.shared.queryanalysisedexercise(interval, exerciseid: exercise.id)
        if analysisedlist.isEmpty {
            return
        }
        lastAnalysisedList = analysisedlist
    }

    func generatemax2() {
        if lastAnalysisedList.isEmpty {
            return
        }

        lastAnalysisedList.forEach { eachanalysised in
            let _c: Double = eachanalysised.capacity
            if _c > capacitymax {
                capacitymax = _c
            }

            let _onerm: Double = eachanalysised.onerm
            if _onerm > onermmax {
                onermmax = _onerm
            }

            let _max: Double = eachanalysised.maxweight
            if _max > maxweightmax {
                maxweightmax = _max
            }
        }
    }

    func groupingintodateandvaluelist3() {
        if lastAnalysisedList.isEmpty {
            return
        }

        let _tmp = Dictionary(grouping: lastAnalysisedList,
                              by: { $0.createtime.yearAndMonth })
        let _tmp2 = _tmp.map { yearandmonth, valueList in
            (yearandmonth, valueList)
        }
        let _tmp3 = _tmp2.sorted { l, r in
            l.0.year < r.0.year || (l.0.year == r.0.year && l.0.month < r.0.month)
        }

        yearmonthandanalysisedlistsList = _tmp3

        for yearmonthandanalysisedlist in yearmonthandanalysisedlistsList {
            let yearmonth = yearmonthandanalysisedlist.0
            let analysisedlist = yearmonthandanalysisedlist.1

            let _dtmp = Dictionary(grouping: analysisedlist) {
                $0.createtime.day
            }
            let _dtmp2 = _dtmp.map { day, valueList in
                (day, valueList)
            }
            let dayandanalysisedlist = _dtmp2.sorted { l, r in
                l.0 < r.0
            }

            yearmonthdayAndanalysisedlistsList.append((yearmonth, dayandanalysisedlist))
        }
    }

    func generategraphvalus4() {
        if yearmonthandanalysisedlistsList.isEmpty {
            return
        }

        var idx = lastAnalysisedList.count - 1

        for each: (YearAndMonth, [(Int, [Analysisedexercise])]) in yearmonthdayAndanalysisedlistsList {
            let yearmonth = each.0
            let dayandanalysisedlist = each.1

            var dayandspanlist: [(Int, Int)] = []

            for _each in dayandanalysisedlist {
                let day: Int = _each.0
                let analysisedlist: [Analysisedexercise] = _each.1

                if analysisedlist.isEmpty {
                    continue
                }
                // 1、spans
                dayandspanlist.append((day, analysisedlist.count))

                // 2、values
                for each in analysisedlist {
                    let _r = findcapacitydeltaanddirectionandpercent(each)
                    capacityvalues.append(
                        Histogramvalue(id: idx,
                                       x: "",
                                       y: _r.0,
                                       ydelta: _r.1,
                                       deltadirection: _r.2,
                                       ypercent: _r.3,
                                       foreignid: each.batchid
                        )
                    )

                    let _r1 = findonermdeltaanddirectionandpercent(each)
                    onermvalues.append(
                        Histogramvalue(id: idx,
                                       x: "",
                                       y: _r1.0,
                                       ydelta: _r1.1,
                                       deltadirection: _r1.2,
                                       ypercent: _r1.3,
                                       foreignid: each.batchid
                        )
                    )

                    let _r2 = findmaxweightdeltaanddirectionandpercent(each)
                    maxweightvalues.append(
                        Histogramvalue(id: idx,
                                       x: "",
                                       y: _r2.0,
                                       ydelta: _r2.1,
                                       deltadirection: _r2.2,
                                       ypercent: _r2.3,
                                       foreignid: each.batchid
                        )
                    )

                    // end
                    last = each
                    idx -= 1
                }
            }

            yearmonthdayandspans.append((yearmonth, dayandspanlist))
        }
    }

    /*
     * capacity, delta, direction
     */
    private func findcapacitydeltaanddirectionandpercent(_ each: Analysisedexercise) -> (Double, Double, Deltadirection, Double) {
        var _d: Double = 0.0

        var _deltadirection: Deltadirection = .equal
        if let _l = last {
            let delta = each.capacity - _l.capacity
            _deltadirection = delta > 0 ? .positive : (delta < 0 ? .negative : .equal)
            _d = abs(delta)
        }

        let _p = abs(each.capacity / capacitymax)

        return (
            each.capacity,
            _d,
            _deltadirection,
            _p
        )
    }

    /*
     * onerm, delta, direction
     */
    private func findonermdeltaanddirectionandpercent(_ each: Analysisedexercise) -> (Double, Double, Deltadirection, Double) {
        var _d: Double = 0.0

        var _deltadirection: Deltadirection = .equal
        if let _l = last {
            let delta = each.onerm - _l.onerm
            _deltadirection = delta > 0 ? .positive : (delta < 0 ? .negative : .equal)
            _d = abs(delta)
        }

        let _p = abs(each.onerm / onermmax)

        return (
            each.onerm,
            _d,
            _deltadirection,
            _p
        )
    }

    /*
     * maxweight, delta, direction
     */
    private func findmaxweightdeltaanddirectionandpercent(_ each: Analysisedexercise) -> (Double, Double, Deltadirection, Double) {
        var _d: Double = 0.0

        var _deltadirection: Deltadirection = .equal
        if let _l = last {
            let delta = each.maxweight - _l.maxweight
            _deltadirection = delta > 0 ? .positive : (delta < 0 ? .negative : .equal)
            _d = abs(delta)
        }

        let _p = abs(each.maxweight / maxweightmax)

        return (
            each.maxweight,
            _d,
            _deltadirection,
            _p
        )
    }

    func reverseandcaculatepercent5() {
        yearmonthdayandspans = reverseYearmonthdayandspans(yearmonthdayandspans)
        capacityvalues = capacityvalues.reversed()
        onermvalues = onermvalues.reversed()
        maxweightvalues = maxweightvalues.reversed()
    }

    private func reverseYearmonthdayandspans(_ yearmonthdayandspans: [(YearAndMonth, [(Int, Int)])]) -> [(YearAndMonth, [(Int, Int)])] {
        var newyearmonthdayandspans: [(YearAndMonth, [(Int, Int)])] = []

        if yearmonthdayandspans.isEmpty {
            return newyearmonthdayandspans
        }

        for each in yearmonthdayandspans {
            let yearmonth = each.0
            let dayandspans = each.1

            newyearmonthdayandspans.insert((yearmonth, dayandspans.reversed()), at: 0)
        }

        return newyearmonthdayandspans
    }
}
