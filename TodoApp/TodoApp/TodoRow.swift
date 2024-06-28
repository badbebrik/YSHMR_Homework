//
//  TodoRow.swift
//  TodoApp
//
//  Created by Виктория Серикова on 28.06.2024.
//

import SwiftUI

struct TodoRow: View {
    let todo: TodoItem
    let onToggleComplete: () -> Void
    let onInfo: () -> Void
    let onDelete: () -> Void

    var body: some View {
            HStack {
                if todo.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .foregroundColor(.green)
                        .frame(width: 24, height: 24)
                        .onTapGesture {
                            onToggleComplete()
                        }
                        .padding(.trailing, 12)
                } else {
                    Image(systemName: "circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(todo.priority == .important ? .red : .gray)
                        .onTapGesture {
                            onToggleComplete()
                        }
                        .padding(.trailing, 12)
                }
                    
                
                if todo.priority == .important {
                    Image("high_priority")
                        .foregroundColor(.red)
                }
                
                VStack(alignment: .leading) {
                    Text(todo.text)
                        .lineLimit(3)
                        .font(.system(size: 16))
                        .strikethrough(todo.isCompleted, color: .gray)
                        .foregroundColor(todo.isCompleted ? .gray : .primary)
                    
                    if let deadline = todo.deadline {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.secondary)
                            Text(deadline, style: .date)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Spacer()
                Image(systemName: "chevron.right")
                    .onTapGesture {
                        onInfo()
                    }
            }
            .padding()
            .cornerRadius(10)
        
        
        
        .swipeActions(edge: .leading) {
            Button {
                onToggleComplete()
            } label: {
                Label("", systemImage: todo.isCompleted ? "circle" : "checkmark.circle")
            }
            .tint(.green)
        }
        .swipeActions(edge: .trailing) {
            Button {
                onInfo()
            } label: {
                Label("Info", systemImage: "info.circle")
            }
            .tint(.gray)

            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
            .tint(.red)
        }
    }
}

struct TodoRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TodoRow(todo: TodoItem(text: "Купить что-то", priority: .regular, isCompleted: false), onToggleComplete: {}, onInfo: {}, onDelete: {})
                .previewDisplayName("Ячейка в 1 строку")
            
            TodoRow(todo: TodoItem(text: "Купить что-то, где-то, зачем-то, но зачем не очень понятно", priority: .regular, isCompleted: false), onToggleComplete: {}, onInfo: {}, onDelete: {})
                .previewDisplayName("Ячейка в 2 строки")
            
            TodoRow(todo: TodoItem(text: "Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы показать как обрезать текст в ячейке", priority: .regular, isCompleted: false), onToggleComplete: {}, onInfo: {}, onDelete: {})
                .previewDisplayName("Ячейка в 3 строки")
            
            TodoRow(todo: TodoItem(text: "Купить что-то", priority: .unimportant, isCompleted: false), onToggleComplete: {}, onInfo: {}, onDelete: {})
                .previewDisplayName("Ячейка в 1 строку, низкий приоритет")
            
            TodoRow(todo: TodoItem(text: "Купить что-то", priority: .important, isCompleted: false), onToggleComplete: {}, onInfo: {}, onDelete: {})
                .previewDisplayName("Ячейка в 1 строку, высокий приоритет")
            
            TodoRow(todo: TodoItem(text: "Купить что-то", priority: .regular, isCompleted: true), onToggleComplete: {}, onInfo: {}, onDelete: {})
                .previewDisplayName("Ячейка в 1 строку, выполнена")
            
            TodoRow(todo: TodoItem(text: "Задание", priority: .regular, deadline: Date(), isCompleted: false), onToggleComplete: {}, onInfo: {}, onDelete: {})
                .previewDisplayName("Ячейка в 1 строку с датой дедлайна")
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
