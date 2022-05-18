//
//  PersonCardView.swift
//  TestAppBGSoft
//
//  Created by Алексей Касьяник on 18.05.22.
//

import SwiftUI

struct PersonCardView: View {
    @EnvironmentObject var library: UsersLibrary
    
    var user: User
    var body: some View {
        GeometryReader { geometry in
        ZStack{
            
        if let data = library.getImageDataForUserWithID(user.id), let uiImage = UIImage(data: data)  {
            let size = getSizeForImageBodyUsing(uiImage, availableSize: geometry.size)
            ZStack(alignment: .top) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                Text(user.userName)
                    .bold()
                    .foregroundColor(.white)
                    .padding()

            }
            .frame(width: size.width, height: size.height)
            .contextMenu{
                contextMenuBody
            }
        } else {
            Text("Loading...")
        }
            
        }.frame(width: geometry.size.width, height: geometry.size.height)

        }
    }
    
    private func getSizeForImageBodyUsing(_ image: UIImage, availableSize: CGSize) -> CGSize {
        let imageSize = image.size
        let scaleFactor = max(imageSize.width / availableSize.width, imageSize.height / availableSize.height)
        return CGSize(width: imageSize.width / scaleFactor, height: imageSize.height / scaleFactor)
        
    }
    
    private var contextMenuBody: some View {
        Group {
        Button(action: {
            guard let url = URL(string: user.userUrl) else {return}
                UIApplication.shared.open(url)
        }) {
            HStack {
                Image(systemName: "person.crop.circle")
                Text("Person")
            }
        }
        Button(action: {
            guard let url = URL(string: user.photoUrl) else {return}
                UIApplication.shared.open(url)
        }) {
            HStack {
                Image(systemName: "photo")
                Text("Photo")
            }
        }
    }
    }
}


struct PersonCardView_Previews: PreviewProvider {
    static var previews: some View {
        let mockUser = User(imageUrl: "", photoUrl: "", userName: "name", userUrl: "URL", colors: [])
        PersonCardView(user: mockUser)
    }
}
