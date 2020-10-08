//
//  SearchBarView.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2020/8/12.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var store: Store
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    private var search: AppState.Search {store.appState.search}
    private var searchBinding: Binding<AppState.Search> {$store.appState.search}
    @State private var searchType: NeteaseCloudMusicApi.SearchType = .song
    @State private var showCancel = false
    
    var body: some View {
        let searchTypeBinding = Binding<NeteaseCloudMusicApi.SearchType>(get: {
            self.searchType
        }, set: {
            self.searchType = $0
            Store.shared.dispatch(.search(keyword: search.keyword, type: searchType))
        })

        return ZStack {
            NEUBackgroundView()
            VStack {
                HStack {
                    NEUBackwardButton()
                    TextField("搜索", text: searchBinding.keyword,
                              onEditingChanged: { isEditing in
                                if showCancel != isEditing {
                                    showCancel = isEditing
                                }
                              },
                              onCommit: {
                                store.dispatch(.search(keyword: search.keyword, type: searchType))
                              })
                    .textFieldStyle(NEUTextFieldStyle(label: NEUSFView(systemName: "magnifyingglass", size: .medium)))
                    if showCancel {
                        Button(action: {
                            hideKeyboard()
                        }, label: {
                            Text("取消")
                        })
                    }
                }
                .padding(.horizontal)
                Picker(selection: searchTypeBinding, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) /*@START_MENU_TOKEN@*/{
                    Text("单曲").tag(NeteaseCloudMusicApi.SearchType.song)
                    Text("歌单").tag(NeteaseCloudMusicApi.SearchType.playlist)
                }/*@END_MENU_TOKEN@*/
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                if search.searchRequesting {
                    Text("正在搜索...")
                        .foregroundColor(.secondTextColor)
                }else {
                    switch searchType {
                    case .song:
                        SearchSongResultView()
                    case .playlist:
                        SearchPlaylistResultView()
                    default:
                        SearchSongResultView()
                    }
                }
                Spacer()
            }
            .onAppear{
                Store.shared.dispatch(.search(keyword: search.keyword))
            }
        }
        .navigationBarHidden(true)
    }
}

struct SearchPlaylistResultView: View {
    @EnvironmentObject var store: Store
    private var search: AppState.Search {store.appState.search}
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(search.playlists) { item in
                    NavigationLink(destination: PlaylistDetailView(id: item.id, type: .recommend)) {
                        SearchPlaylistResultRowView(viewModel: item)
                            .padding(.horizontal)
                    }
                }
            }
        }
    }
}
struct SearchPlaylistResultRowView: View {
    let viewModel: PlaylistViewModel
    
    var body: some View {
        HStack(alignment: .top) {
            NEUCoverView(url: viewModel.coverImgUrl, coverShape: .rectangle, size: .small)
            VStack(alignment: .leading) {
                Text(viewModel.name)
                    .foregroundColor(Color.mainTextColor)
                Text("\(viewModel.count) songs")
                    .foregroundColor(Color.secondTextColor)
            }
            Spacer()
        }
    }
}
struct SearchSongResultView: View {
    @EnvironmentObject var store: Store
    
    private var playing: AppState.Playing {store.appState.playing}
    private var search: AppState.Search {store.appState.search}

    @State var showPlayingNow: Bool = false

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(0..<search.songs.count, id: \.self) { index in
                    Button(action: {
                        Store.shared.dispatch(.setPlayinglist(playinglist: search.songs, index: index))
                        if search.songs[index].id != playing.songDetail.id {
                            Store.shared.dispatch(.playByIndex(index: index))
                        }else {
                            showPlayingNow.toggle()
                        }
                    }) {
                        SongRowView(viewModel: search.songs[index], action: {
                            if  playing.songDetail.id == search.songs[index].id {
                                store.dispatch(.PlayerPlayOrPause)
                            }else {
                                Store.shared.dispatch(.setPlayinglist(playinglist: search.songs, index: index))
                                Store.shared.dispatch(.playByIndex(index: index))
                            }
                        })
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if  playing.songDetail.id == search.songs[index].id {
                                showPlayingNow.toggle()
                            }else {
                                Store.shared.dispatch(.setPlayinglist(playinglist: search.songs, index: index))
                                Store.shared.dispatch(.playByIndex(index: index))
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        NavigationLink(destination: PlayingNowView(), isActive: $showPlayingNow) {
            EmptyView()
        }
    }
}

struct SearchBarView: View {
    @EnvironmentObject var store: Store
    private var search: AppState.Search {store.appState.search}
    private var searchBinding: Binding<AppState.Search> {$store.appState.search}
    @State private var showSearch: Bool = false
    @State private var showCancel = false

    var body: some View {
        VStack {
            NavigationLink(destination: SearchView(), isActive: $showSearch) {
                EmptyView()
            }
            HStack {
                TextField("搜索",
                          text: searchBinding.keyword,
                          onEditingChanged: { isEditing in
                            if showCancel != isEditing {
                                showCancel = isEditing
                            }
                          },
                          onCommit: {
                            if search.keyword.count > 0 {
                                showSearch = true
                            }
                          })
                .textFieldStyle(NEUTextFieldStyle(label: NEUSFView(systemName: "magnifyingglass", size: .medium)))
                .foregroundColor(.mainTextColor)
                if showCancel {
                    Button(action: {
                        hideKeyboard()
                    }, label: {
                        Text("取消")
                    })
                }
            }
        }
    }
}

#if DEBUG
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            NEUBackgroundView()
            SearchView()
                .environmentObject(Store.shared)
        }
        
//        SearchPlaylistResultRowView(viewModel: PlaylistViewModel())
//            .padding(.horizontal)
    }
}
#endif
