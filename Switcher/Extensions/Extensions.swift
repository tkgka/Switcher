//
//  Extensions.swift
//  Switcher
//
//  Created by 김수환 on 2022/03/09.
//

import SwiftUI
import Foundation

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

extension Dictionary where Value: Equatable {
    func findKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}






// NSImage -> pngData
//extension String{
//    func getArrayAfterRegex(regex: String) -> [String] {
//
//        do {
//            let regex = try NSRegularExpression(pattern: regex)
//            let results = regex.matches(in: self,
//                                        range: NSRange(self.startIndex..., in: self))
//            return results.map {
//                String(self[Range($0.range, in: self)!])
//            }
//        } catch let error {
//            print("invalid regex: \(error.localizedDescription)")
//            return []
//        }
//    }
//}


extension NSBitmapImageRep {
    var png: Data? { representation(using: .png, properties: [:]) }
}
extension Data {
    var bitmap: NSBitmapImageRep? { NSBitmapImageRep(data: self) }
}
extension NSImage {
    var png: Data? { tiffRepresentation?.bitmap?.png }
}



