//
//  EndlessScrollView.swift
//  TestAppBGSoft
//
//  Created by Алексей Касьяник on 19.05.22.
//

import SwiftUI
import UIKit
import Foundation

struct EndlessScrollView: View {
    
    @EnvironmentObject var library: UsersLibrary
    
    @State private var xOffset: CGFloat = 0
    @State private var draggingXOffset: CGFloat = 0
    @State private var draggingBegan = false
    
    @State private var offsetDirection: OffsetDirection = .center
    
    @State private var timer: Timer?
    @State private var tempTranslationWidth: CGFloat = 0
    
    var body: some View {
        GeometryReader{geometry in
            HStack(spacing: 0){
                if library.screenUsers != [nil,nil,nil] {
                    
                    Group() {
                        GeometryReader { localGeometry in
                            getScrollViewElement(index: 0, geometry: geometry.size, localGeometry: localGeometry.frame(in: .global))
                        }
                    }
                    .frame(width: geometry.size.width, height:  geometry.size.height)
                    
                    Group() {
                        GeometryReader { localGeometry in
                            getScrollViewElement(index: 1, geometry: geometry.size, localGeometry: localGeometry.frame(in: .global))
                        }
                    }
                    .frame(width: geometry.size.width, height:  geometry.size.height)
                    
                    Group() {
                        GeometryReader { localGeometry in
                            getScrollViewElement(index: 2, geometry: geometry.size, localGeometry: localGeometry.frame(in: .global))
                        }
                    }
                    .frame(width: geometry.size.width, height:  geometry.size.height)
                    
                }
            }
            .onAppear {
                xOffset = -geometry.size.width
                draggingXOffset = xOffset
            }
            .onReceive(library.$needAutoscroll) { isNeedAutoscroll in
                if isNeedAutoscroll && !animationAutoscroll {
                    startAutoScroll(geometry: geometry.size)
                    animationAutoscroll = true
                } else if !isNeedAutoscroll && animationAutoscroll {
                    animationAutoscroll = false
                    stopAutoScroll()
                }
            }
            
            .offset(x: draggingBegan ? (draggingXOffset + xOffset) : xOffset)
            .highPriorityGesture(DragGesture()
                .onChanged { value in
                    dragGestureChanged(translationWidth: value.translation.width + tempTranslationWidth, geometry: geometry.size)
                    library.activityReport()
                }
                .onEnded { value in
                    dragGestureEnd(translationWidth: value.translation.width + tempTranslationWidth, geometry: geometry.size)
                    library.activityReport()
                }
            )
        }
                                 
    }
    
    private func startAutoScroll(geometry: CGSize) {
        let step = geometry.width / ViewConstants.autoscrollFrameDuration / ViewConstants.screenHz
        tempTranslationWidth = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1 / ViewConstants.screenHz, repeats: true) {_ in
            tempTranslationWidth -= step
            if tempTranslationWidth > -geometry.width {
            dragGestureChanged(translationWidth: (tempTranslationWidth), geometry: geometry)
            } else {
                dragGestureEnd(translationWidth: (tempTranslationWidth), geometry: geometry)
            }
        }
    }
    
    private func stopAutoScroll() {
        
        timer?.invalidate()
    }
    
    @State private var animationAutoscroll = false
    
    
    private func getScrollViewElement(index: Int, geometry: CGSize, localGeometry: CGRect) -> some View {
        ZStack {
            let scale = getScale(
                localGeometry: localGeometry,
                globalGeometry: geometry )
            
            let imageScale = getImageScale(
                localGeometry: localGeometry,
                globalGeometry: geometry )
            
            let opacity = getOpacity(
                localGeometry: localGeometry,
                globalGeometry: geometry )
            
            PersonCardView(scale: imageScale, user: library.screenUsers[index]!)
                .frame(width: geometry.width * scale, height:  geometry.height * scale)
                .opacity(opacity)
        }.frame(width: localGeometry.size.width, height:  localGeometry.size.height)
    }
    
    private func dragGestureChanged(translationWidth: CGFloat, geometry: CGSize) {
        if !draggingBegan {
            draggingBegan = true
            
            switch offsetDirection {
                
            case .left:
                draggingXOffset = xOffset - geometry.width
                library.previousUsers()
                
            case .right:
                draggingXOffset = xOffset + geometry.width
                library.nextUsers()
            case .center:
                draggingXOffset = xOffset
            }
            
            xOffset = draggingXOffset
        }
        draggingXOffset = translationWidth
    }
    
    private func dragGestureEnd(translationWidth: CGFloat, geometry: CGSize) {
        offsetDirection = .center
        var offset = xOffset
        if translationWidth > geometry.width * ViewConstants.widthRatioForScroll {
            offset += geometry.width
            offsetDirection = .left
        } else if translationWidth < -geometry.width * ViewConstants.widthRatioForScroll {
            offset -= geometry.width
            offsetDirection = .right
        }
        tempTranslationWidth = 0
        withAnimation(.easeOut(duration: ViewConstants.autoscrollAnimationDuration)) {
            draggingBegan = false
            xOffset = offset
        }
        print("offsetDirection", offsetDirection)
    }
    
    private func getOpacity(localGeometry: CGRect, globalGeometry: CGSize) -> Double {
        let globalGeometryMidX = globalGeometry.width / 2
        return (1 - (abs(localGeometry.midX - globalGeometryMidX) / globalGeometryMidX) * ViewConstants.alphaBlendModeMaxRatio)
    }
    
    private func getScale(localGeometry: CGRect, globalGeometry: CGSize) -> Double {
        let globalGeometryMidX = globalGeometry.width / 2
        return (ViewConstants.startImageWidthRatio - (abs(localGeometry.midX - globalGeometryMidX) / globalGeometryMidX) * ViewConstants.maxChangeImageWidthRatio)
    }
    
    private func getImageScale(localGeometry: CGRect, globalGeometry: CGSize) -> Double {
        let globalGeometryMidX = globalGeometry.width / 2
        return (1 + (abs(localGeometry.midX - globalGeometryMidX) / globalGeometryMidX) * ViewConstants.maxParallaxRatio)
    }
    
    private enum OffsetDirection {
        case left
        case right
        case center
    }
    
    struct ViewConstants {
        static let widthRatioForScroll: CGFloat = 0.2
        static let autoscrollAnimationDuration: Double = 0.3
        static let alphaBlendModeMaxRatio: Double = 0.15
        static let startImageWidthRatio: Double = 0.9
        static let maxChangeImageWidthRatio: Double = 0.05
        static let maxParallaxRatio: Double = 0.02
        static let autoscrollFrameDuration: Double = 2
        static let screenHz: Double = 60
    }
    
}

struct EndlessScrollView_Previews: PreviewProvider {
    static var previews: some View {
        EndlessScrollView()
    }
}
