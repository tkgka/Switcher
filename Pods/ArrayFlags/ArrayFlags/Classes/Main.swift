//
//  Main.swift
//  ArrayFlags
//
//  Created by 김수환 on 2022/03/18.
//

import Foundation



public class ArrayFlag{
    public init() {}
    var FlagList:[String:UInt] = ["􁂎":0, "􀆍":0, "􀆕":0, "􀆔":0, "􀆝":0, "FN":0, "Arrow":0]
    public func ArrayedFlagNum(Val:UInt){
        if FlagMaps[Val] != nil {
            FlagList[FlagMaps[Val]!] != nil ? (FlagList[FlagMaps[Val]!]! = Val) : nil
        }
        else if Val > 20972032 {
            return
        }
        else if Val > 10486016 {
            FlagList["Arrow"] = 10486016
            return ArrayedFlagNum(Val: Val - 10486016 + 256)
        }
        else if Val > 8388864 {
            FlagList["FN"] = 8388864
            return ArrayedFlagNum(Val: Val - 8388864 + 256)
        }
        else if Val > 1048840 && Val < 8388864 {
            FlagList["􀆔"]! = 1048840
            return ArrayedFlagNum(Val: Val - 1048840 + 256)
        }
        else if Val > 524576 && Val < 1048840 {
            FlagList["􀆕"]! = 524576
            return ArrayedFlagNum(Val: Val - 524576 + 256)
        }
        else if Val > 262401 && Val < 524640 {
            FlagList["􀆍"]! += 262401
            return ArrayedFlagNum(Val: Val - 262401 + 256)
        }
        else if Val > 131330 && Val < 270592 {
            FlagList["􀆝"]! = 131330
            return ArrayedFlagNum(Val: Val - 131330 + 256)
        }
        else if Val > 65792 {
            FlagList["􁂎"] = 65792
            return ArrayedFlagNum(Val: Val - 65792 + 256)
        }
        else {
            if Val > 0 {
            FlagLoc(Val: Val-256)
            }
        }
    }
    
    func FlagLoc(Val:UInt){
        if Val >= 8191 {
            FlagList["􀆍"]! += 8191
            FlagLoc(Val: Val-8191)
        }else if Val >= 32 {
            FlagList["􀆕"]! += 32
            FlagLoc(Val: Val-32)
        }else if Val >= 8{
            FlagList["􀆔"]! += 8
            FlagLoc(Val: Val-8)
        }else if Val >= 2{
            FlagList["􀆝"]! += 2
            FlagLoc(Val: Val-2)
        }else if Val == 1{
            FlagList["􀆍"]! += 1
        }
}
}

public func GetDictFlags(Val:UInt) -> [String:UInt]{
    let ArrayFlags = ArrayFlag()
    ArrayFlags.ArrayedFlagNum(Val: Val)
    return ArrayFlags.FlagList
}



public func GetArrayFlags(Val:UInt) -> [UInt]{
    var ReturnVal:[UInt] = []
    let FlagList = GetDictFlags(Val: Val)
    ReturnVal = Array(FlagList.values)
    ReturnVal.removeAll(where: {$0 == 0})
    return ReturnVal
}

public func GetDictFlagsString(Val:UInt) -> [String:String]{
    var ReturnArray:[String:String] = [:]
    let ReturnVal = GetArrayFlags(Val: Val)
    for i in ReturnVal{
        (FlagValMaps[i] != nil && FlagMaps[i] != nil) ? (ReturnArray[FlagMaps[i]!] = FlagValMaps[i]!) : (ReturnArray["?"] = "?")
    }
    return ReturnArray
    
}
