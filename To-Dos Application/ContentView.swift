//
//  ContentView.swift
//  To-Dos Application
//
//  Created by Mustafa Helal on 2021-01-18.
//

import SwiftUI

struct TodoItem: Codable, Identifiable {
    
    var id = UUID()
    let todo: String
    
}

struct ContentView: View {
    
    @State private var newTodo = ""
    @State private var allTodos: [TodoItem] = []
    
    private func saveTodos() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(self.allTodos), forKey: "todosKey")
    }
    
    private func loadTodos() {
        if let todosData = UserDefaults.standard.value(forKey: "todosKey") as? Data {
            if let todosList = try? PropertyListDecoder().decode(Array<TodoItem>.self, from: todosData) {
                self.allTodos = todosList
            }
        }
    }
    
    private func deleteTodo(at offsets: IndexSet) {
        self.allTodos.remove(atOffsets: offsets)
        saveTodos()
    }
    
    var body: some View {
        
        NavigationView {
            VStack {
                HStack {
                    TextField("Add New Task", text: $newTodo)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        guard !self.newTodo.isEmpty else { return }
                        self.allTodos.append(TodoItem(todo: self.newTodo))
                        self.newTodo = ""
                        self.saveTodos()
                    }) {
                        Image(systemName: "plus")
                    }
                    .padding(.leading)
                }
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                List {
                    ForEach(allTodos) {
                        todoItem in Text(todoItem.todo)
                    }.onDelete(perform: deleteTodo)
                }
            }
            .navigationTitle("To Do's")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            loadTodos()
        }
        
        
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
