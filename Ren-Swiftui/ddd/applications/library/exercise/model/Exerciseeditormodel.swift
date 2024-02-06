//
//  Exercisevieweditormodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/6/3.
//

import Foundation
import SwiftUI

class Exercisevieweditormodel: ObservableObject {
    var exercisedef: Exercisedef?

    init(_ exercisedef: Exercisedef? = nil, primary: String? = nil) {
        self.exercisedef = exercisedef

        if let _primary = primary {
            self.primary = _primary
        }

        if let _imgname = exercisedef?.imgname {
            if let _uiimage = retrieveImage(forKey: _imgname, inStorageType: .fileSystem) {
                image = _uiimage
            }
        }

        if let _def = exercisedef {
            exercisename = PreferenceDefinition.shared.language(_def.realname)
            equipments = _def.equipment
            self.primary = _def._primarymuscleid
            secondarylist = _def._secondarymuscleids
            selectedcalculator = _def.ofcalculate.label
            selectedlogcontenttype = _def.logtype.rawValue
        } else {
            var _primary: String = primary ?? ""
            if _primary.isEmpty {
                _primary = "chest"
            }

            self.exercisedef = Exercisedef.ofempty(_primary)
        }
    }

    @Published var exercisename: String = ""
    @Published var equipments: [String] = []
    @Published var primary: String = ""
    @Published var secondarylist: [String] = []
    @Published var selectedcalculator: String = Caculateweight.single.label
    @Published var selectedlogcontenttype: String = Logtype.repsandweight.rawValue
    @Published var image: UIImage?

    func save() {
        if var _exercisedef = exercisedef {
            _exercisedef.username = exercisename
            _exercisedef.equipment = equipments
            _exercisedef.muscle?.primary = primary
            _exercisedef.muscle?.secondary = secondarylist
            _exercisedef.calc = Caculateweight.of(selectedcalculator)
            _exercisedef.type = Logtype(rawValue: selectedlogcontenttype) ?? .repsandweight

            if let _image: UIImage = image {
                let randomstr = UUID().uuidString
                store(image: _image, forKey: randomstr, withStorageType: .fileSystem)
                _exercisedef.imgname = randomstr
            }

            var _p = _exercisedef.toExercisePersistable

            try! AppDatabase.shared.saveexercisepersistable(&_p)
        }
    }
}

extension Exercisevieweditormodel {
    func displayequipments(preference: PreferenceDefinition) -> String {
        let ret =
            equipments
                .map({ preference.language($0) })
                .joined(separator: ", ")
        if ret.isEmpty {
            return preference.language("empty")
        }
        return ret
    }

    func addorremoveequipment(_ muscleid: String) {
        if let _idx = equipments.firstIndex(of: muscleid) {
            equipments.remove(at: _idx)
        } else {
            equipments.append(muscleid)
        }
    }

    func displayprimary(preference: PreferenceDefinition) -> String {
        let ret = preference.language(primary)
        if ret.isEmpty {
            return preference.language("empty")
        }
        return ret
    }

    func displaysecondarys(preference: PreferenceDefinition) -> String {
        let ret =
            secondarylist
                .map({ preference.language($0) })
                .joined(separator: ", ")
        if ret.isEmpty {
            return preference.language("empty")
        }
        return ret
    }

    var displayselectedcalculator: String {
        "x \(selectedcalculator)"
    }

    func displayrecordtype(preference: PreferenceDefinition) -> String {
        preference.language(selectedlogcontenttype)
    }
}
