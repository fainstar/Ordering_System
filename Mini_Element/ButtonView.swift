//
//  ButtonView.swift
//  Ordering_System
//
//  Created by 蔡尚儒 on 2024/10/23.
//
import SwiftUI

// 自定義按鈕樣式的 View
struct ButtonView: View {
    var buttonText: String
    var color: Color
    var backgroundColor: Color // 新增底色參數
    var image: String // 新增底色參數
    var body: some View {
        ZStack {
            // 底色部分
            Rectangle()
                .fill(backgroundColor)
                .cornerRadius(15) // 使背景有圓角
                .frame(width: 180, height: 200) // 設置背景的大小

            VStack {
                // 圖片部分
                Image(systemName:image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(color)

                // 文字部分
                Text(buttonText)
                    .font(.title2)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 20)
                    .padding()
                    .background(color)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}
