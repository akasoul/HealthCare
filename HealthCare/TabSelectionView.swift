//
//  ContentView.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 22.04.2021.
//

import SwiftUI



struct TabSelectionView: View {
    @State var selection=0
    let backgroundColor = UIColor(red: 1, green: 1, blue: 1,alpha: 0.1)
    let borderColor = Color(red: 1, green: 1, blue: 1).opacity(0.5)
    init() {
        UITabBar.appearance().backgroundColor = self.backgroundColor
        UITabBar.appearance().tintColor = .red
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
        }
    var body: some View {
        GeometryReader{ g in
            TabView{
                MainView().tabItem({
                    Image(systemName: "heart.circle")
                })
                RecordsNavigationView().tabItem({
                    Image(systemName: "list.bullet")
                })
            }//.background(BackgroundView())
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TabSelectionView()
    }
}
