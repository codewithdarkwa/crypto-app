//
//  CoinDataService.swift
//  networking
//
//  Created by Darkwa John on 29/10/2023.
//

import Foundation

class CoinDataService{
    
    
//    func fetchCoins()
    
    
    
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
            
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else{return}
            
            guard let value = jsonObject[coin] as? [String: Double] else {
                print("Failed to pass value")
                return
            }
            guard let price = value["usd"] else {return}
            completion(price)
            
        }
    }
}
