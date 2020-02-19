//
//  EasyCalendar.swift
//  EasyCalendarSwift
//
//  Created by Dmitry Baranov on 18.02.2020.
//

import UIKit

@available(iOS 8.2, *)
open class EasyCalendarViewController: UIViewController {
    public var dataSource:EasyCalendarDataSource?
    public var delegate:EasyCalendarDelegate?
    
    /// can select days in calendar and send it to delegate via dateDidTaped
    public var canSelectDay:Bool = true
    /// can select range of unreserved days in calendar and send it to delegate via dateRangeDidSelect
    public var canSelectRange:Bool = true
    /// can select date less than today
    public var canSelectDateInPast:Bool = false
    /// show days from neared months (inactive days)
    public var showInactiveDays:Bool = false
    /// show day of weeks
    public var showDayOfWeeks:Bool = true
    /// colors and styles
    public var calendarBackgroundColor:UIColor = .white
    public var monthTitleBackgroundColor:UIColor = .white
    public var monthTitleColor:UIColor = .black
    public var monthTitleFont:UIFont = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
    public var monthTitleFormat:String = "MM/YYYY"
    
    public var dowTitleBackgroundColor:UIColor = .white
    public var dowTitleColor:UIColor = .blue
    public var dowTitleFont:UIFont = UIFont.systemFont(ofSize: 13.0, weight: .semibold)
    public var dowRus:[String] = ["Пн","Вт","Ср","Чт","Пт","Сб","Вс"]
    public var dowEng:[String] = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
    public var localeIdentifier:String = "ru"//Locale.current.identifier
    
    var date:Date = Date()
    
    private var daysCollectionView:UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: EasyCalendarFlowLayout())
    private var lblMonthTitle:UILabel = UILabel()
    private let titleHeight:CGFloat = 20.0
    
    private var startDateSelected:Date?
    private var finishDateSelected:Date?

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.translatesAutoresizingMaskIntoConstraints = true
        lblMonthTitle.translatesAutoresizingMaskIntoConstraints = false
        daysCollectionView.translatesAutoresizingMaskIntoConstraints = false
        daysCollectionView.register(DayCollectionViewCell.self, forCellWithReuseIdentifier: DayCollectionViewCell.identifier)
        daysCollectionView.register(DayEmptyCell.self, forCellWithReuseIdentifier: DayEmptyCell.identifier)
        daysCollectionView.register(DayOfWeekCell.self, forCellWithReuseIdentifier: DayOfWeekCell.identifier)
        daysCollectionView.dataSource = self
        daysCollectionView.delegate = self
        daysCollectionView.isScrollEnabled = false
        configureUI()
        let leftSwipeRec:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipe(rec:)))
        let rightSwipeRec:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipe(rec:)))
        leftSwipeRec.direction = .left
        rightSwipeRec.direction = .right
        self.view.addGestureRecognizer(leftSwipeRec)
        self.view.addGestureRecognizer(rightSwipeRec)
    }
    
    private func configureUI() {
        self.view.backgroundColor = calendarBackgroundColor
        lblMonthTitle.text = ""
        lblMonthTitle.backgroundColor = monthTitleBackgroundColor
        lblMonthTitle.textColor = monthTitleColor
        lblMonthTitle.textAlignment = .center
        lblMonthTitle.font = monthTitleFont
        self.view.addSubview(lblMonthTitle)
        self.view.addSubview(daysCollectionView)
        daysCollectionView.backgroundColor = calendarBackgroundColor
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        if #available(iOS 9.0, *) {
            let constraints = [
                lblMonthTitle.topAnchor.constraint(equalTo: self.view.topAnchor),
                lblMonthTitle.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                lblMonthTitle.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                lblMonthTitle.heightAnchor.constraint(equalToConstant: titleHeight),
            ]
            self.view.addConstraints(constraints)
        }
        if #available(iOS 9.0, *) {
            let constraints = [
                daysCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: titleHeight),
                daysCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                daysCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                daysCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
            ]
            self.view.addConstraints(constraints)
        }
    }
    
    public func setup(date:Date) {
        self.date = date
        let df = DateFormatter()
        df.dateFormat = monthTitleFormat
        df.locale = Locale(identifier: localeIdentifier)
        lblMonthTitle.text = df.string(from: self.date)
        daysCollectionView.reloadData()
    }
    
    @objc func leftSwipe(rec:UISwipeGestureRecognizer) {
        monthPlus()
    }
    
    @objc func rightSwipe(rec:UISwipeGestureRecognizer) {
        monthMinus()
    }
    
}


//MARK:- date manipulations
@available(iOS 8.2, *)
extension EasyCalendarViewController {
    // возвращает номер дня от 0 (понедельник) до 6 (воскресенье)
    private func russianDayNumber(dow:Int) -> Int {
        if dow == 1 {
            return 6
        } else {
            return dow - 2
        }
    }
    
    private func englishDayNumber(dow:Int) -> Int {
        return dow - 1
    }
    
    private func firstDayOfMonth() -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: date)
        let startOfMonth = calendar.date(from: components)
        return startOfMonth!
    }
    
    private func lastDayOfMonth() -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let comps2 = NSDateComponents()
        comps2.month = 1
        comps2.day = -1
        let endOfMonth = calendar.date(byAdding: comps2 as DateComponents, to: firstDayOfMonth())
        return endOfMonth!
    }
    
    private func weekdayOfMonthStart() -> Int {
        let calendar = Calendar(identifier: .gregorian)
        let dow = calendar.component(.weekday, from: firstDayOfMonth())
        return localeIdentifier == "ru" ? russianDayNumber(dow: dow) : englishDayNumber(dow: dow)
    }
    
    private func lastDayNumber() -> Int {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.component(.day, from: lastDayOfMonth())
    }
    
    private func dateByDayNumber(number:Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let d = calendar.date(byAdding: .day, value: number, to: firstDayOfMonth(), wrappingComponents: false)
        return d!
    }

    private func weeksCount() -> Int {
        let weeks = 6
        return weeks + (showDayOfWeeks ? 1 : 0)
    }

    private func monthMinus() {
        let calendar = Calendar(identifier: .gregorian)
        if let d = calendar.date(byAdding: .month, value: -1, to: firstDayOfMonth(), wrappingComponents: false) {
            setup(date: d)
        }
    }

    private func monthPlus() {
        let calendar = Calendar(identifier: .gregorian)
        if let d = calendar.date(byAdding: .month, value: 1, to: lastDayOfMonth(), wrappingComponents: false) {
            setup(date: d)
        }
    }
}

//MARK:- UICollectionViewDataSource
@available(iOS 8.2, *)
extension EasyCalendarViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weeksCount() * 7
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var idx = indexPath.row - weekdayOfMonthStart()
        if showDayOfWeeks {
            if indexPath.row < 7 {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayOfWeekCell.identifier, for: indexPath) as? DayOfWeekCell {
                    cell.lblDayOfWeek.textColor = dowTitleColor
                    cell.lblDayOfWeek.font = dowTitleFont
                    cell.lblDayOfWeek.backgroundColor = dowTitleBackgroundColor
                    cell.lblDayOfWeek.text = localeIdentifier == "ru" ? dowRus[indexPath.row] : dowEng[indexPath.row]
                    return cell
                } else {
                    return collectionView.dequeueReusableCell(withReuseIdentifier: DayEmptyCell.identifier, for: indexPath)
                }
            } else {
                idx -= 7
            }
        }
        
        let dateForCell = dateByDayNumber(number: idx)
//        debugPrint("\(idx) Day \(dateForCell)")
        let delta = showDayOfWeeks ? indexPath.row - 7 : indexPath.row
//        let isNotInMonth = (indexPath.row < weekdayOfMonthStart()) || ((indexPath.row - weekdayOfMonthStart()) >= lastDayNumber())
        let isNotInMonth = (delta < weekdayOfMonthStart()) || (idx >= lastDayNumber())
        if !showInactiveDays && isNotInMonth {
            return collectionView.dequeueReusableCell(withReuseIdentifier: DayEmptyCell.identifier, for: indexPath)
        }
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCollectionViewCell.identifier, for: indexPath) as? DayCollectionViewCell {
            cell.date = dateForCell
            cell.isInactive = isNotInMonth
            cell.isReserved = false
            if let ds = dataSource {
                let isDayReserved = ds.dateReserved(d: dateForCell)
//                debugPrint(isDayReserved)
                cell.isReserved = isDayReserved
            }
            cell.isInRange = false
            if let start = startDateSelected, let finish = finishDateSelected {
                if start <= dateForCell && dateForCell <= finish {
                    cell.isInRange = true
                }
            }
            return cell
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: DayEmptyCell.identifier, for: indexPath)
    }
    
    
}

//MARK:- UICollectionViewDelegate
@available(iOS 8.2, *)
extension EasyCalendarViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DayCollectionViewCell {
            if let d = cell.date {
                debugPrint(d)
                var isDayReserved = false
                if let ds = dataSource {
                    isDayReserved = ds.dateReserved(d: d)
                }
                if d < Date() && !canSelectDateInPast {
                    return
                }
                if let calendarDelegate = delegate {
                    calendarDelegate.dateDidTaped(d: d)
                    if canSelectRange && !isDayReserved {
                        if let start = startDateSelected {
                            cell.isInRange = true
                            if start < d {
                                finishDateSelected = d
                                calendarDelegate.dateRangeDidSelect(start: start, finish: d)
                            } else {
                                /// reset range
                                startDateSelected = nil
                            }
                            collectionView.reloadData()
                        } else {
                            startDateSelected = d
                            cell.isInRange = true
                        }
                    }
                }
            }
        }
        
    }
}

//MARK:- FlowLayout
@available(iOS 8.2, *)
extension EasyCalendarViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let f = self.view.frame
        return CGSize(width: f.size.width, height: 1)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let f = self.view.frame
        return CGSize(width: f.size.width, height: 1)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let f = self.view.frame
        let s = CGSize(width: f.size.width / 7, height: (f.size.height - lblMonthTitle.frame.size.height) / CGFloat(weeksCount()) - 2)
        return s
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return .zero
//    }
}

class EasyCalendarFlowLayout: UICollectionViewFlowLayout {
    static let identifier:String = "EasyCalendarFlowLayout"
    
    override func prepare() {
        super.prepare()
        minimumLineSpacing = 2.0
        minimumInteritemSpacing = 0.0
        sectionInset = UIEdgeInsets(top: 1, left: 0, bottom:0, right: 0)
        itemSize = CGSize(width: 20, height: 20)
    }
    
    

}
