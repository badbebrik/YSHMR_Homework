//
//  TodoListView.swift
//  TodoApp
//
//  Created by Виктория Серикова on 27.06.2024.
//

import SwiftUI

struct TodoListView: View {
    @StateObject private var viewModel = TodoListViewModel()
    @State private var showingCreationDetail = false
    @State private var showingEditorDetail = false
    @State private var selectedTodo: TodoItem?
    @State private var showCompleted = false
    
    var body: some View {
        NavigationStack {
            
            HStack {
                Text("Выполнено — \(viewModel.items.filter { $0.isCompleted }.count)")
                    .foregroundColor(.secondary)
                Spacer()
                Button(action: {
                    showCompleted.toggle()
                }) {
                    Text(showCompleted ? "Скрыть" : "Показать")
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            List {
                ForEach(viewModel.items.filter { !showCompleted ? !$0.isCompleted : true }.sorted { $0.creationDate < $1.creationDate }) { item in
                    TodoRow(
                        todo: item,
                        onToggleComplete: {
                            let updatedItem = TodoItem(
                                id: item.id,
                                text: item.text,
                                priority: item.priority,
                                deadline: item.deadline,
                                isCompleted: !item.isCompleted,
                                creationDate: item.creationDate,
                                modificationDate: Date(),
                                hexColor: item.hexColor
                            )
                            viewModel.updateItem(updatedItem)
                        },
                        onInfo: {
                            selectedTodo = item
                            showingEditorDetail = true
                        },
                        onDelete: {
                            viewModel.removeItem(by: item.id)
                        }
                    )
                    
                }
                .onDelete(perform: viewModel.removeItem)
            }
            .navigationTitle("Мои дела")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        showingCreationDetail = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingCreationDetail) {
                TodoDetailView(viewModel: TodoDetailViewModel(todoItem: nil, listViewModel: viewModel), isShowed: $showingCreationDetail)
            }
            .sheet(isPresented: $showingEditorDetail) {
                if let selectedTodo = selectedTodo {
                    TodoDetailView(viewModel: TodoDetailViewModel(todoItem: selectedTodo, listViewModel: viewModel), isShowed: $showingEditorDetail)
                }
            }
        }
        .onAppear() {
            viewModel.loadItems()
        }
    }
}

#Preview {
    TodoListView()
}
