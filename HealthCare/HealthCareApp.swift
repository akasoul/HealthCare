//
//  HealthCareApp.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 22.04.2021.
//

import SwiftUI
import Combine
import StoreKit
@main
struct HealthCareApp: App {
    init() {
        if let windowScene = UIApplication.shared.windows.first?.windowScene {
            SKStoreReviewController.requestReview(in: windowScene)
            
        }
    }
    let colors = Colors()
    var body: some Scene {
        WindowGroup {
            TabSelectionView(colors: self.colors)
                .onAppear(perform: {
                    if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String{

                    if var counter = UserDefaults.standard.value(forKey: "EcgAnalyzerCounter"+appVersion) as? Int{
                        print(counter)
                        if(counter == 10){
                            if let windowScene = UIApplication.shared.windows.first?.windowScene { SKStoreReviewController.requestReview(in: windowScene)
                            }
                        }
                        counter += 1
                        UserDefaults.standard.setValue(counter, forKey: "EcgAnalyzerCounter"+appVersion)
                    }
                    else{
                        UserDefaults.standard.setValue(0, forKey: "EcgAnalyzerCounter"+appVersion)
                    }
                    }
                })
        }
    }
}



