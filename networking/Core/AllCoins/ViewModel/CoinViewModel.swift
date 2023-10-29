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
    @Published var errorMessage: String?
    
    private let service = CoinDataService()
    
    init(){
        Task{ try await fetchCoins()}
    }
    
    @MainActor
    func fetchCoins() async throws{
        self.coins =  try await service.fetchCoins()
    }
    
    func fetchCoinsWithCompletioinHandler(){
        
        service.fetchCoinsWithResult { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let coins):
                    self?.coins = coins
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }

            }
        }
//        service.fetchCoins { coins, error in
//            DispatchQueue.main.async {
//                if let error = error{
//                    self.errorMessage = error.localizedDescription
//                    return
//                }
//                self.coins = coins ?? []
//            }
//
//        }
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
