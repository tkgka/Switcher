//
//  Wrapper.swift
//  Switcher
//
//  Created by 김수환 on 2023/07/29.
//

import Foundation
import Cocoa

class Wrapper {
    
    var state: State?
    class State {
        init(mouseDownEvent: CGEvent) {
            self.mouseDownEvent = mouseDownEvent
        }
        var mouseDownEvent: CGEvent
        var task: DispatchWorkItem!
        var isRight = false
        var mouseMoves: [CGPoint] = []
    }
}
