//
//  SwitchType.swift
//  OnlySwitch
//
//  Created by Jacklandrin on 2021/12/1.
//

import AppKit

struct SwitchBarInfo {
    let title:String
    let onImage:NSImage
    let offImage:NSImage
    var controlType:ControlType = .Switch
}

enum SwitchType:UInt64, CaseIterable {
    case hiddeDesktop = 1
  
    
    func barInfo() -> SwitchBarInfo {
        switch self {
        case .hiddeDesktop:
            return SwitchBarInfo(title:"Hide Desktop",
                                 onImage:NSImage(named: "desktopcomputer")!,
                                 offImage:NSImage(named: "desktop_with_icon")!)
        }
    }
    
    func getNewSwitchInstance() -> SwitchProvider {
        switch self {
        case .hiddeDesktop:
            return HiddenDesktopSwitch()
        }
    }
}

let switchTypeCount = SwitchType.allCases.count

enum ControlType{
    case Switch
    case Button
}



class HiddenDesktopSwitch:SwitchProvider {
    var type: SwitchType = .hiddeDesktop
    var switchBarVM: SwitchBarVM = SwitchBarVM(switchType: .hiddeDesktop)
    
    func currentStatus() -> Bool {
        return true
    }
    
    func currentInfo() -> String {
        return ""
    }
    
    func operationSwitch(isOn: Bool) async -> Bool {
        if isOn {
            return true
        } else {
            return false
        }
    }
    
    func isVisable() -> Bool {
        return true
    }
    
    
}
