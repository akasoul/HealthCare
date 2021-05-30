//
//  HealthCareApp.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 22.04.2021.
//

import SwiftUI
import Combine

@main
struct HealthCareApp: App {
    let colors = Colors()
    var body: some Scene {
        WindowGroup {
            TabSelectionView(colors: self.colors)
        }
    }
}



