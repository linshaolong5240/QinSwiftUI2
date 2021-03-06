//
//  ArtistAlbumsAction.swift
//  Qin
//
//  Created by qfdev on 2021/6/11.
//

import Foundation
//歌手专辑
public struct ArtistAlbumsAction: NeteaseCloudMusicAction {
    public struct ArtistAlbumsParameters: Encodable {
        public var limit: Int
        public var offset: Int
        public var total: Bool = true
    }
    public typealias Parameters = ArtistAlbumsParameters
    public typealias ResponseType = ArtistAlbumsResponse

    public let id: Int
    public var uri: String { "/weapi/artist/albums/\(id)" }
    public let parameters: Parameters
    public let responseType = ResponseType.self
}
