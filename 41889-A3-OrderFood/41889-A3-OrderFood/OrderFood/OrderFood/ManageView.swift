//
//  ManageView.swift
//  OrderFood
//
//  Created by Lin on 2022/5/15.
//

import SwiftUI

struct ManageView: View {
    @EnvironmentObject var userSetting: UserSetting

    @State var allDishes: [SingleDish] = []
    @State var pressedIndex: Int = -1
    @State var isActive: Bool = false
    
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    Text("Manage")
                        .font(.title)
                    
                    Spacer()
                }
                .padding(5)
                HStack{
                    Spacer()
                    
                    NavigationLink(isActive: $isActive) {
                        DishInformationView(singleDish: pressedIndex >= 0 ? allDishes[pressedIndex] : SingleDish(), isRootActive: $isActive)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                    .onChange(of: isActive) { newValue in
                        if (!isActive) {
                            updateDishes()
                        }
                    }
                }
                .padding(5)
                
                ScrollView{
                    ForEach(0..<allDishes.count, id: \.self){ i in
                        SingleDishView(
                            index: i,
                            dish: allDishes[i],
                            pressedInded: $pressedIndex,
                            funcEdit: editDish,
                            funcDelete: deleteDish
                        )
                    }
                    
                }
                .padding(10)
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
        .onAppear{
            updateDishes()
        }

    }
    
    func updateDishes() {
        allDishes = userSetting.sqlOperation.searchMenu()
    }
    
    func editDish() {
        isActive = true
    }
    
    func deleteDish() {
        userSetting.sqlOperation.deleteDish(
            ids: [allDishes[pressedIndex].dishId]
        )
        updateDishes()
    }
}

private struct SingleDishView: View{
    var index: Int
    var dish: SingleDish
    @State var showActionSheet: Bool = false
    @Binding var pressedInded: Int
    
    var funcEdit: () -> Void
    var funcDelete: () -> Void
    
    var body: some View {
        VStack{
            ZStack{
                //To make sure 'onLongPressGesture' is triggered, if you press blank area
                Color.white.opacity(0.001)
                HStack{
                    if(dish.recommend) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                    Text(dish.name)
                    Spacer()
                    Text(String(format: "%.2f", dish.price))
                }
                
            }
            .frame(height: 50)
            //To make sure the function of scrollview is ok
            .onTapGesture {
            }
            .onLongPressGesture {
                showActionSheet = true
            }
            
            Divider()
        }
        .confirmationDialog("", isPresented: $showActionSheet,titleVisibility: .hidden) {
            Button {
                pressedInded = index
                funcEdit()
            } label: {
                Text("Edit")
            }
            Button{
                pressedInded = index
                funcDelete()
            } label: {
                Text("Delete")
            }
            
        }

    }
}

struct ManageView_Previews: PreviewProvider {
    static var previews: some View {
        ManageView().environmentObject(UserSetting.shared)
    }
}
