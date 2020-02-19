//
//  EasyCalendar.swift
//  EasyCalendarSwift
//
//  Created by Dmitry Baranov on 18.02.2020.
//

import UIKit

public class EasyCalendarView: UIView {
    var dataSource:EasyCalendarDataSource?
    var delegate:EasyCalendarDelegate?
    
    var date:Date = Date() {
        didSet {
            debugPrint("\(self.date)")
            setup()
        }
    }
    
    private var leftSwipeRec:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipe(rec:)))
    private var rightSwipeRec:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipe(rec:)))
    private var daysCollectionView:UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private var lblMonthTitle:UILabel = UILabel()

    // init with some date
    convenience public init(frame: CGRect, d:Date) {
        self.init(frame: frame)
        self.date = d
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        daysCollectionView.register(DayCollectionViewCell.self, forCellWithReuseIdentifier: DayCollectionViewCell.identifier)
        daysCollectionView.dataSource = self
        daysCollectionView.delegate = self
        self.addSubview(lblMonthTitle)
        if #available(iOS 9.0, *) {
            let constraints = [
                lblMonthTitle.topAnchor.constraint(equalTo: self.topAnchor),
                lblMonthTitle.heightAnchor.constraint(equalToConstant: 20.0),
                lblMonthTitle.leftAnchor.constraint(equalTo: self.leftAnchor),
                lblMonthTitle.rightAnchor.constraint(equalTo: self.rightAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
        } else {
            // Fallback on earlier versions
        }
        self.addSubview(daysCollectionView)
        if #available(iOS 9.0, *) {
            let constraints = [
                daysCollectionView.topAnchor.constraint(equalTo: lblMonthTitle.bottomAnchor),
                lblMonthTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                lblMonthTitle.leftAnchor.constraint(equalTo: self.leftAnchor),
                lblMonthTitle.rightAnchor.constraint(equalTo: self.rightAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func setup() {
        lblMonthTitle.text = "MONTH"
        daysCollectionView.reloadData()
    }
    
    override public func draw(_ rect: CGRect) {
    }

    @objc func leftSwipe(rec:UISwipeGestureRecognizer) {
        
    }
    
    @objc func rightSwipe(rec:UISwipeGestureRecognizer) {
        
    }
    
    private func lastDayOfMonth() -> Date {
        let calendar = Calendar.current
        let components = DateComponents(day:1)
        let startOfNextMonth = calendar.nextDate(after:self.date, matching: components, matchingPolicy: .nextTime)!
        return calendar.date(byAdding:.day, value: -1, to: startOfNextMonth)!
    }
    
    private func firstDayOfMonth() -> Date {
        let calendar = Calendar.current
        return calendar.date(bySetting: .day, value: 1, of: self.date)!
    }
    
    private func weekdayOfMonthStart() -> Int {
        let calendar = Calendar.current
        return calendar.component(.weekdayOrdinal, from: firstDayOfMonth())
    }
    
    private func lastDayNumber() -> Int {
        let calendar = Calendar.current
        return calendar.component(.day, from: lastDayOfMonth())
    }
    
    private func weeksCount() -> Int {
        return 5
    }
}

extension EasyCalendarView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weeksCount() * 7
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.row < weekdayOfMonthStart()) || (indexPath.row >= lastDayNumber()) {
            return UICollectionViewCell()
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCollectionViewCell.identifier, for: indexPath) as? DayCollectionViewCell {
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    
}

extension EasyCalendarView: UICollectionViewDelegate {
    
}

extension EasyCalendarView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let f = self.frame
        return CGSize(width: f.size.width, height: lblMonthTitle.frame.size.height)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let f = self.frame
        return CGSize(width: f.size.width, height: 1)
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let f = self.frame
        return CGSize(width: f.size.width / 7, height: (f.size.height - lblMonthTitle.frame.size.height) / CGFloat(weeksCount()))
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return .zero
//    }
}
