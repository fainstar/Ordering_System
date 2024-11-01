//
//  OrderingViewModel.swift
//  Ordering_System
//
//  Created by 蔡尚儒 on 2024/10/23.
//

import SwiftUI
import Foundation

class OrderingViewModel: ObservableObject {
    @Published var selectedCategory = 0
    @Published var products: [Product] = []
    @Published var quantities: [[Int]] = Array(repeating: Array(repeating: 0, count: 3), count: 3)
    
    let categories = ["蛋餅類", "鍋燒類", "總匯類"]

    // 根據類別返回相應的產品
    func products(for categoryIndex: Int) -> [Product] {
        switch categoryIndex {
        case 0:
            return [
                Product(name: "原味蛋餅", image: "https://www.macc.com.tw/data/goods/gallery/202111/1637313718335422967.jpg", quantity: 0, price: 30),
                                Product(name: "蔬菜蛋餅", image: "https://d3l76hx23vw40a.cloudfront.net/recipe/aa007-042a.jpg", quantity: 0, price: 30),
                                Product(name: "玉米蛋餅", image: "https://www.macc.com.tw/data/goods/gallery/202111/1637313752147218648.jpg", quantity: 0, price: 30)
                            ]
                        case 1:
                            return [
                                Product(name: "鍋 燒 粥", image:  "https://d1ralsognjng37.cloudfront.net/f225c79e-d16d-4b04-a2d9-69f73321174c.jpeg", quantity: 0, price: 40),
                                Product(name: "鍋燒意麵", image: "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEi88Qx9PG3oUFkBns4XSGKAGvXrAI28ecSIH7r5lBUSBXKNL9JfiGmK6GrRV36YEnajCAXP0q65DRqUGo5syv0z0_y3wBmpYmzpt7PXlg07Rg0J_346So1zZGclGukklww3APCTiSfUw-5E88qvWtXlEI7tlymbpgUWLJkAqKiE3kVOuGHTEU6FpNlsgQ/s1600/00-1.jpg", quantity: 0, price: 50),
                                Product(name: "鍋燒雞絲", image:"https://cdn-ak.f.st-hatena.com/images/fotolife/y/yasumarutaiwan/20211216/20211216155458.jpg", quantity: 0, price: 50)
                            ]
                        case 2:
                            return [
                                Product(name: "豬肉總匯", image: "https://www.hongya88.com.tw/Content/Upload/Picture/Food/浮水印/0弘爺漢堡早餐菜單-招牌總匯-大.png", quantity: 0, price: 60),
                                Product(name: "雞肉總匯", image: "https://d3l76hx23vw40a.cloudfront.net/recipe/webp/bk44-035a.webp", quantity: 0, price: 70),
                                Product(name: "里肌總匯", image: "https://i.imgur.com/WifJsHK.jpeg", quantity: 0, price: 80)
            ]
        default:
            return []
        }
    }

    // 計算總價格（包含所有類別的產品）
    func totalPrice() -> Int {
        var total = 0
        for categoryQuantities in quantities {
            for (index, quantity) in categoryQuantities.enumerated() {
                if index < products.count {
                    total += quantity * products[index].price
                }
            }
        }
        return total
    }

    // 生成包含所有類別的訂單明細字串
    func orderDetails() -> String {
        var details = "" // 訂單框的標題
        details += "|----------------------------------|\n" // 上邊框
        for (categoryIndex, categoryQuantities) in quantities.enumerated() {
            for (index, quantity) in categoryQuantities.enumerated() {
                if quantity > 0 {
                    let product = products(for: categoryIndex)[index]
                    
                    // 對產品名稱進行處理，確保對齊
                    let productName = product.name.padding(toLength: 20, withPad: " ", startingAt: 0)
                    let quantityStr = String(format: "%2d", quantity)
                    let price = quantity * product.price
                    
                    // 設定最大寬度以對齊價格和「元」
                    let priceStr = String(format: "%4d", price).padding(toLength: 5, withPad: " ", startingAt: 0)
                    
                    // 確保「元」字固定在第 8 個字符位置
                    let line = "| \(productName)  x \(quantityStr)  = \(priceStr)元   |\n"
                    details += line
                }
            }
        }
        details += "|-----------------------------------|" // 下邊框
        return details
    }




    // 重置訂單
    func resetOrder() {
        for categoryIndex in quantities.indices {
            for productIndex in quantities[categoryIndex].indices {
                quantities[categoryIndex][productIndex] = 0
            }
        }
        products = self.products(for: selectedCategory)
    }
}
