//
//  EasyCalendar.swift
//  EasyCalendarSwift
//
//  Created by Dmitry Baranov on 18.02.2020.
//

import UIKit

public class EasyCalendarView: UIView {

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func draw(_ rect: CGRect) {
        // Drawing code
        var f = rect
        f.origin = .zero
        let lbl = UILabel(frame: f)
        lbl.text = "Text"
        self.addSubview(lbl)
    }

}
