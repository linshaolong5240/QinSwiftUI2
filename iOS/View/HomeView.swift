//
//  HomeView.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/30.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var player: Player
    
    private var recommendPlaylists: [PlaylistViewModel] {store.appState.playlists.recommendPlaylists}
    private var playlists: AppState.Playlists {store.appState.playlists}
    private var artist: AppState.Artist {store.appState.artist}

    private var user: User? {store.appState.settings.loginUser}
    
    var body: some View {
        NavigationView {
            ZStack {
                NEUBackgroundView()
                if user != nil {
                    VStack {
                        HStack(spacing: 20.0) {
                            Button(action: {}) {
                                NavigationLink(destination: UserView()) {
                                    NEUSFView(systemName: "person", size:  .small)
                                }
                            }
                            .buttonStyle(NEUButtonStyle(shape: Circle()))
                            SearchBarView()
                        }
                        .padding([.leading, .bottom, .trailing])
                        ScrollView {
                            PlaylistsView(title: "推荐的歌单",
                                          data: recommendPlaylists,
                                          type: .recommend)
                            PlaylistsView(title: "创建的歌单",
                                          data: playlists.createdPlaylist,
                                          type: .created)
                            PlaylistsView(title: "收藏的歌单",
                                          data: playlists.subscribePlaylists,
                                          type: .subscribed)
                            ArtistSublistView(artistSublist: artist.artistSublist)
                        }
                        BottomBarView()
                    }
                }else {
                    UserView()
                }
            }
            .navigationBarHidden(true)
        }
        .accentColor(.orange)
        .alert(item: $store.appState.error) { error in
            Alert(title: Text(error.localizedDescription))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(Store.shared)
            .environmentObject(Player.shared)
            .environment(\.colorScheme, .light)
    }
}
