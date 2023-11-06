//
//  BasicAPIManager.swift
//  SeSACRxThreads
//
//  Created by 홍수만 on 2023/11/06.
//

import Foundation
import RxSwift

enum APIError: Error {
    case invalidURL
    case unknown
    case statusError
}

class BasicAPIManager {
    
    static func fetchData() -> Observable<SearchAppModel> {
        
        return Observable<SearchAppModel>.create { value in
            
            let urlString = "https://itunes.apple.com/search?term=todo&country=KR&media=software&lang=ko_KR&limit=10"
            
            guard let url = URL(string: urlString) else {
                value.onError(APIError.invalidURL)
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                print("URLSession Succeed")
                
                if let _ = error {
                    value.onError(APIError.unknown)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    value.onError(APIError.statusError)
                    return
                }
                
                if let data = data, let appData = try? JSONDecoder().decode(SearchAppModel.self, from: data) {
                    value.onNext(appData)
                }
                
            }.resume()
            
            return Disposables.create()
        }
        
    }
    
}
