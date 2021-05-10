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
    let backgroundColor = UIColor(red: 1, green: 1, blue: 1,alpha: 0.0)
    
    init() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = true
    }
    var body: some View {
        GeometryReader{ g in
            NavigationView{
                ScrollView{
                    VStack{
                        ForEach(self.model.list, id: \.self){ i in
                            NavigationLink(destination: DetailView(record: i)){
                                NavigationItemView(data: i).frame(width:g.size.width,height:200)
                            }//.frame(height:30)
                        }
                    }
                }.background(BackgroundView())
                .navigationBarTitleDisplayMode(.inline)
            }
            .navigationBarHidden(true)
            .statusBar(hidden: false)
        }
    }
}



struct DstView: View {
    init() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = true
    }
    
    var body: some View{
        GeometryReader{ g in
            Rectangle().fill(Color.blue).frame(width: g.size.width, height: g.size.height)
        }
        .background(BackgroundView())
    }
}

struct HiddenNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
    }
}

extension View {
    func hiddenNavigationBarStyle() -> some View {
        modifier( HiddenNavigationBar() )
    }
}


struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
