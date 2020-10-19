//
//  AppState.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/14.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation
import AVFoundation
import Combine
import CoreData

struct AppState {
    var album = Album()
    var artist = Artist()
    var comment = Comment()
    var lyric = Lyric()
    var playing = Playing()
    var playlist = Playlist()
    var playlistDetail = PlaylistDetail()
    var search = Search()
    var settings = Settings()
    var error: AppError?
}

extension AppState {
    struct Settings {
        enum AccountBehavior: CaseIterable {
            case login, logout
        }
        enum PlayMode: Int, CaseIterable {
            case playlist = 0, relplay
            var systemName: String {
                switch self {
                case .playlist:
                    return "repeat"
                case .relplay:
                    return "repeat.1"
                }
            }
        }
        enum Theme: CaseIterable {
            case dark, light, system
        }
        var accountBehavior = AccountBehavior.login
        var coverShape: NEUCoverShape {
            get {
                NEUCoverShape(rawValue: UserDefaults.standard.integer(forKey: "coverShape"))!
            }
            set {
                UserDefaults.standard.set(newValue.rawValue, forKey: "coverShape")
            }
        }
        var loginRequesting = false
        var loginUser: User? = DataManager.shared.getUser()
        var loginError: AppError?
        var playMode: PlayMode {
            get {
                PlayMode(rawValue: UserDefaults.standard.integer(forKey: "playMode"))!
            }
            set {
                UserDefaults.standard.set(newValue.rawValue, forKey: "playMode")
            }
        }
        var theme: Theme = .light
    }
    
    struct Album {
        var albumRequesting: Bool = false
        var albumSublistRequesting: Bool = false
        var albumViewModel =  AlbumDetailViewModel()
        var albumSublist = [AlbumSub]()
    }
    
    struct Artist {
        var artistRequesting: Bool = false
        var artistAlbumRequesting: Bool = false
        var artistMVRequesting: Bool = false
        var artistSublistRequesting: Bool = false

        var viewModel = ArtistViewModel()
        var artistSublist = [ArtistViewModel]()
        var error: AppError?
    }
    
    struct Comment {
        var commentRequesting = false
        var commentMusicRequesting = false
        var hotComments = [CommentViewModel]()
        var comments = [CommentViewModel]()
        var id: Int = 0
        var offset: Int = 0
        var total: Int = 0
    }
    struct PlaylistDetail {
        var viewModel = PlaylistViewModel()
        var requesting: Bool = false
    }
    
    struct Playlist {
        //用户相关歌单
        var createdPlaylist = [PlaylistViewModel]()
        var recommendPlaylists = [PlaylistViewModel]()
        var recommendSongsPlaylist = PlaylistViewModel()
        var subscribePlaylists = [PlaylistViewModel]()
        
        //分类歌单
        var discoverPlaylistViewModel = DiscoverPlaylistViewModel()
        
        var likedIds = [Int]()
        var likedPlaylistId: Int = 0
        var playlistOrderUpdateRequesting: Bool = false
        var recommendPlaylistRequesting: Bool = false
        var songsDetailRequesting: Bool = false
        var songsURLRequesting: Bool = false
        var userPlaylistRequesting: Bool = false
    }
    
    struct Playing {
        var index: Int {
            get {
                UserDefaults.standard.integer(forKey: "playingIndex")
            }
            set {
                UserDefaults.standard.set(newValue, forKey: "playingIndex")
            }
        }
        var isSeeking: Bool = false
        
        //var playinglist = [SongViewModel]()
        var playinglist: [SongViewModel] {
            get {
                let data = UserDefaults.standard.array(forKey: "playinglist") as? [Data]
                if let songs = data?.map({$0.toModel(SongViewModel.self) ?? SongViewModel()}) {
                    return songs
                }else {
                    return [SongViewModel()]
                }
            }
            set {
                let data: [Data] =  newValue.map{
                    var data = Data()
                    do {
                        data =  try JSONEncoder().encode($0)
        //                newValue.map{$0.}
                    }
                    catch let error{
                        print(error)
                    }
                    return data
                }
                UserDefaults.standard.set(data, forKey: "playinglist")
            }
        }

        var playingError: AppError?
        var songDetail: SongViewModel {
            get {
                return UserDefaults.standard.data(forKey: "playingSongDetail")?.toModel(SongViewModel.self) ?? SongViewModel()
            }
            set {
                do {
                    UserDefaults.standard.set(try JSONEncoder().encode(newValue), forKey: "playingSongDetail")

                } catch let error {
                    print(error)
                }
            }
        }
        
        var songUrl: String?

//        var songUrl: String? {
//            get {
//                UserDefaults.standard.string(forKey: "playingSongUrl")
//            }
//            set {
//                UserDefaults.standard.set(newValue, forKey: "playingSongUrl")
//            }
//        }
        
        var loadTime: Double = 0
        var seekTime: Double = 0
        var totalTime: Double = 0
        var loadPercent: Double = 0
        var loadTimelabel: String = "00:00"
        var totalTimeLabel: String = "00:00"
    }
    
    struct Lyric {
        var getLyricRequesting = false
        var getlyricError: AppError?
        var lyric: LyricViewModel?
    }
    
    struct Search {
        var keyword: String = ""
        var searchRequesting: Bool = false
        var songs = [SongViewModel]()
        var playlists = [PlaylistViewModel]()
    }
}
