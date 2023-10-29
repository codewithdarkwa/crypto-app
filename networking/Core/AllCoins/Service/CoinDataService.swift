//
//  CoinDataService.swift
//  networking
//
//  Created by Darkwa John on 29/10/2023.
//

import Foundation

class CoinDataService{
    
    private let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=50&page=1&sparkline=false&locale=en"
    
    func fetchCoins() async throws -> [Coin]{
        guard let url = URL(string: urlString) else {return []}
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            let coins = try JSONDecoder().decode([Coin].self, from: data)
            
            return coins
        }catch{
            print("Error: \(error.localizedDescription)")
            return []
        }
        
       
    }
    
}
    //MARK: -Completion handler
    extension CoinDataService{
        func fetchCoinsWithResult( completion: @escaping(Result<[Coin], CoinAPIError>)->Void){
            guard let url = URL(string: urlString) else {return}
            
            URLSession.shared.dataTask(with: url){ data, response, error in
                            
                if let error = error {
                    completion(.failure(.unknownError(error: error)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else{
                    completion(.failure(.requestFailed(description: "Request failed")))
                    return
                    
                }
                
                guard httpResponse.statusCode == 200 else{
                    completion(.failure(.invalidStatusCode(statusCode: httpResponse.statusCode)))
                    return
                }

                guard let data = data else {
                    completion(.failure(.invalidData))
                    return
                }
                
                do{
                    let coins = try JSONDecoder().decode([Coin].self, from: data)
                    completion(.success(coins))
                }catch{
                    print("Failed to decode with error \(error)")
                    completion(.failure(.jsonParsingFailure))
                }
                
                guard let coins = try? JSONDecoder().decode([Coin].self, from: data) else {
                    print("Failed to decode coins")
                    return
                }
                
            }.resume()
        }
        
        
        func fetchCoinPrice(coin:String, completion:@escaping (Double) -> Void){
            let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=\(coin)&vs_currencies=usd"
            guard let url = URL(string: urlString) else {return}
            
            URLSession.shared.dataTask(with: url){data, response, error in
                if let error = error{
                    print("failed with error \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else{ return}
                
                guard httpResponse.statusCode == 200 else{
                    return
                }
                
                guard let data = data else {return}
                
                guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else{ return }
                
                guard let value = jsonObject[coin] as? [String: Double] else {
                    print("Failed to pass value")
                    return
                }
                guard let price = value["usd"] else {return}
                completion(price)
                
            }.resume()
        }
    }

