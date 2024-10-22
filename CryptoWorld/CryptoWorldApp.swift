//
//  CryptoWorldApp.swift
//  CryptoWorld
//
//  Created by Sury on 10/22/24.
//

import SwiftUI

@main
struct CryptoWorldApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @State private var showSplash = false
    @State private var firstLaunch = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()

                if showSplash {
                    SplashView()
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.5), value: showSplash)
                }
            }
            .onChange(of: scenePhase) { oldPhase, newPhase in
                handleScenePhaseChange(from: oldPhase, to: newPhase)
            }
            .onAppear {
                showSplashScreen(delay: firstLaunch)
            }
        }
    }

    private func handleScenePhaseChange(from oldPhase: ScenePhase?, to newPhase: ScenePhase) {
        switch newPhase {
        case .inactive:
            showSplash = true
        case .active:
            if !firstLaunch {
                showSplashScreen(delay: false)
            }
        default:
            break
        }
    }

    private func showSplashScreen(delay: Bool) {
        showSplash = true

        if delay {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showSplash = false
                    firstLaunch = false
                }
            }
        } else {
            withAnimation {
                showSplash = false
            }
        }
    }
}

struct SplashView: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()

            VStack {
                Text("Crypto")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(progressViewTintColor)
                    .padding()
            }
        }
    }

    private var backgroundColor: Color {
        colorScheme == .dark ? .black : .white
    }

    private var progressViewTintColor: Color {
        colorScheme == .dark ? .white : .black
    }
}
