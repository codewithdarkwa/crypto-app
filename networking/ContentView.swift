//
//  ContentView.swift
//  networking
//
//  Created by Darkwa John on 29/10/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = CoinViewModel()
    var body: some View {
        List{
            ForEach(viewModel.coins){ coin in
                HStack(spacing: 12){
                    Text("\(coin.marketCapRank)")
                        .foregroundColor(.gray)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(coin.name)
                        Text(coin.symbol.uppercased())
                    }
                }
            }
        }
        .overlay{
            if let error = viewModel.errorMessage {
                Text(error)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
