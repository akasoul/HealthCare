//
//  SwiftUIView.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 06.06.2021.
//

import SwiftUI

struct SwiftUIView: View {
    let colors=Colors()
    var body: some View {
        ChartEcg(data:[],marks:[],titleColor: self.colors.navViewItemTitleColor.color,marksColor:self.colors.detViewChartEcgMarksColor,lineColor: self.colors.detViewChartEcgLineColor,axisColor:self.colors.detViewChartAxisColor,backgroundColor: Color(red: 1, green: 1, blue: 1).opacity(0.3),miniature: true)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
