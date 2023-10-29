//
//  CoinDataService.swift
//  networking
//
//  Created by Darkwa John on 29/10/2023.
//

import Foundation

class CoinDataService{
    
    private let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&page=1&sparkline=false&locale=en"
    func fetchCoins(){
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url){ data, response, error in
                        
            guard let data = data else {return}
            
            guard let coins = try? JSONDecoder().decode([Coin].self, from: data) else {
                print("Failed to decode coins")
                return
            }
            for coin in coins {
                print("Coin id \(coin.id)")
            }
            print("coins decoded \(coins)")
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
