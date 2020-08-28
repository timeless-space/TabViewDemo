//
//  ContentView.swift
//  TabViewDemo
//
//  Created by Lucas Wilkinson on 8/28/20.
//  Copyright © 2020 Timeless Space. All rights reserved.
//

import SwiftUI
import Introspect


extension ContentView {
    enum Tab: Int {
        case home = 0
        case agenda
        case feed
        case create
    }

    class ViewModel: ObservableObject {
        @Published var activeTab: Tab = .home
    }
}

struct ContentView: View {
    // ASSUMPTION: Assumes there will only ever be one main view
    //   we make this static so it doesn't get re-initialized with
    //   the parent view
    static var tabBarEnvironmentStatic = TabBarEnvironment()

    @ObservedObject var tabBarEnvironment = tabBarEnvironmentStatic
    @ObservedObject var viewModel = ViewModel()

    var body: some View {
        TabView(selection: $viewModel.activeTab) {
            Group {
                VStack {
                    Text("Today")
                    Button(action: { self.tabBarEnvironment.hideTabBar() }) {
                        Text("Hide TabBar")
                    }
                    Button(action: { self.tabBarEnvironment.showTabBar() }) {
                        Text("Show TabBar")
                    }
                }
                    .tabItem {
                        Image("tab_bar_home0_icon").renderingMode(.template)
                        Text("Today")
                    }
                    .tag(Tab.home)

                Text("Calendar")
                    .tabItem {
                        Image("tab_bar_agenda_icon").renderingMode(.template)
                        Text("Calendar")
                    }
                    .tag(Tab.agenda)

                Text("Feed")
                    .tabItem {
                        Image("tab_bar_feed_icon").renderingMode(.template)
                        Text("Feed")
                    }
                    .tag(Tab.feed)

                Text("Create")
                    .tabItem {
                        Image("tab_bar_create_icon").renderingMode(.template)
                        Text("Create")
                    }
                    .tag(Tab.create)
            }
            .edgesIgnoringSafeArea([.top, .bottom])
        }
        .introspectTabBarController { tabBarController in
            let tabBar = tabBarController.tabBar
            if tabBar.isHidden != !(self.tabBarEnvironment.visible) {
                if self.tabBarEnvironment.visible {
                    tabBar.isUserInteractionEnabled = true
                    tabBar.isHidden = false

                    // Swift UI will reset this offset every time the view is refreshed so we have to
                    //   make sure this always animates in from the bottom so we force the frame down
                    //   then perform the animation
                    tabBar.frame.origin.y = UIScreen.main.bounds.height
                    UIView.animate(withDuration: 0.3) {
                        tabBar.frame.origin.y = UIScreen.main.bounds.height - tabBar.frame.height
                    }
                } else {
                    tabBar.isUserInteractionEnabled = false
                    UIView.animate(withDuration: 0.3, animations: {
                        tabBar.frame.origin.y = UIScreen.main.bounds.height
                    }) { didComplete in
                        // We need to hide this since if the view refreshes then the frame will get
                        //  reset and the tabBar will pop back in if it is not hidden
                        tabBar.isHidden = didComplete
                        tabBar.isUserInteractionEnabled = !didComplete
                    }
                }
            }
        }
        .environmentObject(tabBarEnvironment)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
