import Foundation
import RxSwift

public let bag = DisposeBag()                                   // мусорка

public let time: RxTimeInterval = .milliseconds(800)            // 800, а не 500 для наглядности
                                                                // так как долго не мог решить проблему неработающего оператора .throttle,
                                                                // а он просто отправлял запрос слишком быстро
