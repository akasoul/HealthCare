//
//  Colors.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 23.04.2021.
//

import Foundation
import SwiftUI
import UIKit

let tintColor=UIColor.blue

extension UIColor{
    public var color: Color{ get{
        guard let components = self.cgColor.components
        else{ return Color.clear }
        let clr=Color(red: Double(components[0]), green: Double(components[1]), blue: Double(components[2]), opacity: Double(components[3]))
        return clr
    }}
}

class Colors{
    let tintColor=UIColor(red: 0.19, green: 0.45, blue: 0.27, alpha: 1)
    
    let globalItemBackground = UIColor(red: 1, green: 1, blue: 1,alpha: 0.3)
    
    let mainViewChartTitleColor=UIColor(red: 0.19, green: 0.45, blue: 0.27, alpha: 1)
    let mainViewChartTextColor=UIColor(red: 0.35, green: 0.73, blue: 0.28, alpha: 1)
    let mainViewChartAxisColor=UIColor(red: 0.35, green: 0.73, blue: 0.28, alpha: 1)

    let navViewItemTitleColor=UIColor(red: 0.19, green: 0.45, blue: 0.27, alpha: 1)
    let navViewItemTextColor=UIColor(red: 0.35, green: 0.73, blue: 0.28, alpha: 1)
    let navViewEcgLineColor=UIColor(red: 0.35, green: 0.73, blue: 0.28, alpha: 1)
    
    let detViewChartTitleColor=UIColor(red: 0.19, green: 0.45, blue: 0.27, alpha: 1)
    let detViewChartTextColor=UIColor(red: 0.35, green: 0.73, blue: 0.28, alpha: 1)
    let detViewChartAxisColor=UIColor(red: 0.35, green: 0.73, blue: 0.28, alpha: 1)
    let detViewChartEcgLineColor=UIColor(red: 0.35, green: 0.73, blue: 0.28, alpha: 1)
    let detViewChartEcgMarksColor=UIColor.red
    let detViewChartScatFillColor=UIColor(red: 0.35, green: 0.73, blue: 0.28, alpha: 1)
    let detViewChartRhythmogramTopColor=UIColor(red: 0.35, green: 0.73, blue: 0.28, alpha: 1)
    let detViewChartRhythmogramBottomColor=UIColor(red: 0.35, green: 0.73, blue: 0.28, alpha: 0.3)
    let detViewChartHistogramTopColor=UIColor(red: 0.35, green: 0.73, blue: 0.28, alpha: 1)
    let detViewChartHistogramBottomColor=UIColor(red: 0.35, green: 0.73, blue: 0.28, alpha: 0.3)

}
