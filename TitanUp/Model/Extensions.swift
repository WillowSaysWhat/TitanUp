//
//  Extensions.swift
//  TitanUp
//
//  Created by Huw Williams on 19/11/2024.
//

import SwiftUI

extension Encodable {
    func asDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else {
            return [:];
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String:Any]
            return json ?? [:];
        }catch {
            return [:];
        }
    }
}
