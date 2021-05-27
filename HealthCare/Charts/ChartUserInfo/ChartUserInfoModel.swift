//
//  ChartInfoModel.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 22.05.2021.
//

import Foundation

class ChartUserInfoModel: ObservableObject{
    @Published var descriptions: [String] = [
        Localization.getString("IDS_CHART_USERINFO_DATEOFBIRTH"),
        Localization.getString("IDS_CHART_USERINFO_GENDER"),
        Localization.getString("IDS_CHART_USERINFO_HEIGHT"),
        Localization.getString("IDS_CHART_USERINFO_WEIGHT")
    ]

    @Published var values: [String]=[]
    
    func setup(){
        self.values=[]
        guard let userInfo = Storage.shared.getUserInfo()
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
