//
//  VideoImageView.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 30/10/24.
//

import SwiftUI
import Kingfisher

struct VideoImageView: View {
    let imageTapped: (() -> Void)
    let closeButtonTapped: (() -> Void)
    
    var body: some View {
        Button(action: {
            imageTapped()
        }, label: {
            ZStack(alignment: .topLeading) {
                KFImage(URL(string: "https://www.tabemaro.jp/wp-content/uploads/2023/06/27910319_m-1700x1133.jpg"))
                    .resizable()
                Button(action: {
                    closeButtonTapped()
                }, label: {
                    Image(systemName: "xmark")
                })
                .frame(width: 40, height: 40)
                .tint(.white)
            }
            .aspectRatio(16 / 9, contentMode: .fit)
            .clipped()
        })
        .buttonStyle(NotHighlightButtonStyle())
    }
}

#Preview {
    VideoImageView(
        imageTapped: {
            print("imageTapped")
        },
        closeButtonTapped: {
            print("closeButtonTapped")
        }
    )
}
