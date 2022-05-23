//
//  testView.swift
//  TestAppBGSoft
//
//  Created by Алексей Касьяник on 20.05.22.
//

import SwiftUI


struct DemoDragRelocateView: View {
    
    
    private func getStartOffset(geometry: CGSize) -> CGFloat {
        if items.count % (rowsCount * rowsCount) == 0 {
            return -geometry.width/2
        } else {
            return -geometry.width/4
        }
 //       return 0
    }
    
    
    @State private var xOffset: CGFloat = 0
    @State private var draggingXOffset: CGFloat = 0
    
    @State private var xOffsetRatio: CGFloat = 0
    @State private var draggingXOffsetRatio: CGFloat = 0
    
    
    @State private var draggingBegan = false
    
    @State private var startXOffset: CGFloat = 0
    
    
    
    
    
    
//    @State var items: [BaseItem] = [BaseItem(1),BaseItem(2),BaseItem(3),BaseItem(4),BaseItem(5),BaseItem(6),BaseItem(7),BaseItem(8),BaseItem(9),BaseItem(1),BaseItem(2),BaseItem(3),BaseItem(4),BaseItem(5),BaseItem(6),BaseItem(7),BaseItem(8),BaseItem(9)]
    
//    @State var items: [BaseItem] = [BaseItem(1, color: .red)
//                                    ,BaseItem(2, color: .green)
//                                    ,BaseItem(3, color: .blue)
//                                    ,BaseItem(4, color: .gray)
//                                    ,BaseItem(1, color: .red)
//                                    ,BaseItem(2, color: .green)
//                                    ,BaseItem(3, color: .blue)
//                                    ,BaseItem(4, color: .gray)]
    
    
    @State var items: [BaseItem] = [BaseItem(1, color: .red)
                                    ,BaseItem(2, color: .red)
                                    ,BaseItem(3, color: .red)
                                    ,BaseItem(4, color: .red)

                                    ,BaseItem(5, color: .green)
                                    ,BaseItem(6, color: .green)
                                    ,BaseItem(7, color: .green)
                                    ,BaseItem(8, color: .green)

                                    ,BaseItem(9, color: .blue)
                                    ,BaseItem(10, color: .blue)
                                    ,BaseItem(11, color: .blue)
                                    ,BaseItem(12, color: .blue)

                                    ,BaseItem(13, color: .gray)
                                    ,BaseItem(14, color: .gray)
                                    ,BaseItem(15, color: .gray)
                                    ,BaseItem(16, color: .gray)

                                    ,BaseItem(1, color: .red)
                                    ,BaseItem(2, color: .red)
                                    ,BaseItem(3, color: .red)
                                    ,BaseItem(4, color: .red)

                                    ,BaseItem(5, color: .green)
                                    ,BaseItem(6, color: .green)
                                    ,BaseItem(7, color: .green)
                                    ,BaseItem(8, color: .green)

                                    ,BaseItem(9, color: .blue)
                                    ,BaseItem(10, color: .blue)
                                    ,BaseItem(11, color: .blue)
                                    ,BaseItem(12, color: .blue)

                                    ,BaseItem(13, color: .gray)
                                    ,BaseItem(14, color: .gray)
                                    ,BaseItem(15, color: .gray)
                                    ,BaseItem(16, color: .gray)

    ]
    
//    @State var items: [BaseItem] = [BaseItem(1, color: .red)
//                                    ,BaseItem(1, color: .red)]
    
    @State var rowsCount = 1
    
    
    var body: some View  {
        GeometryReader { geometry in
            HStack {
                DragAndDropLazyHGrid(rowsCount: $rowsCount, items: items) { item in
            ZStack {
                Rectangle()
                
                    .foregroundColor(item.color)
                VStack {
                Text(item.text)
                    Text(geometry.size.width.description)
                    Text(xOffset.description)
                }
                
            }.frame(width: geometry.size.width / CGFloat(rowsCount), height: geometry.size.height / CGFloat(rowsCount))
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            
        } moveAction: { from, to in
            items.move(fromOffsets: from, toOffset: to)
        }
            }
        .frame(width: geometry.size.width, height: geometry.size.height)
      //  .offset(x: draggingBegan ? (draggingXOffset + xOffset) : xOffset)
        .offset(x: getStartOffset(geometry: geometry.size) + (draggingBegan ? (draggingXOffsetRatio + xOffsetRatio) : xOffsetRatio) * geometry.size.width)
            .highPriorityGesture(DragGesture()
                .onChanged { value in
                    //   library.activityReport()
                    dragGestureChanged(translationWidth: value.translation.width, geometry: geometry.size)

                }
                .onEnded { value in
                    //   library.activityReport()
                    dragGestureEnd(translationWidth: value.translation.width, geometry: geometry.size, animation: true)

                }
            )
            .gesture(MagnificationGesture()
                .onEnded { value in
                    if value > 2 && rowsCount == 2 {
                        
                        let offset = xOffsetRatio
                        print("ONEEE")
                        print("offset", CGFloat(Int(offset * 4)))
                     //   withAnimation {
                        
                        withAnimation(.linear(duration: 0.05)) {
                            rowsCount = 1
                            xOffsetRatio = CGFloat(Int(offset * 4))
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            dragGestureChanged(translationWidth: 0, geometry: geometry.size)
                            dragGestureEnd(translationWidth: 0, geometry: geometry.size, animation: false)
                        }
                    } else if value < 0.5 && rowsCount == 1 {
                        let offset = xOffsetRatio
                        withAnimation(.linear(duration: 0.1)) {
                            rowsCount = 2
                            xOffsetRatio = CGFloat(Int(offset / 4))
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            dragGestureChanged(translationWidth: 0, geometry: geometry.size)
                            dragGestureEnd(translationWidth: 0, geometry: geometry.size, animation: false)
                        }
                        
                        print("TWOOOO")
                        print("offset", CGFloat(Int(offset / 4)))
                   //     withAnimation(.linear(duration: 5)) {
                        
                    }
                }
            )
        }


    }
    
    
    @State var lastScaleValue: CGFloat = 1.0
    
    private func dragGestureChanged(translationWidth: CGFloat, geometry: CGSize) {
        draggingBegan = true
        draggingXOffsetRatio = translationWidth / geometry.width
    }
    
    private func dragGestureEnd(translationWidth: CGFloat, geometry: CGSize, animation: Bool) {
        print("DRAGEND")
        let animationAutoscroll = false
        let widthRatio = animationAutoscroll ? ViewConstants().widthRatioForAutoScroll : ViewConstants().widthRatioForScroll
        var offsetNeed: CGFloat = 0
                if translationWidth > geometry.width * widthRatio {
                    offsetNeed = 1
                } else if translationWidth < -geometry.width * widthRatio{
                    offsetNeed = -1
                }
        
    //CGFloat(rowsCount * rowsCount)
        
        let extremeValue = CGFloat(Int(CGFloat(items.count / 2) / CGFloat(rowsCount * rowsCount))) - 1
//
//
        if (xOffsetRatio + offsetNeed) <= -extremeValue{

            xOffsetRatio = 2
        } else if (xOffsetRatio + offsetNeed) >= extremeValue {
            xOffsetRatio = -2
        }
        
        if animation {
        
        withAnimation(.easeOut(duration: ViewConstants().autoscrollAnimationDuration)) {
            draggingBegan = false
            xOffsetRatio += offsetNeed
        }
            
        } else {
            withAnimation(.easeOut(duration: 0.01)) {
            draggingBegan = false
            xOffsetRatio += offsetNeed
            }
        }
    }

    
//    private func dragGestureChanged(translationWidth: CGFloat, geometry: CGSize) {
//        draggingBegan = true
//        draggingXOffset = translationWidth
//    }
//
//    private func dragGestureEnd(translationWidth: CGFloat, geometry: CGSize) {
//        print("DRAGEND")
//        let animationAutoscroll = false
//        let widthRatio = animationAutoscroll ? ViewConstants().widthRatioForAutoScroll : ViewConstants().widthRatioForScroll
//        var offsetNeed: CGFloat = 0
//                if translationWidth > geometry.width * widthRatio {
//                    offsetNeed = geometry.width
//                } else if translationWidth < -geometry.width * widthRatio{
//                    offsetNeed = -geometry.width
//                }
//
//       let extremeValue = geometry.width * CGFloat(Int(CGFloat(items.count) / 2 / CGFloat(rowsCount * rowsCount))) + getStartOffset(geometry: geometry)
//
//
//        if (xOffset + offsetNeed) <= -extremeValue{
//
//            xOffset = getStartOffset(geometry: geometry) + 2 * geometry.width
//        } else if (xOffset + offsetNeed) >= extremeValue {
//            xOffset = getStartOffset(geometry: geometry) -  geometry.width
//        }
//
//        withAnimation(.easeOut(duration: ViewConstants().autoscrollAnimationDuration)) {
//            draggingBegan = false
//            xOffset += offsetNeed
//        }
//
//
//    }
    
    struct ViewConstants {
        
        
        let gridSpacing: CGFloat = 0
        let itemOpacity: Double = 0.8
        
        
        let widthRatioForScroll: CGFloat = 0.2
        let widthRatioForAutoScroll: CGFloat = 0.5
        let autoscrollAnimationDuration: Double = 0.3
//        let alphaBlendModeMaxRatio: Double = 0.15
//        let startImageWidthRatio: Double = 0.9
//        let maxChangeImageWidthRatio: Double = 0.05
//        let maxParallaxRatio: Double = 0.02
//        let autoscrollFrameDuration: Double = 2
//        let autoscrollPauseTime: Double = 1
//        let screenHz: Double = 60
    }
    
    
    

}


struct BaseItem: Identifiable, Equatable {
    let id = UUID()
    let color: Color //= UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
    let text: String
    
    init(_ value: Int, color: Color) {
        self.text = value.description
        self.color = color
    }
    
}
