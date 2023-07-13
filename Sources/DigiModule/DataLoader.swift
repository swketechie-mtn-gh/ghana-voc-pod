//
//  DataLoader.swift
//  DigiModule
//
//  Created by Ilya Kostyukevich on 22.08.2022.
//

import Foundation
import UIKit

final class DataLoader {
    static func getFileUpdateDate(url: URL, completion: @escaping Completion<Result<String, GenericError>>) {
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.dataLoading(error.localizedDescription)))
            } else if let httpResponse = response as? HTTPURLResponse,
                      let dateString = httpResponse.allHeaderFields["Last-Modified"] as? String {
                completion(.success(dateString))
            } else {
                completion(.failure(.message("Fail to get metadata")))
            }
        }
        
        task.resume()
    }
    
    static func downloadFile(url: URL, completion: @escaping Completion<Result<String, GenericError>>) {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
        let fileManager = FileManager()

        if fileManager.fileExists(atPath: destinationUrl.path) {
            Log("File already exists [\(destinationUrl.path)]")
            
            do {
                try fileManager.removeItem(atPath: destinationUrl.path)
                downloadFile(url: url, completion: completion)
            } catch {
                completion(.failure(.message(error.localizedDescription)))
            }
        } else {
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            let task = session.dataTask(with: request, completionHandler: { data, response, error in
                if let error = error {
                    completion(.failure(.dataLoading(error.localizedDescription)))
                } else if let response = response as? HTTPURLResponse,
                          response.statusCode == 200,
                          let data = data {
                   
                    do {
                        try data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                        completion(.success(destinationUrl.path))
                    } catch {
                        completion(.failure(.dataLoading(error.localizedDescription)))
                    }
                }
            })
            task.resume()
        }
    }
}
