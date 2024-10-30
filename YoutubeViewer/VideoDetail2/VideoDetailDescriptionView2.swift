//
//  VideoDetailDescriptionView2.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 30/10/24.
//

import SwiftUI

struct VideoDetailDescriptionView2: View {
    let title = "【やる気が出ない人必見】モチベーションが上がらない｜辞めてしまいたいを変える動画"
    let description =  """
【タロサックってこんな人】
1990年生まれ　新潟県出身
18歳の時、Be動詞すら何なのかも知らない状態で偏差値38の学部を2つ受験し両方とも滑り一時露頭に迷う。
1年の浪人生活を経て外国語系の大学に無事進学しその後大手不動産会社の営業マンとして働くも幼い頃からの夢であった海外移住を叶える為に2015年に渡豪。英語力全くのゼロ、偏差値38以下から現在英語を流暢に喋れるまでになり、現在オーストラリアのシドニーにて楽しい日常を送る傍ら、主にYouTuber、英会話コーチとして活動している。
2023年1月17日、本人初の著書となる【バカでも英語がペラペラ! 超★勉強法】をダイヤモンド社より出版。【大反響！Amazonベストセラー第１位!!（2023/1/24 英語の学習法）】
TOEIC L&R Test 985点

■お仕事のご連絡はこちらまで
contact@tarosac.com

#見るだけで頭の中がグローバル化
"""
    var body: some View {
        VStack(spacing: 0) {
//            Color(.clear)
//                .frame(width: UIScreen.main.bounds.width,
//                       height: UIScreen.main.bounds.width * 0.5625)
            Spacer()
                .frame(height: 12)
            VStack(spacing: 0) {
                Text(title)
                    .font(Font.system(size: 22, weight: .bold))
                Spacer()
                    .frame(height: 16)
                Text(description)
                    .font(Font.system(size: 16))
                Spacer()
            }
            .padding([.leading, .trailing], 16)
            .background(.background)
        }
        .background(.gray)
    }
}

#Preview {
    VideoDetailDescriptionView2()
}
