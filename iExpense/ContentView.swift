//
//  ContentView.swift
//  iExpense
//
//  Created by Jan Andrzejewski on 11/06/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var expenses = Expenses()
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("\(item.name), \(item.amount)")
                        .accessibilityHint(item.type)
                        
                        Spacer()
                        //Text(item.amount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                        if item.amount <= 10 {
                            Text(item.amount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                                .font(.subheadline)
                        } else if item.amount > 100 {
                            Text(item.amount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                                .font(.headline)
                        }
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button {
                    showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }
}

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }

        items = []
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
