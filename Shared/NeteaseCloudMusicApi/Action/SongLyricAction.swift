//
//  SongLyricAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/6.
//

import Foundation
//歌曲歌词
public struct SongLyricAction: NeteaseCloudMusicAction {
    public struct SongLyricParameters: Encodable {
        public var id: Int
        public var lv: Int = -1
        public var kv: Int = -1
        public var tv: Int = -1
    }
    public typealias Parameters = SongLyricParameters
    public typealias ResponseType = SongLyricResponse

    public var uri: String { "/weapi/song/lyric" }
    public let parameters: Parameters
    public let responseType = ResponseType.self
}
