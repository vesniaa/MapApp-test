//
//  NetworkDataFetcher.swift
//  MapApp
//
//  Created by Евгения Аникина on 21.06.2022.
//

import Foundation

protocol DataFetcher {
    func fetchGenericJSONData<T: Decodable>(urlString: String, completion: @escaping (Result<T?, Error>) -> Void)
}

class NetworkDataFetcher: DataFetcher {

    var networking: Networking
    
    init(networking: Networking = NetworkManager()) {
        self.networking = networking
    }
    
    func fetchGenericJSONData<T: Decodable>(urlString: String, completion: @escaping (Result<T?, Error>) -> Void) {
        print(T.self)
        networking.request(urlString: urlString) { (data, error) in
            if let error = error {
                print("Error request: \(error.localizedDescription)")
                completion(.failure(error))
            }
            let decoded = self.decodeJSON(type: T.self, from: data)
            completion(.success(decoded))

        }
    }
    
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        
        let decoder = JSONDecoder()
        
        guard let data = from else { return nil }
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print("Failed to decode JSON", jsonError)
            return nil
        }
    }
}
