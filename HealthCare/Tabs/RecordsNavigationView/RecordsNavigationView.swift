//
//  NavigationView.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 24.04.2021.
//

import SwiftUI
import Combine








struct RecordsNavigationView: View {
    @ObservedObject var model = NavigationViewModel()
    let colors: Colors
    let navigationItems: [NavigationItemView]=[]
    init(colors: Colors) {
        self.colors=colors
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().backIndicatorImage=UIImage()
        UINavigationBar.appearance().tintColor = colors.tintColor

        UITableView.appearance().backgroundColor = .red
        UITableViewCell.appearance().backgroundColor = .red
        UITableView.appearance().tableFooterView = UIView()

    }

    var body: some View {
        GeometryReader{ g in
            if(self.model.records.count>0){
                NavigationView{
                    ScrollView{
                        VStack{
                            ForEach(self.model.records, id: \.self.date){ i in
                                NavigationLink(destination: DetailView(record: i,colors: self.colors)){
                                    NavigationItemView(data: i,colors: self.colors)
                                        .equatable()
                                        .frame(width:g.size.width,height:150)
                                }
                            }

                    }
                    }
                    //.frame(width: g.size.width,height: g.size.height)
                    .mask(Rectangle())
                    //.mask(Rectangle().fill(LinearGradient(gradient: Gradient(colors: [.clear,.black,.black,.clear]), startPoint: UnitPoint.top, endPoint: .bottom)).edgesIgnoringSafeArea(.all))
                    .background(BackgroundView())
                    .navigationBarTitleDisplayMode(.inline)
                }
                .navigationBarHidden(true)
                .statusBar(hidden: true)
            }
            else{
                BackgroundView()
            }
        }
    }
}



//
//struct RecordsNavigationView: View {
//    @ObservedObject var model = NavigationViewModel()
//    let colors: Colors
//    let navigationItems: [NavigationItemView]=[]
//    init(colors: Colors) {
//        self.colors=colors
//        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        UINavigationBar.appearance().shadowImage = UIImage()
//        UINavigationBar.appearance().isTranslucent = true
//        UINavigationBar.appearance().backIndicatorImage=UIImage()
//        UINavigationBar.appearance().tintColor = colors.tintColor
//
//        UITableView.appearance().backgroundColor = .clear
//        UITableViewCell.appearance().backgroundColor = .clear
//        UITableViewCell.appearance().selectionStyle = .none
//        UITableView.appearance().separatorInset = .zero
//        UITableView.appearance().separatorStyle = .none
//        UITableView.appearance().contentOffset = .zero
//        UITableViewCell.appearance().separatorInset = .zero
//
//    }
//
//    var body: some View {
//        GeometryReader{ g in
//            if(self.model.records.count>0){
//                NavigationView{
//                    BackgroundView().edgesIgnoringSafeArea(.all).overlay(
//
//                        List{
//                            ForEach(self.model.records,id:\.self.date){ i in
//                                NavigationLink(destination: DetailView(record: i,colors: self.colors)){
//                                    NavigationItemView(data: i,colors: self.colors)
//                                        .frame(width:g.size.width,height:150).background(Color.clear)
//                                }
////                                .background(Color.clear)
//                            }.listRowBackground(Color.clear)
//                        }
//                        .listStyle(SidebarListStyle())
//                        .background(Color.clear).frame(width:g.size.width,height:g.size.height)
//                    )
//                }
//                .navigationBarHidden(true)
//                .statusBar(hidden: true)
//            }
//            else{
//                BackgroundView()
//            }
//        }
//    }
//}
