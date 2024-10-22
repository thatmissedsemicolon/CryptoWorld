//
//  CryptoViewModel.swift
//  CryptoWorld
//
//  Created by Sury on 10/22/24.
//

import SwiftUI

@MainActor
class CryptoViewModel: ObservableObject {
    @Published private(set) var cryptos: [Crypto] = []
    @Published private(set) var isLoading = false
    @Published private(set) var isRefreshing = false
    @Published var errorMessage: String?

    public func loadCryptos(isRefresh: Bool = false) async {
        guard isRefresh ? !isRefreshing : !isLoading else { return }
        
        if isRefresh {
            isRefreshing = true
        } else {
            isLoading = true
        }

        defer {
            if isRefresh {
                isRefreshing = false
            } else {
                isLoading = false
            }
        }

        do {
            let newCryptos = try await NetworkManager.shared.fetchCryptos()
            if newCryptos != cryptos {
                cryptos = newCryptos
            }
        } catch {
            errorMessage = "Failed to load data. Please try again."
        }
    }

    public func refreshData() async {
        await loadCryptos(isRefresh: true)
    }
}
