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
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                if let uiImage = library.getImageForUserWithID(user.id) {
                    let size = getSizeForImageBodyUsing(uiImage, availableSize: geometry.size)
                    ZStack(alignment: .top) {
                        getPersonImage(uiImage)
                        personName
                    }
                    .frame(width: size.width, height: size.height)
                    
                } else {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(x: ViewConstants.progressViewScale, y: ViewConstants.progressViewScale)
                }
            }.frame(width: geometry.size.width, height: geometry.size.height)
            
        }
    }
    
    private var personName: some View {
        Text(user.userName)
            .bold()
            .foregroundColor(.white)
            .padding()
            .contextMenu{
                contextMenuBody
            }
    }
    
    private func getPersonImage(_ uiImage: UIImage) -> some View {
        Image(uiImage: uiImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .scaleEffect(x: scale, y: scale)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            .cornerRadius(ViewConstants.imageCornerRadius)
            .shadow(radius: ViewConstants.imageShadowRadius)
    }
    
    private func getSizeForImageBodyUsing(_ image: UIImage, availableSize: CGSize) -> CGSize {
        let imageSize = image.size
        let scaleFactor = max(imageSize.width / availableSize.width, imageSize.height / availableSize.height)
        return CGSize(width: imageSize.width / scaleFactor, height: imageSize.height / scaleFactor)
        
    }
    
    private var contextMenuBody: some View {
        Group {
            Button(action: {
                user.openUserUrl()
            }) {
                HStack {
                    Image(systemName: "person.crop.circle")
                    Text("Person")
                }
            }
            Button(action: {
                user.openPhotoUrl()
            }) {
                HStack {
                    Image(systemName: "photo")
                    Text("Photo")
                }
            }
        }
    }
    
    struct ViewConstants {
        static let progressViewScale: CGFloat = 2
        static let imageCornerRadius: CGFloat = 15
        static let imageShadowRadius: CGFloat = 5
    }

}


struct PersonCardView_Previews: PreviewProvider {
    static var previews: some View {
        let mockUser = User(imageUrl: "", photoLinkUrl: "", userName: "name", userUrl: "URL", colors: [])
        PersonCardView(scale: 1.2, user: mockUser)
    }
}
