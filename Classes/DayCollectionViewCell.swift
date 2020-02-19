//
//  DayCollectionViewCell.swift
//  EasyCalendarSwift
//
//  Created by Dmitry Baranov on 18.02.2020.
//

import UIKit

let defaultCalendarFontSize:CGFloat = 16.0

public struct DayCollectionViewCellStateConfig {
    var font:UIFont = UIFont.systemFont(ofSize: defaultCalendarFontSize)
    var textColor:UIColor = .black
    var cellBackgroundColor:UIColor = .white
    var containerBackgroundColor:UIColor = .white
}

public struct DayCollectionViewCellSetConfig {
    var todayBorderWidth:CGFloat = 1.0
    var todayBorderColor:UIColor = .black
    /// simple day
    var defaultState = DayCollectionViewCellStateConfig(font: UIFont.systemFont(ofSize: defaultCalendarFontSize), textColor: .black, cellBackgroundColor: .white, containerBackgroundColor: .white)
    /// today
    var todayState = DayCollectionViewCellStateConfig(font: UIFont.systemFont(ofSize: defaultCalendarFontSize), textColor: .black, cellBackgroundColor: .white, containerBackgroundColor: .white)
    /// reserved
    var reservedState = DayCollectionViewCellStateConfig(font: UIFont.systemFont(ofSize: defaultCalendarFontSize), textColor: .black, cellBackgroundColor: .white, containerBackgroundColor: .green)
    /// date in selected range
    var rangeState = DayCollectionViewCellStateConfig(font: UIFont.systemFont(ofSize: defaultCalendarFontSize), textColor: .black, cellBackgroundColor: .white, containerBackgroundColor: .lightGray)
}

public struct DayCollectionViewCellConfig {
    
    /// dain in current month
    var defaultSetConfig = DayCollectionViewCellSetConfig(
        todayBorderWidth: 1.0,
        todayBorderColor: .black,
        defaultState: DayCollectionViewCellStateConfig(font: UIFont.systemFont(ofSize: defaultCalendarFontSize), textColor: .black, cellBackgroundColor: .white, containerBackgroundColor: .white),
        todayState: DayCollectionViewCellStateConfig(font: UIFont.systemFont(ofSize: defaultCalendarFontSize), textColor: .black, cellBackgroundColor: .white, containerBackgroundColor: .white),
        reservedState: DayCollectionViewCellStateConfig(font: UIFont.systemFont(ofSize: defaultCalendarFontSize), textColor: .white, cellBackgroundColor: .white, containerBackgroundColor: .green),
        rangeState: DayCollectionViewCellStateConfig(font: UIFont.systemFont(ofSize: defaultCalendarFontSize), textColor: .black, cellBackgroundColor: .white, containerBackgroundColor: .lightGray)
    )
    
    /// day in neighboring months
    var inactiveSetConfig = DayCollectionViewCellSetConfig(
        todayBorderWidth: 1.0,
        todayBorderColor: .gray,
        defaultState: DayCollectionViewCellStateConfig(font: UIFont.systemFont(ofSize: defaultCalendarFontSize), textColor: .lightGray, cellBackgroundColor: .white, containerBackgroundColor: .white),
        todayState: DayCollectionViewCellStateConfig(font: UIFont.systemFont(ofSize: defaultCalendarFontSize), textColor: .lightGray, cellBackgroundColor: .white, containerBackgroundColor: .white),
        reservedState: DayCollectionViewCellStateConfig(font: UIFont.systemFont(ofSize: defaultCalendarFontSize), textColor: .lightGray, cellBackgroundColor: .white, containerBackgroundColor: .green),
        rangeState: DayCollectionViewCellStateConfig(font: UIFont.systemFont(ofSize: defaultCalendarFontSize), textColor: .darkGray, cellBackgroundColor: .white, containerBackgroundColor: .lightGray)
    )
}

class DayCollectionViewCell: UICollectionViewCell {
    static let identifier:String = "DayCollectionViewCell"
    
    var date:Date? {
        didSet {
            setup()
        }
    }
    var isReserved: Bool = false {
        didSet {
            setup()
        }
    }
    var isStartRange: Bool = false {
        didSet {
            setup()
        }
    }
    var isEndRange: Bool = false {
        didSet {
            setup()
        }
    }
    var isInRange: Bool = false {
        didSet {
            setup()
        }
    }
    var isInactive: Bool = false {
        didSet {
            setup()
        }
    }

    var cellConfig:DayCollectionViewCellConfig = DayCollectionViewCellConfig()
    
    var container: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.white
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let lblDay:UILabel = {
        let l = UILabel(frame: .zero)
        l.font = UIFont.systemFont(ofSize: 20.0)
        l.textAlignment = .center
        l.textColor = .black
        l.text = "*"
        l.translatesAutoresizingMaskIntoConstraints = false
        l.minimumScaleFactor = 0.5
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// setup view
    private func configureUI() {
        self.backgroundColor = .white
        self.contentView.addSubview(self.container)
        if #available(iOS 9.0, *) {
            let constraints = [
                self.container.topAnchor.constraint(equalTo: self.topAnchor),
                self.container.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                self.container.heightAnchor.constraint(equalTo: self.heightAnchor),
                self.container.widthAnchor.constraint(equalTo: self.container.heightAnchor),
                self.container.centerXAnchor.constraint(equalTo: self.centerXAnchor)
//                self.container.leftAnchor.constraint(equalTo: self.leftAnchor),
//                self.container.rightAnchor.constraint(equalTo: self.rightAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
        } else {
            // Fallback on earlier versions
        }
        self.container.addSubview(lblDay)
        if #available(iOS 9.0, *) {
            let constraints = [
                lblDay.topAnchor.constraint(equalTo: self.container.topAnchor, constant: 1.0),
                lblDay.bottomAnchor.constraint(equalTo: self.container.bottomAnchor, constant: -1.0),
                lblDay.leftAnchor.constraint(equalTo: self.container.leftAnchor, constant: 1.0),
                lblDay.rightAnchor.constraint(equalTo: self.container.rightAnchor, constant: -1.0)
            ]
            NSLayoutConstraint.activate(constraints)
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    private func setupAppearance(stateConfig:DayCollectionViewCellStateConfig) {
        self.backgroundColor = stateConfig.cellBackgroundColor
        container.backgroundColor = stateConfig.containerBackgroundColor
        lblDay.font = stateConfig.font
        lblDay.textColor = stateConfig.textColor
    }

    private func setup() {
        guard let d = date else {
            return
        }
        let calendar = Calendar(identifier: .gregorian)
        let day = calendar.component(.day, from: d)
        let currentDay = calendar.component(.day, from: d)
        let todayDay = calendar.component(.day, from: Date())
        let currentMonth = calendar.component(.month, from: d)
        let todayMonth = calendar.component(.month, from: Date())
        let currentYear = calendar.component(.year, from: d)
        let todayYear = calendar.component(.year, from: Date())
        container.layer.cornerRadius = self.frame.size.height / 2
        let setConfig = isInactive ? cellConfig.inactiveSetConfig : cellConfig.defaultSetConfig
        if currentDay == todayDay && currentMonth == todayMonth && currentYear == todayYear {
            container.layer.borderColor = setConfig.todayBorderColor.cgColor
            container.layer.borderWidth = setConfig.todayBorderWidth
        } else {
            container.layer.borderWidth = 0
        }
        if isInRange {
            setupAppearance(stateConfig: setConfig.rangeState)
        } else {
            if isReserved {
                setupAppearance(stateConfig: setConfig.reservedState)
            } else {
                setupAppearance(stateConfig: setConfig.defaultState)
            }
        }
//        let week = calendar.component(.weekOfMonth, from: d)
        var dow = calendar.component(.weekday, from: d)
        if dow == 1 {
            dow = 7
        } else {
            dow -= 1
        }
//        lblDay.text = "\(day) \(dow)"
        lblDay.text = "\(day)"

    }
}

class DayEmptyCell: UICollectionViewCell {
    static let identifier:String = "DayEmptyCell"
}

class DayOfWeekCell: UICollectionViewCell {
    static let identifier:String = "DayOfWeekCell"
    
    var container: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.white
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let lblDayOfWeek:UILabel = {
        let l = UILabel(frame: .zero)
        l.font = UIFont.systemFont(ofSize: 10.0)
        l.textAlignment = .center
        l.textColor = .black
        l.text = "*"
        l.translatesAutoresizingMaskIntoConstraints = false
        l.minimumScaleFactor = 0.5
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// setup view
    private func configureUI() {
        self.backgroundColor = .white
        self.contentView.addSubview(self.container)
        if #available(iOS 9.0, *) {
            let constraints = [
                self.container.topAnchor.constraint(equalTo: self.topAnchor),
                self.container.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                self.container.heightAnchor.constraint(equalTo: self.heightAnchor),
                self.container.widthAnchor.constraint(equalTo: self.container.heightAnchor),
                self.container.centerXAnchor.constraint(equalTo: self.centerXAnchor)
//                self.container.leftAnchor.constraint(equalTo: self.leftAnchor),
//                self.container.rightAnchor.constraint(equalTo: self.rightAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
        } else {
            // Fallback on earlier versions
        }
        self.container.addSubview(lblDayOfWeek)
        if #available(iOS 9.0, *) {
            let constraints = [
                lblDayOfWeek.topAnchor.constraint(equalTo: self.container.topAnchor, constant: 1.0),
                lblDayOfWeek.bottomAnchor.constraint(equalTo: self.container.bottomAnchor, constant: -1.0),
                lblDayOfWeek.leftAnchor.constraint(equalTo: self.container.leftAnchor, constant: 1.0),
                lblDayOfWeek.rightAnchor.constraint(equalTo: self.container.rightAnchor, constant: -1.0)
            ]
            NSLayoutConstraint.activate(constraints)
        } else {
            // Fallback on earlier versions
        }
        
    }
}
