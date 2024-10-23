
import SwiftUI

struct OrderingView: View {
    @StateObject private var viewModel = OrderingViewModel()
    
    @State private var userName: String = ""
    @State private var userPhone: String = ""

    @State private var showingEditNameAlert = false
    @State private var showingEditPhoneAlert = false
    @State private var newUserName: String = ""
    @State private var newUserPhone: String = ""
    
    @State private var showingErrorAlert = false
    @State private var errorMessage: String = ""
    @State private var isOrderDetailViewActive = false // 控制是否顯示 OrderDetailView
    
    var body: some View {
        VStack {
            // 用戶資料顯示
            HStack {
                HStack {
                    Text("姓名:")
                        .font(.headline)
                    TextField("請輸入姓名", text: $userName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Spacer()
                }
                
                HStack {
                    Text("電話:")
                        .font(.subheadline)
                    TextField("請輸入電話", text: $userPhone)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Spacer()
                }
            }
            .padding(.horizontal, 10)
            
            // 類別選擇列
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(viewModel.categories.indices, id: \.self) { index in
                        Text(viewModel.categories[index])
                            .font(.title2)
                            .padding()
                            .background(viewModel.selectedCategory == index ? Color.blue : Color.gray)
                            .foregroundColor(Color.white)
                            .cornerRadius(10)
                            .onTapGesture {
                                viewModel.selectedCategory = index
                                viewModel.products = viewModel.products(for: viewModel.selectedCategory)
                                print("Selected Category: \(viewModel.categories[viewModel.selectedCategory])")
                            }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            
            // 顯示所選類別的產品
            CategoryView(title: viewModel.categories[viewModel.selectedCategory], products: $viewModel.products, quantities: $viewModel.quantities[viewModel.selectedCategory])
                .padding(.top)

            // 新增結帳和取消按鈕
            HStack(spacing: 20) {
                NavigationLink(destination: OrderDetailView(orderDetail: viewModel.orderDetails(), totalPrice: viewModel.totalPrice(),customerName: userName), isActive: $isOrderDetailViewActive) {
                    EmptyView() // 使用 EmptyView 作為 NavigationLink 目標
                }
                
                Button(action: {
                    // 結帳前檢查姓名和電話
                    if userName.isEmpty {
                        errorMessage = "請輸入姓名"
                        showingErrorAlert = true
                    } else if userPhone.isEmpty {
                        errorMessage = "請輸入電話"
                        showingErrorAlert = true
                    } else {
                        // 檢查成功後導向 OrderDetailView
                        isOrderDetailViewActive = true
                    }
                }) {
                    Text("結帳")
                        .font(.headline)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Spacer()
                Button(action: {
                    viewModel.resetOrder()
                }) {
                    Text("取消")
                        .font(.headline)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle("點餐菜單")
        .onAppear {
            viewModel.products = viewModel.products(for: viewModel.selectedCategory)
            print("Initialized Products: \(viewModel.products)")
        }
        .alert("編輯姓名", isPresented: $showingEditNameAlert) {
            TextField("請輸入新姓名", text: $newUserName)
            Button("確定") {
                userName = newUserName
            }
            Button("取消", role: .cancel) { }
        }
        .alert("編輯電話", isPresented: $showingEditPhoneAlert) {
            TextField("請輸入新電話", text: $newUserPhone)
            Button("確定") {
                userPhone = newUserPhone
            }
            Button("取消", role: .cancel) { }
        }
        .alert(isPresented: $showingErrorAlert) {
            Alert(title: Text("錯誤"), message: Text(errorMessage), dismissButton: .default(Text("確定")))
        }
    }
}

struct OrderingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OrderingView()
        }
    }
}

