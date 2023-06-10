//
//  KeyMapController.swift
//  Switcher
//
//  Created by 김수환 on 2022/05/09.
//

import Foundation
import ArrayFlags
import SwiftUI

func setKeyDefaultValue() {
    if (UserDefaults.standard.value(forKey:"EventDict")) != nil {
        observedKeyVal.EventDict = (
            try? JSONDecoder().decode(
                [String:EventStruct].self,
                from: (UserDefaults.standard.value(forKey:"EventDict")) as! Data
            )
        )!
    }
    if (UserDefaults.standard.value(forKey:"AlertValEvent")) != nil {
        observedAlertVal.pressedKeyEvent = UserDefaults.standard.value(forKey: "AlertValEvent") as! [String]
        if (observedAlertVal.pressedKeyEvent.count == 0){
            observedAlertVal.pressedKeyEvent = ["[􀆔]q"]
            UserDefaults.standard.set("[false]", forKey:"AlertKeyListIsChecked")
        }
    }
    if UserDefaults.standard.value(forKey:"AlertList") != nil {
        let listedIcons:[String:Data] = (
            try? JSONDecoder().decode(
                [String:Data].self,
                from: (UserDefaults.standard.value(forKey:"AlertList")) as! Data
            )
        )!
        for item in listedIcons.keys {
            observedAlertVal.alertList[item] = NSImage(data: listedIcons[item]!)
        }
    }
    
    
    let alertKeyListIsCheck = [Bool](rawValue: UserDefaults.standard.string(forKey: "AlertKeyListIsChecked")!) ?? []
    if observedAlertVal.pressedKeyEvent.count != alertKeyListIsCheck.count {
        UserDefaults.standard.set("[]", forKey:"AlertKeyListIsChecked")
        observedAlertVal.pressedKeyEvent.removeAll()
    }
    
    let isCheck = [Bool](rawValue: UserDefaults.standard.string(forKey: "IsChecked")!) ?? []
    if observedKeyVal.EventDict.count != isCheck.count {
        UserDefaults.standard.set("[]", forKey:"IsChecked")
        observedKeyVal.EventDict.removeAll()
    }
}


func checkApplicationIsActive(Applications:[String]) -> Bool {
    let app = NSWorkspace.shared.frontmostApplication; // get Currently Focused Application
    if Applications.contains(app!.localizedName ?? ""){
        return true
    }
    return false
}


func applicationIcons() -> [String:NSImage] {
    let apps = NSWorkspace.shared.runningApplications
    
    var returnVal:[String:NSImage] = [:]
    for app in apps {
        returnVal[app.localizedName!] = app.icon
    }
    
    return returnVal
}


func pressedKeyEventStringMaker(keycode:UInt16, flag:UInt) -> String {
    return String(keycode) + "|" + String(flag)
}




func getFlags(val:UInt, getDirection:Bool = true) -> String {
    let ArrayedFlag = GetArrayFlags(Val: val).sorted()
    var flagString:String = "["
    ArrayedFlag.forEach {
        if $0 < 20486016 && flagMaps[UInt($0)] != nil { //exception handling
            if getDirection == true {
                flagMaps[UInt($0)]![0] == flagMaps[UInt($0)]![1]
                ? (flagString += flagMaps[UInt($0)]![1] + ",")
                : (flagString += flagMaps[UInt($0)]![1] + flagMaps[UInt($0)]![0] + ",")
            } else {
                (flagMaps[UInt($0)]![0] == flagMaps[65792]![0] || flagMaps[UInt($0)]![0] == flagMaps[10486016]![0])
                ? (nil)
                : (flagString += flagMaps[UInt($0)]![0])
            }
        }
    }
    flagString == "[" ? (flagString = "") : (flagString = flagString.trimmingCharacters(in: [","]) + "]")
    return flagString
}


func ArrayToFlagVal(val:[UInt]) -> UInt {
    var returnVal: UInt = 0
    val.forEach {
        returnVal += $0 - 256
    }
    if returnVal <= 0 {
        returnVal = 0
    }
    return returnVal + 256
}

func MouseBtnNum(val:Int) -> UInt16 {
    return UInt16(1000 + val) //mouse button num이 기존 키 패드의 num과 겹치지 않도록 큰 값으로 지정함
}
