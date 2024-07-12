//
//  CalendarViewController.swift
//  TodoApp
//
//  Created by Виктория Серикова on 05.07.2024.
//


import UIKit
import SwiftUI
import CocoaLumberjackSwift

final class CalendarViewController: UIViewController {
    // MARK: - Fields
    private var viewModel: CalendarViewModel
    private var hostingController: UIHostingController<TodoDetailViewWrapper>?
    
    private var showingDetailView = false {
        didSet {
            if showingDetailView {
                presentDetailView()
            } else {
                dismissDetailView()
                viewModel.loadItems()
                dataDidUpdate()
            }
        }
    }
    
    private let plusButton = UIButton()
    
    private lazy var calendar: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 70, height: 70)
        let calendar = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        calendar.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCell.calendarCellId)
        calendar.delegate = self
        calendar.dataSource = self
        calendar.backgroundColor = .clear
        calendar.showsHorizontalScrollIndicator = false
        return calendar
    }()
    
    private lazy var table: UITableView = {
        let table = UITableView(frame: self.view.frame, style: .insetGrouped)
        table.register(TodoCell.self, forCellReuseIdentifier: TodoCell.todoCellId)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .singleLine
        return table
    }()
    
    // MARK: - Lifecycle
    init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Мои дела"
        self.navigationItem.hidesBackButton = false
        configureUI()
        DDLogInfo("CalendarViewController loaded")
    }
    
    // MARK: - Configuration
    private func configureUI() {
        configureCalendar()
        configureTable()
        configurePlusButton()
    }
    
    private func configureCalendar() {
        view.addSubview(calendar)
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        calendar.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        calendar.heightAnchor.constraint(equalToConstant: 90).isActive = true
        calendar.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
    }
    
    private func configureTable() {
        view.addSubview(table)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.topAnchor.constraint(equalTo: calendar.bottomAnchor).isActive = true
        table.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        table.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    private func configurePlusButton() {
        plusButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        plusButton.contentHorizontalAlignment = .fill
        plusButton.contentVerticalAlignment = .fill
        plusButton.tintColor = .systemBlue
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(plusButton)
        plusButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        plusButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        plusButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        plusButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func plusButtonTapped() {
        showingDetailView = true
        DDLogInfo("Plus button tapped, showing detail view")
    }
    
    private func presentDetailView() {
        let todoDetailViewModel = TodoDetailViewModel(todoItem: nil, listViewModel: TodoListViewModel())
        let detailView = TodoDetailViewWrapper(
            isShowed: Binding(
                get: {
                    self.showingDetailView
                },
                set: {
                    self.showingDetailView = $0
                }
            ),
            viewModel: todoDetailViewModel
        )
        hostingController = UIHostingController(rootView: detailView)
        if let hostingController = hostingController {
            present(hostingController, animated: true, completion: nil)
            DDLogInfo("Presenting detail view")
        }
    }
    
    private func dismissDetailView() {
        hostingController?.dismiss(animated: true, completion: nil)
        hostingController = nil
        DDLogInfo("Dismissing detail view")
    }
}


// MARK: - UITableViewDelegate
extension CalendarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        DDLogDebug("Leading swipe action for row at \(indexPath)")
        let item = viewModel.todoItems[indexPath.section].1[indexPath.row] as TodoItem
        if !item.isCompleted {
            let doneAction = UIContextualAction(style: .normal, title: "") { _, _, completionHandler in
                self.viewModel.changeDone(item, value: true)
                completionHandler(true)
            }

            doneAction.backgroundColor = .green
            doneAction.image = UIImage(systemName: "checkmark.circle.fill")
            let swipeConfiguration = UISwipeActionsConfiguration(actions: [doneAction])
            return swipeConfiguration
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        DDLogDebug("Trailing swipe action for row at \(indexPath)")
        let item = viewModel.todoItems[indexPath.section].1[indexPath.row] as TodoItem
        
        let notDoneAction = UIContextualAction(style: .normal, title: "") { _, _, completionHandler in
            self.viewModel.changeDone(item, value: false)
            completionHandler(true)
        }
        notDoneAction.backgroundColor = .yellow
        notDoneAction.image = UIImage(systemName: "xmark.circle.fill")
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [notDoneAction])
        return swipeConfiguration
    }
}

// MARK: - UITableViewDataSource
extension CalendarViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.todoItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.todoItems[section].1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: TodoCell.todoCellId)
        guard let todoCell = cell as? TodoCell else { return UITableViewCell() }
        todoCell.configure(with: viewModel.todoItems[indexPath.section].1[indexPath.row])
        return todoCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.todoItems[section].0
    }
}

// MARK: - UICollectionViewDelegate
extension CalendarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DDLogDebug("Collection view item selected at \(indexPath)")
        table.scrollToRow(at: IndexPath(item: 0, section: indexPath.item), at: .top, animated: true)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == calendar { return }
        if scrollView.isTracking || scrollView.isDragging || scrollView.isDecelerating {
            DDLogDebug("Scroll view did scroll")
            if let firstVisibleRowIndex = table.indexPathsForVisibleRows?.first {
                let indexPath = IndexPath(item: firstVisibleRowIndex.section, section: 0)
                calendar.scrollToItem(at: indexPath, at: .left, animated: true)
                self.calendar.selectItem(
                    at: indexPath,
                    animated: true,
                    scrollPosition: UICollectionView.ScrollPosition.left
                )
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension CalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = calendar.dequeueReusableCell(withReuseIdentifier: CalendarCell.calendarCellId, for: indexPath)
        guard let calendarCell = cell as? CalendarCell else { return UICollectionViewCell() }
        calendarCell.configure(with: viewModel.dates[indexPath.item])
        calendarCell.layer.borderColor = UIColor.secondaryLabel.cgColor
        calendarCell.layer.borderWidth = 3
        calendarCell.layer.cornerRadius = 16
        return calendarCell
    }
}

extension CalendarViewController: CalendarViewModelDelegate {
    func dataDidUpdate() {
        DispatchQueue.main.async {
            self.table.reloadData()
            self.calendar.reloadData()
            DDLogInfo("Data updated, reloading table and calendar")
        }
    }
}
