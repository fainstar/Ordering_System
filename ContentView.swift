//
//  ContentView.swift
//  Ordering_System
//
//  Created by 蔡尚儒 on 2024/10/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // 點餐系統首頁 Icon 和 Title
                Image(systemName: "studentdesk")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                
                Text("點餐系統APP")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 30)

                // 兩列佈局的按鈕
                HStack() {
                    NavigationLink(destination: OrderingView()) {
                        ButtonView(buttonText: "我要點餐", color: .blue,backgroundColor: .gray,image:"figure.fall")
                    }
                    NavigationLink(destination: OrderHistoryView()) {
                        ButtonView(buttonText: "點餐紀錄", color: .green,backgroundColor: .gray,image:"folder.fill")
                    }
                }

                HStack() {
                    NavigationLink(destination: DesignTeamView()) {
                        ButtonView(buttonText: "設計團隊", color: .orange,backgroundColor: .gray,image:"person.2.fill")
                    }
                    NavigationLink(destination: CH1View()) {
                        ButtonView(buttonText: "關於系統", color: .purple,backgroundColor: .gray,image:"info.bubble.fill")
                    }
                }
            }
        }
    }
}


// 以下是不同頁面的佔位 View，可以根據實際需求自訂內容
struct OrderHistoryView: View {
    var body: some View {
        Text("這是點餐紀錄頁面")
            .font(.largeTitle)
            .padding()
    }
}

struct DesignTeamView: View {
    var body: some View {
        Text("這是設計團隊頁面")
            .font(.largeTitle)
            .padding()
    }
}

struct AboutSystemView: View {
    var body: some View {
        Text("這是關於系統頁面")
            .font(.largeTitle)
            .padding()
    }
}

#Preview {
    ContentView()
}
