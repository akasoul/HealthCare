//
//  ChartInfoModel.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 22.05.2021.
//

import Foundation
import SwiftUI
class ChartUserInfoModel: ObservableObject{
    @Published var descriptions: [String] = [
        Localization.getString("IDS_CHART_USERINFO_DATEOFBIRTH"),
        Localization.getString("IDS_CHART_USERINFO_GENDER"),
        Localization.getString("IDS_CHART_USERINFO_HEIGHT"),
        Localization.getString("IDS_CHART_USERINFO_WEIGHT")
    ]

    @Published var values: [String]=[]
    @Published var titleColor=Color.blue
    @Published var textColor = Color.blue
    @Published var title: String=""
    @Published var backgroundColor: Color = Color(red: 1, green: 1, blue: 1).opacity(0.2)

    
    func setup(){
        self.values=[]
        guard let userInfo = Storage.shared.userInfo
        else{ return }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        let str = formatter.string(from: userInfo.dateOfBirth)
        values.append(str)
        
        values.append(userInfo.gender)
        values.append(String(userInfo.height))
        values.append(String(userInfo.weight))
    }
}
