//
//  NetworkManager.swift
//  CryptoWorld
//
//  Created by Sury on 10/22/24.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()

    public func fetchCryptos() async throws -> [Crypto] {
        guard let url = URL(string: "https://api.coinpaprika.com/v1/tickers?limit=100") else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Crypto].self, from: data)
    }
}
