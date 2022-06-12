//
//  ContentView.swift
//  iExpense
//
//  Created by Jan Andrzejewski on 11/06/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var expenses = Expenses()
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items, id: \.name) { item in
                    Text(item.name)
                }
            }
            .navigationTitle("iExpense")
        }
    }
}

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]()
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
