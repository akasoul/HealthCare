//
//  ContentView.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 22.04.2021.
//

import SwiftUI



struct TabSelectionView: View {
    let colors: Colors
    @State var selection=0
    let backgroundColor = UIColor(red: 1, green: 1, blue: 1,alpha: 0.3)
    let borderColor = Color(red: 1, green: 1, blue: 1).opacity(0.5)
    
    init(colors: Colors) {
        self.colors = colors
        UITabBar.appearance().backgroundColor = self.backgroundColor
        UITabBar.appearance().backgroundImage = UIImage()
        //UITabBar.appearance().unselectedItemTintColor = UIColor.gray
        }
    var body: some View {
        GeometryReader{ g in
            TabView{
                MainView(colors:self.colors)
                    .tabItem({
                        Image(systemName: "heart.circle")
                })
                RecordsNavigationView(colors: self.colors)
                    .tabItem({
                    Image(systemName: "list.bullet")
                })
            }
            .background(BackgroundView())
            .accentColor(self.colors.tintColor.color)
        }
    }
}

