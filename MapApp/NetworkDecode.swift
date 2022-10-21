//
//  NetworkDecoder.swift
//  MapApp
//
//  Created by Евгения Аникина on 21.06.2022.
//

import Foundation

class NetworkDecode {
    var request: DataFetcher

    init(request: DataFetcher = NetworkDataFetcher()) {
        self.request = request
    }
    
    func getDecode(completion: @escaping (Result<MapsApp?, Error>) -> Void) {
        let url = "http://a0532495.xsph.ru/getPoint"
        request.fetchGenericJSONData(urlString: url, completion: completion)
    }
    
    func direction(from: String, to: String, completion: @escaping (Result<MapsApp?, Error>) -> Void) {
        let key = "AIzaSyDmEPvHbVoEgXfbzN6p61OgD5fjN_LaYXc"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(to)&destination=\(from)&key=\(key)"
        request.fetchGenericJSONData(urlString: url, completion: completion)
    }
}
