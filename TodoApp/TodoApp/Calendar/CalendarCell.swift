//
//  CalendarCell.swift
//  TodoApp
//
//  Created by Виктория Серикова on 05.07.2024.
//

import UIKit

final class CalendarCell: UICollectionViewCell {
    // MARK: - Fields
    static let calendarCellId: String = "CalendarCellId"
    
    lazy var day = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var month = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var other = {
        let label = UILabel()
        label.text = "Другое"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        day.text = nil
        month.text = nil
        other.text = nil
        other.removeFromSuperview()
    }
    
    // MARK: - Configuration
    func configure(with model: String) {
        switch model {
        case "Другое":
            addSubview(other)
            other.text = "Другое"
            other.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            other.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            self.autoresizesSubviews = true
        default:
            let components = model.components(separatedBy: " ")
            day.text = components[0]
            month.text = components[1]
            addSubview(day)
            addSubview(month)
            month.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            month.topAnchor.constraint(equalTo: self.centerYAnchor, constant: 1).isActive = true
            day.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            day.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: -1).isActive = true
        }
    }
}
