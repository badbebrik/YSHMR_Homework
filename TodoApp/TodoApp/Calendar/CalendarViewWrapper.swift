//
//  CalendarViewWrapper.swift
//  TodoApp
//
//  Created by Виктория Серикова on 05.07.2024.
//

import SwiftUI

struct CalendarViewWrapper: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }

    func makeUIViewController(context: Context) -> some UIViewController {
        let view = CalendarViewController(viewModel: CalendarViewModel())
        return view
    }
}
