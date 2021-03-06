//
//  PlayingNowButtonView.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2020/12/5.
//

import SwiftUI
import KingfisherSwiftUI
import struct Kingfisher.DownsamplingImageProcessor

struct PlayingNowButtonView: View {
    @EnvironmentObject private var store: Store
    @EnvironmentObject private var player: Player
    @State private var showPlayingNow: Bool = false
    
    var body: some View {
        HStack {
            NavigationLink(destination: PlayingNowView(), isActive: $showPlayingNow, label: {EmptyView()})
            Button(action: {
                showPlayingNow.toggle()
            }){
                if let url = store.appState.playing.song?.album?.picUrl {
                    KFImage(URL(string: url), options: [.processor(DownsamplingImageProcessor(size: CGSize(width: 100, height: 100)))])
                        .resizable()
                        .renderingMode(.original)
                        .aspectRatio(contentMode: .fill)
                        .mask(Circle())
                        .padding(3)
                        .rotationEffect(.degrees(player.loadTime))
                }else {
                    Image("DefaultCover")
                        .resizable()
                        .renderingMode(.original)
                        .aspectRatio(contentMode: .fill)
                        .mask(Circle())
                        .padding(3)
                }
            }
            .buttonStyle(NEUButtonStyle(shape: Circle()))
            .frame(width: 48, height: 48)
        }
    }
}

#if DEBUG
struct PlayingNowButtonView_Previews: PreviewProvider {
    static var previews: some View {
        PlayingNowButtonView()
            .environmentObject(Store.shared)
            .environmentObject(Player.shared)
    }
}
#endif
