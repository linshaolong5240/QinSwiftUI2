//
//  AlbumSublistAction.swift
//  Qin
//
//  Created by qfdev on 2021/6/11.
//

import Foundation
//专辑收藏列表
public struct AlbumSublistAction: NeteaseCloudMusicAction {
    public struct AlbumSublistParameters: Encodable {
        public var limit: Int
        public var offset: Int
        public var total: Bool = true
    }
    public typealias Parameters = AlbumSublistParameters
    public typealias ResponseType = AlbumSublistResponse

    public let uri: String = "/weapi/album/sublist"
    public let parameters: Parameters
    public let responseType = ResponseType.self
}
