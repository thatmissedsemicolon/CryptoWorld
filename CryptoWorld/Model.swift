//
//  Model.swift
//  CryptoWorld
//
//  Created by Sury on 10/22/24.
//

struct Crypto: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let symbol: String
    let rank: Int
    let priceUsd: Double?

    enum CodingKeys: String, CodingKey {
        case id, name, symbol, rank, quotes
    }

    enum QuotesKeys: String, CodingKey {
        case usd = "USD"
    }

    enum USDKeys: String, CodingKey {
        case price
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        symbol = try container.decode(String.self, forKey: .symbol)
        rank = try container.decode(Int.self, forKey: .rank)

        let quotesContainer = try? container.nestedContainer(keyedBy: QuotesKeys.self, forKey: .quotes)
        let usdContainer = try? quotesContainer?.nestedContainer(keyedBy: USDKeys.self, forKey: .usd)
        priceUsd = try? usdContainer?.decode(Double.self, forKey: .price)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(symbol, forKey: .symbol)
        try container.encode(rank, forKey: .rank)

        var quotesContainer = container.nestedContainer(keyedBy: QuotesKeys.self, forKey: .quotes)
        var usdContainer = quotesContainer.nestedContainer(keyedBy: USDKeys.self, forKey: .usd)
        try usdContainer.encode(priceUsd, forKey: .price)
    }

    static func == (lhs: Crypto, rhs: Crypto) -> Bool {
        lhs.id == rhs.id
    }
}
