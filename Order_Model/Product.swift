//
//  Product.swift
//  Ordering_System
//
//  Created by 蔡尚儒 on 2024/10/23.
//

// Product.swift
import Foundation

struct Product: Identifiable {
    let id = UUID() // 唯一標識符
    let name: String // 產品名稱
    let image: String // 圖片名稱
    var quantity: Int // 數量
    let price: Int // 價格
}
