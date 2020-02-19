# EasyCalendarSwift

[![CI Status](https://img.shields.io/travis/barikoff/EasyCalendarSwift.svg?style=flat)](https://travis-ci.org/barikoff/EasyCalendarSwift)
[![Version](https://img.shields.io/cocoapods/v/EasyCalendarSwift.svg?style=flat)](https://cocoapods.org/pods/EasyCalendarSwift)
[![License](https://img.shields.io/cocoapods/l/EasyCalendarSwift.svg?style=flat)](https://cocoapods.org/pods/EasyCalendarSwift)
[![Platform](https://img.shields.io/cocoapods/p/EasyCalendarSwift.svg?style=flat)](https://cocoapods.org/pods/EasyCalendarSwift)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

```swift

let calendar = EasyCalendarViewController()
/// setup calendar parameters
calendar.showInactiveDays = true
/// can select days in calendar and send it to delegate via dateDidTaped
calendar.canSelectDay:Bool = true
/// can select range of unreserved days in calendar and send it to delegate via dateRangeDidSelect
calendar.canSelectRange:Bool = true
/// can select date less than today
calendar.canSelectDateInPast:Bool = false
/// show days from neared months (inactive days)
calendar.showInactiveDays:Bool = false
/// show day of weeks
calendar.showDayOfWeeks:Bool = true
    
// setup datasource & delegate
calendar.dataSource = self
calendar.delegate = self

// add as subview
var f = CGRect(x: 20, y: 30, width: 300, height: 300)
calendar.view.frame = f
self.view.addSubview(calendar.view)

// setup any month by some date
calendar.setup(date: Date())
```
## Requirements

## Installation

EasyCalendarSwift is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'EasyCalendarSwift'
```

## Author

Dmitry Baranov, work@barikoff.ru

## License

EasyCalendarSwift is available under the MIT license. See the LICENSE file for more info.
