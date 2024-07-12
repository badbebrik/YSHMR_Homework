//
//  TodoDetailViewWrapper.swift
//  TodoApp
//
//  Created by Виктория Серикова on 06.07.2024.
//

import SwiftUI
import UIKit

struct TodoDetailViewWrapper: UIViewControllerRepresentable {
    @Binding var isShowed: Bool
    var viewModel: TodoDetailViewModel

    func makeUIViewController(context: Context) -> UIHostingController<TodoDetailView> {
        let todoDetailView = TodoDetailView(viewModel: viewModel, isShowed: $isShowed)
        return UIHostingController(rootView: todoDetailView)
    }

    func updateUIViewController(_ uiViewController: UIHostingController<TodoDetailView>, context: Context) {
        uiViewController.rootView = TodoDetailView(viewModel: viewModel, isShowed: $isShowed)
    }
}
