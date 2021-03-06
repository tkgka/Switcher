//
//  KeyMapController.swift
//  Switcher
//
//  Created by κΉμν on 2022/05/09.
//

import Foundation
import ArrayFlags

func SetKeyDefaultValue(){
    if (UserDefaults.standard.value(forKey:"EventDict")) != nil{
        ObservedKeyVals.EventDict = (try? JSONDecoder().decode([String:EventStruct].self, from: (UserDefaults.standard.value(forKey:"EventDict")) as! Data))!
    }
    if (UserDefaults.standard.value(forKey:"AlertValEvent")) != nil{
        ObservedAlertVals.PressedKeyEvent = UserDefaults.standard.value(forKey: "AlertValEvent") as! [String]
        if (ObservedAlertVals.PressedKeyEvent.count == 0){
            ObservedAlertVals.PressedKeyEvent = ["[τ]q"]
        }
    }
    if UserDefaults.standard.value(forKey:"AlertList") != nil{
        let listedIcons:[String:Data] = (try? JSONDecoder().decode([String:Data].self, from: (UserDefaults.standard.value(forKey:"AlertList")) as! Data))!
        for item in listedIcons.keys {
            ObservedAlertVals.AlertList[item] = NSImage(data: listedIcons[item]!)
        }
    }
    
}


func checkApplicationIsActive(Applications:[String]) -> Bool {
    let app = NSWorkspace.shared.frontmostApplication; // get Currently Focused Application
    //            print(app.localizedName!)
    if Applications.contains(app!.localizedName ?? ""){
        return true
    }
    return false
}


func ApplicationIcons() -> [String:NSImage] {
    
    let apps = NSWorkspace.shared.runningApplications
    
    var ReturnVal:[String:NSImage] = [:]
    for app in apps {
        ReturnVal[app.localizedName!] = app.icon
    }
    
    return ReturnVal
}


func PressedKeyEventStringMaker(keycode:UInt16, Flag:UInt) -> String{
    return String(keycode) + "|" + String(Flag)
}




func GetFlags(Val:UInt, GetDirection:Bool = true) -> String{
    let ArrayedFlag = GetArrayFlags(Val: Val).sorted()
    var FlagString:String = "["
    ArrayedFlag.forEach {
        if $0 < 20486016 && FlagMaps[UInt($0)] != nil {
            if GetDirection == true{
                FlagMaps[UInt($0)]![0] == FlagMaps[UInt($0)]![1] ? (FlagString += FlagMaps[UInt($0)]![1] + ",") : (FlagString += FlagMaps[UInt($0)]![1] + FlagMaps[UInt($0)]![0] + ",")
            }else {
                (FlagMaps[UInt($0)]![0] == FlagMaps[65792]![0] || FlagMaps[UInt($0)]![0] == FlagMaps[10486016]![0]) ? (nil) : (FlagString += FlagMaps[UInt($0)]![0])
            }
        }
    }
    FlagString == "[" ? (FlagString = "") : (FlagString = FlagString.trimmingCharacters(in: [","]) + "]")
    return FlagString
}


func ArrayToFlagVal(val:[UInt]) -> UInt{
    var returnVal:UInt = 0
    val.forEach{
        returnVal += $0 - 256
    }
    returnVal < 0 ? (returnVal = 0) : nil
    return returnVal + 256
}

func MouseBtnNum(val:Int) -> UInt16 {
    return UInt16(1000 + val) //mouse button numμ΄ κΈ°μ‘΄ ν€ ν¨λμ numκ³Ό κ²ΉμΉμ§ μλλ‘ ν° κ°μΌλ‘ μ§μ ν¨
}
