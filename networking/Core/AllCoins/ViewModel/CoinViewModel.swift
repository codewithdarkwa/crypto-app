//
//  CoinViewModel.swift
//  networking
//
//  Created by Darkwa John on 29/10/2023.
//

import Foundation


class CoinViewModel: ObservableObject {
    
//    @Published var coin = ""
//    @Published var price = ""
    @Published var coins = [Coin]()
    
    private let service = CoinDataService()
    
    init(){
        fetchCoins()
    }
    
    func fetchCoins(){
        service.fetchCoins { coins in
            DispatchQueue.main.async {
                self.coins = coins
            }
            
        }
    }
    
//    func fetchCoinPrice(coin: String) {
//        service.fetchCoinPrice(coin: coin) { priceFromService in
//            DispatchQueue.main.async {
//                self.coin = coin
//                self.price = "$\(priceFromService)"
//            }
//        }
//    }
    
}
