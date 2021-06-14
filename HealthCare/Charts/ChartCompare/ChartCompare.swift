//
//  ChartCompare.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 07.06.2021.
//

import SwiftUI


struct ChartCompare: View {
    
    @ObservedObject var model = ChartCompareModel()
    @State var delta: chartOffset = chartOffset(dy: 0, dx: 0)
    var dates: [Date]?
    var values: [Double]?
    var backgroundColor: Color = Color(red: 1, green: 1, blue: 1).opacity(0.2)
    let cornerRadius: CGFloat = 20
    var offset: CGFloat=20
    let miniature: Bool
    @State var detailViesIsPresented: Bool = false
    let textHelp=Localization.getString("IDS_CHART_COMPARE_HELP")
    @State var showHelp:Bool=false
    @State var clrLeft=Color.clear
    @State var clrRight=Color.clear
    @State var selectedRecord: Storage.Record?
    init(dates:[Date]? = nil,values:[Double]?=nil,miniature: Bool=false){
        self.dates=dates
        self.values=values
        self.miniature=miniature
        
        if(self.miniature){
            self.offset=0
        }
        
        if(self.dates != nil && values != nil){
            // self.model.setup(dates: self.dates!, values: self.values!)
        }
    }
    
    func setTitle(_ title: String){
        self.model.title=title
    }
    
    
    func setData(data: [[String]]){
        //        self.model.values=data
        //self.model.setup(dates: dates, values: values)
        self.model.setData(values: data)
    }
    
    func setColors(titleColor: Color,textColor: Color,backgroundColor: Color = UIColor(red: 1, green: 1, blue: 1,alpha: 0.3).color){
        self.model.titleColor=titleColor
        self.model.textColor=textColor
        self.model.backgroundColor=backgroundColor
        //self.model.setColors(axisColor: axisColor,gridColor: gridColor,colors: colors)
    }
    
    func setDetailViewColors(_ colors: Colors){
        self.model.setColors(colors)
    }
    
    func help(){
        self.showHelp = self.showHelp == true ? false : true
    }
    
    var body: some View{
        GeometryReader{ g in
            Group{
                ChartBase(text: self.model.title,textColor: self.model.titleColor,showHelpButton: true,showHelpButtonColor: self.model.textColor,showHelpButtonAction: self.help, backgroundColor:self.model.backgroundColor)
                
                if(!self.showHelp){
                    Group{
                        Color.clear.contentShape(Rectangle())
                        VStack{
                            ForEach(self.model.descriptions, id:\.self){ i in
                                Text(i)
                                    .font(.system(size: 12))
                                    .frame(width:self.model.descriptionWidth-10,height: self.model.stringHeight,alignment:.trailing)
                            }
                        }
                    }
                    .foregroundColor(self.model.textColor)
                    .frame(width:self.model.descriptionWidth, height: g.size.height-3*self.offset,alignment:.trailing)
                    .offset(x: self.offset, y: 2*self.offset)
                    
                    
                    Group{
                        Color.clear.contentShape(Rectangle()).frame(width:CGFloat(self.model.values.count)*self.model.recordWidth)
                        HStack(spacing:0){
                            ForEach(self.model.values,id:\.self){ i in
                                //                            NavigationLink(destination: Rectangle()){
                                VStack{
                                    Text(i[0])
                                        .font(.system(size: 12))
                                        //                                    .fontWeight(.bold)
                                        .frame(height: self.model.stringHeight)
                                    Text(i[1])
                                        .font(.system(size: 12))
                                        //                                    .fontWeight(.bold)
                                        .frame(height: self.model.stringHeight)
                                    Text(i[2])
                                        .font(.system(size: 12))
                                        //                                    .fontWeight(.bold)
                                        .frame(height: self.model.stringHeight)
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: self.cornerRadius)
                                        .foregroundColor(
                                            i == self.model.valLeft ? self.clrLeft : i == self.model.valRight ? self.clrRight : Color.clear
                                        )
                                        .frame(width:self.model.recordWidth-10,alignment:.center)
                                    
                                )
                                .foregroundColor(self.model.textColor)
                                .frame(width:self.model.recordWidth)
                                .onLongPressGesture(perform: {
                                    guard let record=self.model.findRecordByDate(i[0])
                                    else{ return }
                                    self.model.selectedRecord=record
                                    self.detailViesIsPresented=true
                                })
                                //                        }
                            }
                            
                        }
                    }
                    .frame(width: 2*self.model.recordWidth, height: g.size.height-3*self.offset,alignment:.leading)
                    .offset(x: self.delta.dx, y: self.delta.dy)
                    .clipped()
                    .offset(x: self.offset+self.model.descriptionWidth, y: 2*self.offset)
                    .gesture(
                        DragGesture()
                            .onChanged({ (value) in
                                let scrollDirection:CGFloat = -1.0
                                let offsetX = self.delta.x + scrollDirection * (value.startLocation.x-value.location.x)
                                
                                let width:CGFloat = (CGFloat(self.model.values.count-1)-0.5)*self.model.recordWidth
                                
                                if(-offsetX < width && -offsetX > 0){
                                    self.delta.dx =  offsetX// < 0 ? -1.0 : 1.0
                                }
                            })
                            .onEnded({ value in
                                let pos = Int((self.delta.dx-0.5*self.model.recordWidth)/(self.model.recordWidth))
                                print(-pos)
                                withAnimation(.linear(duration:1)){
                                    self.delta.dx = CGFloat(pos)*self.model.recordWidth
                                }
                                self.model.setPosition(-pos)
                                withAnimation(.linear(duration:1)){
                                    self.clrLeft=self.model.clrLeft
                                    self.clrRight=self.model.clrRight
                                }
                                self.delta.x=self.delta.dx
                                self.delta.y=self.delta.dy
                            })
                    )
                    .onAppear(perform:{
                        self.model.setSize(width: g.size.width-2*self.offset,height:g.size.height-3*self.offset)
                        self.model.setDescriptions(descriptions: [
                            Localization.getString("IDS_CHART_COMPARE_DATE"),
                            Localization.getString("IDS_CHART_COMPARE_HEARTRATE"),
                            Localization.getString("IDS_CHART_COMPARE_HRVINDEX")
                        ])
                        withAnimation(.linear(duration:1)){
                            self.clrLeft=self.model.clrLeft
                            self.clrRight=self.model.clrRight
                        }
                    })
                    .onReceive(self.model.$values, perform: {i in
                        if(i.count>0){
                            //self.model.setPosition(0)
                            withAnimation(.linear(duration:1)){
                                self.clrLeft=self.model.clrLeft
                                self.clrRight=self.model.clrRight
                            }
                        }
                    })
                }
                else{
                    Text(self.textHelp)
                        .font(.system(size: 12))
                        .frame(width:g.size.width-2.5*self.offset,alignment: .leading)
                        .offset(x:self.offset,y:2*self.offset)
                        .foregroundColor(self.model.textColor)
                    
                }
                
            }
            .popover(isPresented: self.$detailViesIsPresented, content: {
                if(self.model.selectedRecord != nil && self.model.colors != nil){
                    DetailView(record: self.model.selectedRecord!,colors: self.model.colors!,useSpacer: true)
                }
            })
        }
        
        
    }
    
    
    
    
    
    
}
