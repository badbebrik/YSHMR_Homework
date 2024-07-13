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
    @State private var sortOption: SortOption = .byCreationDate
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Выполнено — \(viewModel.items.filter { $0.isCompleted }.count)")
                        .foregroundColor(.secondary)
                    Spacer()
                    Menu {
                        Section(header: Text("Скрыть/показать выполненные")) {
                            Button(action: {
                                showCompleted.toggle()
                            }, label: {
                                Text(showCompleted ? "Скрыть" : "Показать")
                            })
                        }
                        Section(header: Text("Сортировка")) {
                            Button(action: {
                                sortOption = .byCreationDate
                            }, label: {
                                Text("По добавлению")
                            })
                            
                            Button(action: {
                                sortOption = .byPriority
                            }, label: {
                                Text("По важности")
                            })
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
                
                List {
                    ForEach(filteredAndSortedItems) { item in
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
                                    hexColor: item.hexColor,
                                    category: item.category
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
                    
                    NewTodoRow {
                        showingCreationDetail = true
                    }
                    .listRowInsets(EdgeInsets())
                }
                .listStyle(DefaultListStyle())
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button(action: {
                            showingCreationDetail = true
                        }, label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.blue)
                        })
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text("Мои дела")
                            .font(.title)
                            .bold()
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            CalendarViewWrapper()
                                .navigationTitle("Мои дела")
                                .toolbarRole(.editor)
                                .onDisappear {
                                    viewModel.loadItems()
                                }
                        } label: {
                            Image(systemName: "calendar")
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadItems()
            print("Hello")
        }
        .sheet(isPresented: $showingCreationDetail) {
            TodoDetailView(
                viewModel: TodoDetailViewModel(
                    todoItem: nil,
                    listViewModel: viewModel
                ),
                isShowed: $showingCreationDetail
            )
        }
        .sheet(isPresented: $showingEditorDetail) {
            if let selectedTodo = selectedTodo {
                TodoDetailView(
                    viewModel: TodoDetailViewModel(
                        todoItem: selectedTodo,
                        listViewModel: viewModel
                    ),
                    isShowed: $showingEditorDetail
                )
            }
        }
    }
    
    private var filteredAndSortedItems: [TodoItem] {
        let filteredItems = viewModel.items.filter { !showCompleted ? !$0.isCompleted : true }
        switch sortOption {
        case .byCreationDate:
            return filteredItems.sorted { $0.creationDate < $1.creationDate }
        case .byPriority:
            return filteredItems.sorted { $0.priority > $1.priority }
        }
    }
    
    enum SortOption {
        case byCreationDate, byPriority
    }
}

struct NewTodoRow: View {
    let onCreate: () -> Void
    
    var body: some View {
        HStack {
            Text("Новое")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .padding(.leading, 60)
            
            Spacer()
        }
        .padding(.vertical, 4)
        .frame(height: 50)
        .onTapGesture {
            onCreate()
        }
    }
}

#Preview {
    TodoListView()
}
