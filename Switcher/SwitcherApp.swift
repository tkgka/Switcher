//
//  Switcher
//
//  Created by 김수환 on 2022/01/08.
//

import SwiftUI

@main
struct SwitcherApp: App {
    
    // Linking a created AppDelegate
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        Settings {
            AlertView()
        }
    }
}

