//
//  ChartCompare.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 07.06.2021.
//

import SwiftUI


struct ChartCompare: View {
    
    @ObservedObject var model = ChartCompareModel()
    @State var rotationAngle: Angle = .zero
    @State var delta: chartOffset = chartOffset(dy: 0, dx: 0)
    @State var detailViesIsPresented: Bool = false
    @State var showHelp:Bool=false
    @State var clrLeft=Color.clear
    @State var clrRight=Color.clear
    @State var selectedRecord: Storage.Record?
    
    var dates: [Date]?
    var values: [Double]?
    var backgroundColor: Color = Color(red: 1, green: 1, blue: 1).opacity(0.2)
    let cornerRadius: CGFloat = 20
    var offset: CGFloat=20
    let miniature: Bool
    let textHelp=Localization.getString("IDS_CHART_COMPARE_HELP")
    
    init(dates:[Date]? = nil,values:[Double]?=nil,miniature: Bool=false){
        self.dates=dates
        self.values=values
        self.miniature=miniature
        
        if(self.miniature){
            self.offset=0
        }
        
    }
    
    func setTitle(_ title: String){
        self.model.title=title
    }
    
    
    func setData(data: [[String]]){
        self.model.setData(values: data)
    }
    
    func setColors(titleColor: Color,textColor: Color,backgroundColor: Color = UIColor(red: 1, green: 1, blue: 1,alpha: 0.3).color){
        self.model.titleColor=titleColor
        self.model.textColor=textColor
        self.model.backgroundColor=backgroundColor
    }
    
    func setDetailViewColors(_ colors: Colors){
        self.model.setColors(colors)
    }
    
    func help(){
        withAnimation(.linear(duration: 0.5), {
            //self.rotationAngle = self.rotationAngle == Angle(degrees: 360) ? Angle(degrees: 0) : Angle(degrees: 360)
            self.showHelp = self.showHelp == true ? false : true
        })
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
                                    .frame(width:self.model.descriptionWidth-30,height: self.model.stringHeight,alignment:.trailing)
                            }
                        }
                    }
                    .foregroundColor(self.model.textColor)
                    .frame(width:self.model.descriptionWidth, height: g.size.height-3*self.offset,alignment:.leading)
                    .offset(x: self.offset, y: 2*self.offset)
                    
                    
                    Group{
                        Color.clear.contentShape(Rectangle()).frame(width:CGFloat(self.model.values.count)*self.model.recordWidth)
                        HStack(spacing:0){
                            ForEach(self.model.values,id:\.self){ i in
                                //                            NavigationLink(destination: Rectangle()){
                                VStack{
                                    Text(i[0])
                                        .font(.system(size: 12))
                                        .frame(width: self.model.recordWidth,height: self.model.stringHeight,alignment:.center)
                                    Text(i[1])
                                        .font(.system(size: 12))
                                        .frame(width: self.model.recordWidth,height: self.model.stringHeight,alignment:.center)
                                    Text(i[2])
                                        .font(.system(size: 12))
                                        .frame(width: self.model.recordWidth,height: self.model.stringHeight,alignment:.center)
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: self.cornerRadius)
                                        .foregroundColor(
                                            i == self.model.valLeft ? self.clrLeft : i == self.model.valRight ? self.clrRight : Color.clear
                                        )
                                        .frame(width:self.model.recordWidth-5,alignment:.center)
                                    
                                )
                                .foregroundColor(self.model.textColor)
                                .frame(width:self.model.recordWidth)
                                //                                .modifier(HoverAndPopover(action: {
                                //                                    guard let record=self.model.findRecordByDate(i[0])
                                //                                    else{ return }
                                //                                    self.model.selectedRecord=record
                                //                                    self.detailViesIsPresented=true
                                //
                                //                                }))
                                
                                //                                .modifier(GesturesModifier(disabled:self.tapIsDisabled,action: {
                                //                                    let date = i[0].replacingOccurrences(of: "\n", with: ",")
                                //                                    guard let record=self.model.findRecordByDate(date)
                                //                                    else{ return }
                                //                                    self.model.selectedRecord=record
                                //                                    self.detailViesIsPresented=true
                                //                                }))
                                .onLongPressGesture(perform: {
                                    let date = i[0].replacingOccurrences(of: "\n", with: ",")
                                    guard let record=self.model.findRecordByDate(date)
                                    else{ return }
                                    self.model.selectedRecord=record
                                    self.detailViesIsPresented=true
                                })
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
        .rotation3DEffect(
            self.rotationAngle,
            axis: (x:0,y:1,z:0)
        )
        
        
    }
    
    
    
    
    
    
}



struct GesturesModifier:ViewModifier{
    @State var wasTapped: Bool = false
    var disabled: Bool
    var action: ()->Void
    func body(content: Content) -> some View {
        content
            .scaleEffect(self.wasTapped ? CGSize(width:0.9,height:0.9) : CGSize(width:1,height:1))
            .gesture(
                LongPressGesture(minimumDuration: 1, maximumDistance: 0)
                    .onChanged({ i in
                        if(!self.disabled){
                            self.wasTapped=true
                            DispatchQueue.global().async{
                                sleep(1)
                                self.wasTapped=false
                            }
                        }
                    }
                    )
                    .onEnded({ i in
                        if(!self.disabled){
                            print("ended")
                            self.action()
                        }
                    })
            )
    }
}
struct HoverAndPopover: ViewModifier{
    @State var pressed = false
    var action: ()->Void
    func resetPressing(){
        withAnimation(.linear(duration: 2)){
            self.pressed=false
        }
    }
    func body(content: Content) -> some View {
        content
            .colorMultiply(self.pressed ? .white.opacity(0.2) : .white)
            .onHover { hovering in
                self.pressed=hovering
            }
            .gesture(
                LongPressGesture()
                    .onChanged({ i in
                        self.pressed=true
                        self.resetPressing()
                    })
                    .onEnded({ i in
                        self.pressed=false
                        self.action()
                    })
                //                TapGesture()
                //                    .onEnded({
                //                        self.pressed=false
                //                        self.action()
                //                    })
            )
    }
}
