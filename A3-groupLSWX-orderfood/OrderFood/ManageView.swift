//
//  ManageView.swift
//  OrderFood
//
//  Created by Lin on 2022/5/15.
//

import SwiftUI

struct ManageView: View {
    @EnvironmentObject var userSetting: UserSetting
    
    @State var allDishes: [SingleDishInMenu] = []
    @State var showDishInformationView: Bool = false
    @State var editDish: SingleDishInMenu = SingleDishInMenu()
    var body: some View {
        ZStack {
            VStack{
                HStack{
                    Spacer()
                    
                    Button {
                        editDish = SingleDishInMenu()
                        showDishInformationView = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                    
                }
                .padding(5)
                
                ScrollView{
                    ForEach(0..<allDishes.count, id: \.self){ index in
                        SingleDishView(
                            dish: allDishes[index],
                            editDish: $editDish,
                            showDishInformationView: $showDishInformationView,
                            funcDelete: deleteDish
                        )
                    }
                    
                }
                .padding(10)
                
                Spacer()
            }
            
            NavigationLink(isActive: $showDishInformationView) {
                DishInformationView(
                    singleDish: editDish,
                    showDishInformationView: $showDishInformationView
                )
            } label: {
                
            }

            
        }
        .navigationTitle("Manage")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear{
            updateDishes()
        }
        
        
    }
    
    func updateDishes() {
        allDishes = userSetting.sqlOperation.searchMenu()
    }
    
    func deleteDish(dishId: Int) {
        userSetting.sqlOperation.deleteDish(
            ids: [dishId]
        )
        updateDishes()
    }
}

private struct SingleDishView: View{
    @State var showActionSheet: Bool = false
    
    var dish: SingleDishInMenu
    @Binding var editDish: SingleDishInMenu
    @Binding var showDishInformationView: Bool
    
    var funcDelete: (Int) -> Void
    
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
                    if (!dish.imageName.isEmpty) {
                        Image(dish.imageName)
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    Text(dish.name)
                    Spacer()
                    Text(String(format: "$%.2f", dish.price))
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
        .confirmationDialog("", isPresented: $showActionSheet, titleVisibility: .hidden) {
            
            Button {
                editDish = dish
                showDishInformationView = true
            } label: {
                Text("Edit")
            }

            Button{
                funcDelete(dish.dishId)
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
