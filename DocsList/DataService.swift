//
//  DataService.swift
//  DocsList
//
//  Created by Александр Медведев on 12.04.2024.
//

import Foundation

enum NetworkError: Error {
    case codeError
}

final class DataService {
    
    static let shared = DataService()
    
    private var task: URLSessionDataTask?
    
    private(set) var users: [User]=[]
    
    func fetchData(completion: @escaping (Result<[User], Error>) -> Void) {
            guard let url = URL(string: "https://api.jsonbin.io/v3/b/655b754e0574da7622c94aa4") else {return}

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard let self = self else {return}
                if let error = error {
                    print("get all data error \(error)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }

                if let response = response as? HTTPURLResponse,
                   response.statusCode < 200 || response.statusCode >= 300 {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.codeError))
                    }
                    return
                }

                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let initialAllData = try decoder.decode(AllData.self, from: data)
                    users = initialAllData.record.data.users
                    DispatchQueue.main.async {
                        self.task = nil
                        completion(.success(self.users))
                    }
                } catch {
                    print("Failed to parse the downloaded file")
                }
            }
            task?.resume()
        }
}

