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
                    if alignment == .bottom {
                        Spacer()
                    }
                    if let uiImage = library.getImageForUserWithID(user.id) {
                        let size = getSizeForImageBodyUsing(uiImage, availableSize: geometry.size)
                        ZStack(alignment: .top) {
                            
                            getPersonImage(uiImage, geometry: geometry.size)
                            getPersonText(geometry: geometry.size)
                            personMenu
                        }
                        .frame(width: size.width, height: size.height)
                        
                    } else {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .scaleEffect(x: ViewConstants.progressViewScale, y: ViewConstants.progressViewScale)
                    }
                    if alignment == .top {
                        Spacer()
                    }
                }
                
                
            }.frame(width: geometry.size.width, height: geometry.size.height)
            
        }
    }
    
    private var personMenu: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                contextMenuBody
            }
        }.padding()
        
        
    }
    
    private func getPersonText(geometry: CGSize) -> some View {
        Text(user.userName)
            .font(Font.custom("Frutiger_bold", fixedSize: ViewConstants.textSize))
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
            .frame(width: geometry.width)
            .scaleEffect(x: getScaleConstant(geometry: geometry), y: getScaleConstant(geometry: geometry))
            .padding(.vertical, ViewConstants.textVerticalPadding)
            .shadow(radius: ViewConstants.textShadowRadius)
        
    }
    
    private func getPersonImage(_ uiImage: UIImage, geometry: CGSize) -> some View {
        Image(uiImage: uiImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .scaleEffect(x: scale, y: scale)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                Image(decorative: GradientProvider.makeCustomGradientImage(colors: user.colors.map{ HexColor($0)! }), scale: 1, orientation: .up)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .blendMode(.softLight)
            }
        
            .cornerRadius(ViewConstants.imageCornerRadius * getScaleConstant(geometry: geometry))
            .shadow(radius: ViewConstants.imageShadowRadius)
        
    }
    
    private func getSizeForImageBodyUsing(_ image: UIImage, availableSize: CGSize) -> CGSize {
        let imageSize = image.size
        let scaleFactor = max(imageSize.width / availableSize.width, imageSize.height / availableSize.height)
        return CGSize(width: imageSize.width / scaleFactor, height: imageSize.height / scaleFactor)
        
    }
    
    private func getScaleConstant(geometry: CGSize) -> CGFloat {
        geometry.width / UIScreen.main.bounds.width
    }
    
    private var contextMenuBody: some View {
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
                }
            }, label: {
                Label("Delete", systemImage: "xmark.circle")
            })
        }, label: {
            HStack(spacing: ViewConstants.menySpacing) {
                Circle()
                    .frame(width: ViewConstants.menyElementWidth, height: ViewConstants.menyElementWidth)
                Circle()
                    .frame(width: ViewConstants.menyElementWidth, height: ViewConstants.menyElementWidth)
                Circle()
                    .frame(width: ViewConstants.menyElementWidth, height: ViewConstants.menyElementWidth)
            }.foregroundColor(ViewConstants.menyColor)
            
        })
    }
    
    struct ViewConstants {
        static let progressViewScale: CGFloat = 2
        
        static let imageCornerRadius: CGFloat = 20
        static let imageShadowRadius: CGFloat = 7
        
        static let textSize: CGFloat = 25
        static let textShadowRadius: CGFloat = 5
        static let textVerticalPadding: CGFloat = 10
        
        static let buttonPadding: CGFloat = 15
        
        static let menyElementWidth: CGFloat = 7
        static let menyColor: Color = .white
        static let menySpacing: CGFloat = 3
    }
    
}


//struct PersonCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        let mockUser = User(id: "1", imageUrl: "", photoLinkUrl: "", userName: "name", userUrl: "URL", colors: [])
//        PersonCardView(scale: 1.2, user: mockUser)
//    }
//}
