//
//  URLSessionAPI.swift
//  TP Planning
//
//  Created by Vinit Ingale on 12/26/20.
//

import Foundation
import UIKit

enum successResponseCode: Int {
    case success = 200
    case failure = -1
}

enum HTTPMethod: Int  {
    case get
    case post
    case patch
    case put
    case delete
}

class URLSessionAPI {
    
    private init() {}
    static let sharedAPI = URLSessionAPI()
    
    private let httpMethodString = ["GET", "POST", "PATCH", "PUT","DELETE"]
    
    func performRequest(urlString : String, type: HTTPMethod, completionHandler: @escaping((statusCode: successResponseCode, response: Any, data: Data?, error: Error?) ) -> ()) {
        
        if let url = URL(string: urlString) {
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = httpMethodString[type.rawValue]
            
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                
                if let data = data {
                    do {
                        if let httpResponse = response as? HTTPURLResponse {
                            
                            if httpResponse.statusCode == 200 {
                                let responseObject = try JSONSerialization.jsonObject(with: data, options: [])
                                completionHandler((statusCode: .success, response: responseObject, data: data, error: error))
                            } else {
                                completionHandler((statusCode: .failure, response: [], data: nil, error: error))
                            }
                        }
                    } catch {
                        completionHandler((statusCode: .failure, response: [], data: nil, error: error))
                    }
                } else {
                    completionHandler((statusCode: .failure, response: [:], data: nil, error: error))
                }
            }
            
            task.resume()
        }
    }
}

struct CategoryDocument {
    var categoryValue: String
    var subCategoryValue: String?
    var leafCategoryValue: String?
    var documentName: String
    var documentYear: String?
    var fullPath: String
}

class FileManagerAPI {
    
    private init() {}
    static let shared = FileManagerAPI()
    
    var allDocsArray: [CategoryDocument] = []
    
    let baseURL = "https://tphelplinefunc.azurewebsites.net/api/"
    
    func fetchAllDocs() {
                
        URLSessionAPI.sharedAPI.performRequest(urlString: "\(baseURL)\("doclist")", type: .get) { [weak self] statusCode, response, data, error in
            
            if statusCode == .success {
                
                if let resDict = response as? [String] {
                    
                    for string in resDict {
                        
                        let array = string.components(separatedBy: "/")
                        
                        var subCategoryName: String?
                        var leafCategoryName: String?

                        if array.count >= 3 {
                            subCategoryName = array[1]
                        }
                        
                        if array.count >= 4 {
                            leafCategoryName = array[2]
                        }
                                                
                        let nameWithYearArray = array.last?.components(separatedBy: "_")
                        
                        var yearName: String = "N/A"
                        
                        if nameWithYearArray?.count ?? 1 > 1 {
                            yearName = nameWithYearArray?.last?.components(separatedBy: ".").first ?? "N/A"
                        }
                                                                            
                        self?.allDocsArray.append(CategoryDocument(categoryValue: array.first ?? "Acts", subCategoryValue: subCategoryName, leafCategoryValue: leafCategoryName, documentName: nameWithYearArray?.first ?? "Document", documentYear: yearName, fullPath: string))
                        
                    }
                }
            } 
        }
    }
}


