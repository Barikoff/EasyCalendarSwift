//
//  EasyCalendar-Protocols.swift
//  EasyCalendarSwift
//
//  Created by Dmitry Baranov on 18.02.2020.
//

import Foundation

protocol EasyCalendarDataSource {
    func dateReserved(d:Date) -> Bool
    func dateTitle(d:Date) -> String?
}

protocol EasyCalendarDelegate {
    func dateDidTaped(d:Date)
    func dateRangeDidSelect(start:Date, finish:Date)
}
