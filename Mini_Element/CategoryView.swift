//
//  CategoryView.swift
//  Ordering_System
//
//  Created by 蔡尚儒 on 2024/10/23.
import SwiftUI

struct CategoryView: View {
    var title: String
    @Binding var products: [Product]
    @Binding var quantities: [Int]
    
    @State private var isImageExpanded: Set<Int> = [] // 控制每個產品的圖片是否放大

    var body: some View {
        VStack {
            List {
                ForEach(products.indices, id: \.self) { index in
                    HStack {
                        // 顯示產品圖片
                        AsyncImage(url: URL(string: products[index].image)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView() // 顯示進度條
                            case .success(let image):
                                image
                                    .resizable() // 使圖片可調整大小
                                    .scaledToFit() // 等比縮放
                                    .frame(width: isImageExpanded.contains(index) ? 150 : 50, height: isImageExpanded.contains(index) ? 150 : 50) // 根據狀態調整大小
                                    .padding() // 添加內邊距
                                    .onLongPressGesture {
                                        // 長按手勢
                                        withAnimation {
                                            if isImageExpanded.contains(index) {
                                                isImageExpanded.remove(index) // 取消放大
                                            } else {
                                                isImageExpanded.insert(index) // 放大
                                            }
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

                        // 勾選框，根據產品的數量判斷是否勾選
                        Toggle(isOn: Binding(
                            get: { quantities[index] > 0 },
                            set: { isSelected in
                                if isSelected {
                                    // 當選擇時，設置數量為1
                                    products[index].quantity = 1
                                    quantities[index] = 1
                                } else {
                                    // 取消選擇時，數量設為0
                                    products[index].quantity = 0
                                    quantities[index] = 0
                                }
                            }
                        )) {
                            Text("") // 勾選框不顯示標題
                        }
                        .toggleStyle(CheckBoxToggleStyle()) // 自定義勾選框樣式
                        
                        // 顯示產品數量
                        Text("\(products[index].quantity)") // 將數量包裝為字符串
                            .font(.largeTitle) // 調整字體大小為較大
                            .padding(10) // 增加內邊距
                            .background(Color.yellow.opacity(0.3)) // 設定底色（透明的黃色）
                            .cornerRadius(5) // 增加圓角

                        // 數量調整按鈕
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

// 自定義的勾選框樣式
struct CheckBoxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Button(action: {
                configuration.isOn.toggle()
            }) {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(configuration.isOn ? .blue : .gray)
            }
        }
        .padding()
    }
}
