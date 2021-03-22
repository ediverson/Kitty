import UIKit
import RxSwift
import RxCocoa

class CounterVC: UIViewController {
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var countButton: UIButton!
    
    var presavedCount = 0
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    
    func setupVC() {
        self.countLabel.text = "Нажмите на кнопку"                          // стартовое значение
        
        self.countButton
            .rx
            .tap
            .map { [weak self] _ -> String in                               // слабая ссылка на self
                self?.presavedCount += 1                                    // добавляем по 1 при тапе
                return "Вы нажали: \(self?.presavedCount ?? 0) раз"         // возвращаем красивую строку
            }
            .bind(to: self.countLabel.rx.text)                              // привязываем результат к лейблу
            .disposed(by: bag)
    }
}
