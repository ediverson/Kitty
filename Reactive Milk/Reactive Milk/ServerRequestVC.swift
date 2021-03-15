import UIKit
import RxSwift
import RxCocoa

class ServerRequestVC: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    private var searchString = Observable.of("")                    // пустая sequence
    private let bag = DisposeBag()                                  // мусорка
    private let time: RxTimeInterval = .milliseconds(800)           // 800, а не 500 для наглядности,
                                                                    // так как долго не мог решить проблему неработающего оператора .throttle,
                                                                    // а он просто отправлял запрос слишком быстро
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTF()
    }

    private func setUpTF(){
        searchString = textField
            .rx
            .text
            .orEmpty
            .throttle(time, scheduler: MainScheduler.instance)      // откладываем выполнение
            .map { "\($0)" }                                        // controlProperty в String
            .filter { $0 != "" }                                    // пропускаем все пустые значения
        
        searchString
            .map { "Ваш запрос: \($0)"}
            .bind(to: resultLabel.rx.text)                          /// чтобы на экране что-то было
            .disposed(by: bag)
                    
        searchString
            .subscribe(onNext: {
                print("Отправка запроса для \($0)")                 // печатаем запрос
            })
            .disposed(by: bag)
    }
}
