//
//  ContentView.swift
//  CryptoWorld
//
//  Created by Sury on 10/22/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CryptoViewModel()
    @State private var searchText = ""
    @State private var isSearchBarHidden = false
    @State private var isScrolled = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    if !isSearchBarHidden {
                        SearchBar(text: $searchText)
                            .padding(.top, 20)
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .animation(.easeInOut(duration: 0.3), value: isSearchBarHidden)
                    }

                    LazyVStack(spacing: 16) {
                        if viewModel.isLoading && viewModel.cryptos.isEmpty {
                            ProgressView("Loading...")
                                .transition(.opacity)
                        } else {
                            ForEach(Array(filteredCryptos.enumerated()), id: \.element.id) { index, crypto in
                                CryptoCardView(crypto: crypto)
                                    .transition(.move(edge: .bottom).combined(with: .opacity))
                                    .animation(.easeInOut(duration: 0.5).delay(Double(index) * 0.05), value: crypto.id)
                            }
                        }
                        if viewModel.isLoading && !viewModel.cryptos.isEmpty {
                            ProgressView("Refreshing...")
                                .padding()
                        }
                    }
                    .padding()
                }
                .background(
                    GeometryReader { geo -> Color in
                        let offsetY = geo.frame(in: .global).minY
                        DispatchQueue.main.async {
                            withAnimation {
                                isSearchBarHidden = offsetY < -50
                                isScrolled = offsetY < -100
                            }
                        }
                        return Color.clear
                    }
                )
            }
            .navigationTitle("Crypto")
            .navigationBarTitleDisplayMode(isScrolled ? .inline : .large)
            .onAppear {
                Task {
                    await viewModel.loadCryptos()
                }
            }
            .refreshable {
                Task {
                    await viewModel.refreshData()
                }
            }
        }
    }

    private var filteredCryptos: [Crypto] {
        if searchText.isEmpty {
            return viewModel.cryptos
        } else {
            return viewModel.cryptos.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.symbol.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

struct CryptoCardView: View {
    let crypto: Crypto

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: "https://static.coinpaprika.com/coin/\(crypto.id)/logo.png")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image.resizable().scaledToFit()
                case .failure:
                    Image(systemName: "photo").resizable().scaledToFit().foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            .padding(.trailing, 8)

            VStack(alignment: .leading, spacing: 4) {
                Text("\(crypto.rank). \(crypto.name) (\(crypto.symbol))")
                    .font(.headline)
                if let price = crypto.priceUsd {
                    Text("Price: $\(price, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                } else {
                    Text("Price: N/A")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
            }
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

#Preview {
    ContentView()
}
