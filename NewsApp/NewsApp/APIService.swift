//
//  APIService.swift
//  NewsApp
//
//  Created by Arundas MK on 07/01/23.
//

import Foundation


final class APIService {
    static let shared = APIService()
    private init() {}
    
    struct Constants {
        static let topHeadLinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=b56d15521ad1471cbf3ad4b06891b982")
    }
    
    public func getTopStories(completion: @escaping (Result<[Article], Error>)-> Void) {
        guard let url = Constants.topHeadLinesURL else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(HeadLineResponse.self, from: data)
                    completion(.success(result.articles ?? []))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}


struct HeadLineResponse: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]?
}

struct Article: Codable {
    let title: String?
    let description: String?
    let content: String?
    let url: String?
    let urlToImage: String?
    let author: String?
    let source: Source?
}

struct Source: Codable {
    let id: String?
    let name: String?
}
