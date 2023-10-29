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
        Text("\(viewModel.coin) : \(viewModel.price)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
