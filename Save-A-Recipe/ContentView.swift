//
//  ContentView.swift
//  Save-A-Recipe
//
//  Created by Henrik Sjögren on 2022-02-08.
//

import SwiftUI
import Firebase
import SDWebImage
import SDWebImageSwiftUI

struct ContentView: View {
    @EnvironmentObject var cookBook : CookBook
    
    @State var showInfo : Bool = false
    
    
    
    
    var db = Firestore.firestore()
    var uid = Auth.auth().currentUser?.uid
    @ObservedObject private var viewModel = RecipeViewModel()
    
    var body: some View {
        NavigationView{
            VStack {
                Button(action: {viewModel.logout(); print(uid)}, label: {Image(systemName: "rectangle.portrait.and.arrow.right")})
                List(){
                    ForEach(viewModel.recipes) { recipe in
                        NavigationLink(destination: RecipeView(recipe: recipe)) {
                            RowView(recipe: recipe)
                        }
                    }
                    .onDelete() { indexSet in
                            
                                        for index in indexSet {
                                            let recipe = viewModel.recipes[index]
                                            if let id = recipe.id {
                                                if let uid = uid {
                                               // db.collection("recipes").document(id).delete()
                                                db.collection("user").document(uid).collection("recipes").document(id).delete()
                                            }
                                            }
                                        }
                                    }
                }
                .navigationTitle("Recipes")
                .onAppear() {
                    self.viewModel.fetchData()
                }
                .navigationBarItems(leading: NavigationLink(destination: AddRecipeView(newRecipeIngredients: [], newHowToCookSteps: [])){
                    Image(systemName: "plus")
                })
                .navigationBarItems(trailing: NavigationLink(destination: ShoppingCartView()){
                    Image(systemName: "cart")
                })
            }
        }.navigationViewStyle(.stack)
    }
}

struct RowView : View {
    var recipe : Recipe
    
    var body: some View {
        
        ZStack(alignment: .top){
            WebImage(url: URL(string: recipe.image))
                .resizable()
                .aspectRatio(contentMode: .fit)
            //.frame(maxWidth: 40)
            Text(recipe.name)
                .font(.largeTitle)
                .background(Color.black)
                .opacity(0.6)
                .cornerRadius(4)
                .foregroundColor(Color.white)
                .multilineTextAlignment(.center)
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

