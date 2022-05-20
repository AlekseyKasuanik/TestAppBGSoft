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
    
    @State private var timer: Timer?
    @State private var tempTranslationWidth: CGFloat = 0
    
    @State private var animationAutoscroll = false
    
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
                } else if !isNeedAutoscroll && animationAutoscroll {
                    stopAutoScroll()
                }
            }
            .onChange(of: geometry.size) { value in
                xOffset = -geometry.size.width
                stopAutoscrollAfterRotationScreen(geometry: geometry.size)
            }
            .offset(x: draggingBegan ? (draggingXOffset + xOffset) : xOffset)
            .highPriorityGesture(DragGesture()
                .onChanged { value in
                    library.activityReport()
                    dragGestureChanged(translationWidth: value.translation.width + tempTranslationWidth, geometry: geometry.size)
                    
                }
                .onEnded { value in
                    library.activityReport()
                    dragGestureEnd(translationWidth: value.translation.width + tempTranslationWidth, geometry: geometry.size)
                    
                }
            )
        }
                                 
    }
    
    private func startAutoScroll(geometry: CGSize) {
        animationAutoscroll = true
        let step = geometry.width / ViewConstants.autoscrollFrameDuration / ViewConstants.screenHz
        var timeToNextFrame = ViewConstants.autoscrollPauseTime
        tempTranslationWidth = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1 / ViewConstants.screenHz, repeats: true) {_ in
            if timeToNextFrame >= ViewConstants.autoscrollPauseTime {
                tempTranslationWidth -= step
                if tempTranslationWidth >= -geometry.width {
                    withAnimation(.linear) {
                        dragGestureChanged(translationWidth: (tempTranslationWidth), geometry: geometry)
                    }
                } else {
                    dragGestureEnd(translationWidth: (tempTranslationWidth), geometry: geometry)
                    timeToNextFrame = 0
                }
            } else {
                timeToNextFrame += 1 / ViewConstants.screenHz
            }
        }
    }
    
    private func stopAutoscrollAfterRotationScreen(geometry: CGSize) {
        guard animationAutoscroll else { return }
        dragGestureEnd(translationWidth: (tempTranslationWidth), geometry: geometry)
        stopAutoScroll()
        library.activityReport()
    }

    private func stopAutoScroll() {
        animationAutoscroll = false
        timer?.invalidate()
    }
    
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
        }
        draggingXOffset = translationWidth
    }
    
    private func dragGestureEnd(translationWidth: CGFloat, geometry: CGSize) {
        let widthRatio = animationAutoscroll ? ViewConstants.widthRatioForAutoScroll : ViewConstants.widthRatioForScroll
        
        if translationWidth > geometry.width * widthRatio {
            xOffset -= geometry.width
            library.previousUsers()
        } else if translationWidth < -geometry.width * widthRatio{
            xOffset += geometry.width
            library.nextUsers()
        }
        
        tempTranslationWidth = 0
    
        if animationAutoscroll {
            withAnimation(.linear) {
                draggingBegan = false
                xOffset = -geometry.width
            }
        } else {
            withAnimation(.easeOut(duration: ViewConstants.autoscrollAnimationDuration)) {
                draggingBegan = false
                xOffset = -geometry.width
            }
        }

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
    
    struct ViewConstants {
        static let widthRatioForScroll: CGFloat = 0.2
        static let widthRatioForAutoScroll: CGFloat = 0.5
        static let autoscrollAnimationDuration: Double = 0.3
        static let alphaBlendModeMaxRatio: Double = 0.15
        static let startImageWidthRatio: Double = 0.9
        static let maxChangeImageWidthRatio: Double = 0.05
        static let maxParallaxRatio: Double = 0.02
        static let autoscrollFrameDuration: Double = 2
        static let autoscrollPauseTime: Double = 1
        static let screenHz: Double = 60
    }
    
}

struct EndlessScrollView_Previews: PreviewProvider {
    static var previews: some View {
        EndlessScrollView()
    }
}
