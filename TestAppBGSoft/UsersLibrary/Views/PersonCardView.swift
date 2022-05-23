//
//  PersonCardView.swift
//  TestAppBGSoft
//
//  Created by Алексей Касьяник on 18.05.22.
//

import SwiftUI

struct PersonCardView: View {
    
    @EnvironmentObject var library: UsersLibrary
    
    var scale: CGFloat
    var user: User
    var alignment: Alignment?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                VStack {
                    if let uiImage = library.getImageForUserWithID(user.id) {
                        let size = getSizeForImageBodyUsing(uiImage, availableSize: geometry.size)
                        if alignment == .bottom {
                            Spacer()
                        }
                        ZStack(alignment: .top) {
                            getPersonImage(uiImage, geometry: geometry.size)
                            getPersonText(geometry: size)
                            getPersonMenu(geometry: geometry.size)
                        }
                        .frame(width: size.width, height: size.height)
                        if alignment == .top {
                            Spacer()
                        }
                        
                    } else {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .scaleEffect(x: ViewConstants.progressViewScale, y: ViewConstants.progressViewScale)
                    }
                    
                }
                
            }
            
            .frame(width: geometry.size.width, height: geometry.size.height)
            .contentShape(Rectangle())
            .onTapGesture {
                library.closeContextMenu()
            }
        }
    }
    
    private func getPersonMenu(geometry: CGSize) -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                getContextMenuBody(geometry: geometry)
            }
        }
    }
    
    private func getPersonText(geometry: CGSize) -> some View {
        Text(user.userName)
            .frame(width: geometry.width)
            .font(Font.custom("Frutiger_bold", fixedSize: ViewConstants.textSize))
            .scaleEffect(x: getTextScale(), y: getTextScale() * ViewConstants.textYScale)
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
            .padding(.zero)
            .padding(.vertical, ViewConstants.textVerticalPadding * getScaleConstant(geometry: geometry))
            .shadow(radius: ViewConstants.textShadowRadius)
    }
    
    private func getPersonImage(_ uiImage: UIImage, geometry: CGSize) -> some View {
        Image(uiImage: uiImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .scaleEffect(x: scale * ViewConstants.scaleForRemovingWhiteLines, y: scale * ViewConstants.scaleForRemovingWhiteLines)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                Image(decorative: library.getGradientImageForUserWithID(user.id)!, scale: 1, orientation: .up)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .blendMode(.softLight)
            }
            .cornerRadius(ViewConstants.imageCornerRadius * getScaleConstant(geometry: geometry))
            .shadow(radius: ViewConstants.imageShadowRadius)
        
    }
    
    private func getTextScale() -> CGFloat {
        var scale: CGFloat = 1
        if UIDevice.current.userInterfaceIdiom == .pad {
            scale *= ViewConstants.iPadScale
        }
        if library.twoRowsMode {
            scale /= 2
        }
        return scale
    }
    
    private func getSizeForImageBodyUsing(_ image: UIImage, availableSize: CGSize) -> CGSize {
        let imageSize = image.size
        let scaleFactor = max(imageSize.width / availableSize.width, imageSize.height / availableSize.height)
        return CGSize(width: imageSize.width / scaleFactor, height: imageSize.height / scaleFactor)
    }
    
    private func getScaleConstant(geometry: CGSize) -> CGFloat {
        min(geometry.width, geometry.height) / ViewConstants.defaultWidth
    }
    
    private func getContextMenuBody(geometry: CGSize) -> some View {
        Menu(content: {
            Button(action: {
                user.openUserUrl()
            }) {
                Label("Person", systemImage: "person.crop.circle")
            }
            
            Button(action: {
                user.openPhotoUrl()
            }) {
                Label("Photo", systemImage: "photo")
            }
            Button(role: .destructive, action: {
                withAnimation {
                    library.deleteUser(user)
                    library.closeContextMenu()
                }
            }, label: {
                Label("Delete", systemImage: "xmark.circle")
            })
        }, label: {
            HStack(spacing: ViewConstants.menySpacing * getTextScale()) {
                Circle()
                    .frame(width: ViewConstants.menyElementWidth,
                           height: ViewConstants.menyElementWidth)
                    .scaleEffect(x: getTextScale(), y: getTextScale())
                    .shadow(radius: ViewConstants.menyShadowRadius)
                Circle()
                    .frame(width: ViewConstants.menyElementWidth,
                           height: ViewConstants.menyElementWidth)
                    .scaleEffect(x: getTextScale(), y: getTextScale())
                    .shadow(radius: ViewConstants.menyShadowRadius)
                Circle()
                    .frame(width: ViewConstants.menyElementWidth,
                           height: ViewConstants.menyElementWidth)
                    .scaleEffect(x: getTextScale(), y: getTextScale())
                    .shadow(radius: ViewConstants.menyShadowRadius)
            }.foregroundColor(ViewConstants.menyColor)
                .padding(ViewConstants.imageCornerRadius * getScaleConstant(geometry: geometry))
                .clipShape(Rectangle())
        })
        .highPriorityGesture(TapGesture()
            .onEnded {
                library.openContextMenu()
            })
    }
    
    struct ViewConstants {
        static let progressViewScale: CGFloat = 2
        
        static let imageCornerRadius: CGFloat = 30
        static let imageShadowRadius: CGFloat = 7
        
        static let textSize: CGFloat = 22
        static let iPadScale: CGFloat = 1.4
        static let textShadowRadius: CGFloat = 5
        static let textVerticalPadding: CGFloat = 15
        static let textYScale: CGFloat = 1.4
        
        static let buttonPadding: CGFloat = 15
        
        static let menyElementWidth: CGFloat = 8
        static let menyColor: Color = .white
        static let menySpacing: CGFloat = 4
        static let menyShadowRadius: CGFloat = 4
        
        static let scaleForRemovingWhiteLines: CGFloat = 1.03
        static let defaultWidth: CGFloat = 400
    }
    
}


struct PersonCardView_Previews: PreviewProvider {
    static var previews: some View {
        let mockUser = User(id: "1", imageUrl: "", photoLinkUrl: "", userName: "name", userUrl: "URL", colors: [])
        PersonCardView(scale: 1.2, user: mockUser)
    }
}
