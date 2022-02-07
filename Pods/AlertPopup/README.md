# AlertPopup

[![CI Status](https://img.shields.io/travis/tkgka/AlertPopup.svg?style=flat)](https://travis-ci.org/tkgka/AlertPopup)
[![Version](https://img.shields.io/cocoapods/v/AlertPopup.svg?style=flat)](https://cocoapods.org/pods/AlertPopup)
[![License](https://img.shields.io/cocoapods/l/AlertPopup.svg?style=flat)](https://cocoapods.org/pods/AlertPopup)
[![Platform](https://img.shields.io/cocoapods/p/AlertPopup.svg?style=flat)](https://cocoapods.org/pods/AlertPopup)

## Example
![](https://user-images.githubusercontent.com/52348220/152328111-1ba28b48-da7e-49e2-acb8-a2263d0cd638.gif)
![](https://user-images.githubusercontent.com/52348220/152328139-8ff9082f-1535-416d-a34c-09ca4107f5d7.gif)



To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Installation

AlertPopup is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AlertPopup'
```

## Usage
First, add `import AlertPopup` on every `swift` file you would like to use `AlertPopup`.

Then, use "ShowSystemAlert" function to Popup system alert

  - ShowSystemAlert returns NSWindow to remove Alert before Timer elapse

**Parameters:**

- `ImageName`: String value for image inside Alert
- `AlertText`: String value for text inside Alert
- `Timer`: Double value that determines when the notification disappears 


```swift
import Cocoa
import SwiftUI
import AlertPopup
var AlertWindow:NSWindow?
...

  if AlertWindow != nil{ closeWindow(window: AlertWindow!) } // remove Alert before Timer elapse
  
  AlertWindow = ShowSystemAlert(ImageName: "exclamationmark.circle", AlertText: "Test", Timer: 1.5) // show Alert

```



## Author

tkgka, ksh17171@gmail.com

## License

AlertPopup is available under the MIT license. See the LICENSE file for more info.
