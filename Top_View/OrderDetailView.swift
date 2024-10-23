import SwiftUI

struct OrderDetailView: View {
    var orderDetail: String
    var totalPrice: Int

    var discountedPrice: Int {
        return totalPrice > 100 ? Int(Double(totalPrice) * 0.9) : totalPrice
    }
    
    var discountMessage: String {
        return totalPrice > 100 ? "您享有 10% 的折扣！" : ""
    }

    var body: some View {
        VStack {
            ScrollView {
                Text(orderDetail)
                    .font(.body)
                    .padding()
            }

            Spacer()

            Text("總金額: \(totalPrice) 元")
                .font(.title)
                .padding()
            
            if totalPrice > 100 {
                Text("折後金額: \(discountedPrice) 元")
                    .font(.title)
                    .foregroundColor(.green)
                    .padding(.bottom)
                Text(discountMessage)
                    .font(.title)
                    .foregroundColor(.blue)
                    .padding(.bottom)
            }

            Button(action: {
                // 在這裡可以加入完成訂單的邏輯，例如發送訂單到伺服器
                print("完成訂單")
            }) {
                Text("送出訂單")
                    .font(.headline)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("訂單明細")
    }
}

struct OrderDetailView_Previews: PreviewProvider {
    static var previews: some View {
        OrderDetailView(orderDetail: "範例訂單明細", totalPrice: 120) // 示例總金額超過100以測試折扣
    }
}
