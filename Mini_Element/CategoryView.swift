//
//  CategoryView.swift
//  Ordering_System
//
//  Created by 蔡尚儒 on 2024/10/23.
//
import SwiftUI

struct CategoryView: View {
    var title: String
    @Binding var products: [Product]
    @Binding var quantities: [Int]
    
    @State private var isImageExpanded = false // 控制圖片是否放大

    var body: some View {
        VStack {
            List {
                ForEach(products.indices, id: \.self) { index in
                    HStack {
                        // 顯示產品圖片
                        AsyncImage(url: URL(string: "https://d3l76hx23vw40a.cloudfront.net/recipe/webp/whk104-047a.webp")) { phase in
                            switch phase {
                            case .empty:
                                ProgressView() // 顯示進度條
                            case .success(let image):
                                image
                                    .resizable() // 使圖片可調整大小
                                    .scaledToFit() // 等比縮放
                                    .frame(width: isImageExpanded ? 150 : 50, height: isImageExpanded ? 150 : 50) // 根據狀態調整大小
                                    .padding() // 添加內邊距
                                    .onLongPressGesture {
                                        // 長按手勢
                                        withAnimation {
                                            isImageExpanded.toggle() // 切換放大狀態
                                        }
                                    }
                            case .failure:
                                Image(systemName: "exclamationmark.triangle") // 顯示錯誤圖標
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .padding()
                            @unknown default:
                                EmptyView() // 處理未知情況
                            }
                        }

                        VStack(alignment: .leading) {
                            Text(products[index].name)
                                .font(.title2)
                        }
                        Spacer()
                        // 顯示產品數量，並靠右對齊
                        Text("\(products[index].quantity)") // 將數量包裝為字符串
                            .font(.largeTitle) // 調整字體大小為較大
                            .padding(10) // 增加內邊距
                            .background(Color.yellow.opacity(0.3)) // 設定底色（透明的黃色）
                            .cornerRadius(5) // 增加圓角
                        
                        // 將按鈕包裝在一個 VStack 中，以便更好地控制佈局
                        VStack {
                            Button(action: {
                                // 增加數量
                                products[index].quantity += 1
                                quantities[index] += 1 // 更新數量到量數組
                                print("\(products[index].name) 增加到: \(products[index].quantity)") // Debug print
                            }) {
                                Text("+")
                                    .padding(8)
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                            }
                            .buttonStyle(PlainButtonStyle()) // 使用平面按鈕樣式，避免整個行觸發
                            .frame(width: 40) // 固定寬度

                            Button(action: {
                                // 減少數量，防止數量低於0
                                if products[index].quantity > 0 {
                                    products[index].quantity -= 1
                                    quantities[index] -= 1 // 更新數量到量數組
                                    print("\(products[index].name) 減少到: \(products[index].quantity)") // Debug print
                                }
                            }) {
                                Text("-")
                                    .padding(8)
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                            }
                            .buttonStyle(PlainButtonStyle()) // 使用平面按鈕樣式，避免整個行觸發
                            .frame(width: 40) // 固定寬度
                        }
                    }
                }
            }
            .listStyle(PlainListStyle()) // 使用純淨列表樣式
        }
    }
}
