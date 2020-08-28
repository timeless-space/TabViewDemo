//
//  TabBarEnviroment.swift
//  Timeless-iOS
//
//  Created by Lucas Wilkinson on 7/24/20.
//  Copyright © 2020 Timeless. All rights reserved.
//

import Foundation
import SwiftUI


class TabBarEnvironment: ObservableObject {
    @Published private(set) var visible: Bool = true

    func hideTabBar() {
        if visible == true {
            visible = false
        }
    }

    func showTabBar() {
        if visible == false {
            visible = true
        }
    }
}
