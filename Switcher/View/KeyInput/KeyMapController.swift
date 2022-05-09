//
//  KeyMapController.swift
//  Switcher
//
//  Created by 김수환 on 2022/05/09.
//

import Foundation
import ArrayFlags

func SetKeyMapValue(){
    if (UserDefaults.standard.value(forKey:"EventDict")) != nil{
        ObservedObjects.EventDict = (try? JSONDecoder().decode([String:EventStruct].self, from: (UserDefaults.standard.value(forKey:"EventDict")) as! Data))!
    }
}

func PressedKeyEventStringMaker(keycode:UInt16, Flag:UInt) -> String{
    return String(keycode) + "|" + String(Flag)
}




func GetFlags(Val:UInt) -> String{
    let ArrayedFlag = GetArrayFlags(Val: Val).sorted()
    var FlagString:String = "["
    ArrayedFlag.forEach {
        if $0 < 20486016 && FlagMaps[UInt($0)] != nil {
            FlagMaps[UInt($0)]![0] == FlagMaps[UInt($0)]![1] ? (FlagString += FlagMaps[UInt($0)]![1] + ",") : (FlagString += FlagMaps[UInt($0)]![1] + FlagMaps[UInt($0)]![0] + ",")
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
    return UInt16(1000 + val) //mouse button num이 기존 키 패드의 num과 겹치지 않도록 큰 값으로 지정함
}
