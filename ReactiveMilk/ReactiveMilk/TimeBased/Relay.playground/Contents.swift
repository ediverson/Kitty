//import UIKit
//import RxSwift
//
//
//let elementsPerSecond = 1
//let maxElements = 5
//let replayedElements = 1
//let replayDelay: TimeInterval = 3
//
//let sourceObservable = Observable<Int>
//  .interval(.milliseconds(Int(1000.0 / Double(elementsPerSecond))), scheduler: MainScheduler.instance)
//  .replay(replayedElements)
//    
//
////let sourceObservable = Observable<Int>.create { observer in
////    var value = 1
////    let timer = DispatchSource.timer(interval: 1.0 / Double(elementsPerSecond), queue: .main) {
////        if value <= maxElements {
////            observer.onNext(value)
////            value += 1
////        }
////    }
////    return Disposables.create {
////        timer.suspend()
////    }
////}
////.replay(replayedElements)
////.replayAll()
//
//let sourceTimeline = TimelineView<Int>.make()
//let replayedTimeline = TimelineView<Int>.make()
//
//let stack = UIStackView.makeVertical([
//    UILabel.makeTitle("replay"),
//    UILabel.make("Emit \(elementsPerSecond) per second:"),
//    sourceTimeline,
//    UILabel.make("Replay \(replayedElements) after \(replayDelay) sec:"),
//    replayedTimeline
//    ])
//
//_ = sourceObservable.subscribe(sourceTimeline)
//DispatchQueue.main.asyncAfter(deadline: .now() + replayDelay) {
// _ = sourceObservable.subscribe(replayedTimeline)
//}
//_ = sourceObservable.connect()
//
//let hostView = setupHostView()
//hostView.addSubview(stack)
//hostView
//
//
//
//
//
//class TimelineView<E>: TimelineViewBase, ObserverType where E: CustomStringConvertible {
//  static func make() -> TimelineView<E> {
//    return TimelineView(width: 400, height: 100)
//  }
//  public func on(_ event: Event<E>) {
//    switch event {
//    case .next(let value):
//      add(.next(String(describing: value)))
//    case .completed:
//      add(.completed())
//    case .error(_):
//      add(.error())
//    }
//  }
//}
