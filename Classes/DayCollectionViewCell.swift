//
//  DayCollectionViewCell.swift
//  EasyCalendarSwift
//
//  Created by Dmitry Baranov on 18.02.2020.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {
    static let identifier:String = "DayCollectionViewCell"
    var indexPath:IndexPath?
    
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
    
    var container: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.white
    //        view.layer.cornerRadius = 4
            view.layer.masksToBounds = true
    //        view.layer.shadowOpacity = 0.5
    //        view.layer.shadowRadius = 4
    //        view.layer.shadowOffset = CGSize(width: 0, height: 2)
    //        view.layer.shadowColor = UIColor.black.cgColor
    //        view.layer.borderColor = UIColor.black.cgColor
    //        view.layer.borderWidth = 0.5
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
    
    let lblDay:UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 20.0)
        l.textAlignment = .center
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
        self.contentView.addSubview(self.container)
        if #available(iOS 9.0, *) {
            let constraints = [
                self.container.topAnchor.constraint(equalTo: self.topAnchor),
                self.container.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                self.container.leftAnchor.constraint(equalTo: self.leftAnchor),
                self.container.rightAnchor.constraint(equalTo: self.rightAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
        } else {
            // Fallback on earlier versions
        }
        self.container.addSubview(lblDay)
        if #available(iOS 9.0, *) {
            let constraints = [
                self.container.topAnchor.constraint(equalTo: self.container.topAnchor, constant: 2.0),
                self.container.bottomAnchor.constraint(equalTo: self.container.bottomAnchor, constant: 2.0),
                self.container.leftAnchor.constraint(equalTo: self.container.leftAnchor, constant: 2.0),
                self.container.rightAnchor.constraint(equalTo: self.container.rightAnchor, constant: 2.0)
            ]
            NSLayoutConstraint.activate(constraints)
        } else {
            // Fallback on earlier versions
        }
        
    }

    private func setup() {
        guard let d = date else {
            return
        }
        let calendar = Calendar.current
        let day = calendar.component(.day, from: d)
        lblDay.text = "\(day)"
    }
}
