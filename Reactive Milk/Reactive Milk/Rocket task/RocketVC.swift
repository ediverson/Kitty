import UIKit
import RxSwift
import RxCocoa

class RocketVC: UIViewController {
    @IBOutlet weak var rocketImageView: UIImageView!
    @IBOutlet weak var zapuskButton: UIButton!
    @IBOutlet weak var launchButton: UIButton!
    @IBOutlet weak var infoLable: UILabel!
    
    private var zapuskObs: Observable<Bool>!
    private var launchObs: Observable<Bool>!
    
    private let launchRocket = UIImage(named: "rocket")
    private let returnRocket = UIImage(named: "rocket 2")
    private let duration = 2.0
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtons()
        setupVC()
    }
    
 //MARK: - Setup
    
    private func setupVC() {
        let mainObs = Observable<Bool>
            .combineLatest(zapuskObs, launchObs) { (left, right) -> Bool in                         // комбинируем два нажатия
                guard left == true && right == true else { return false }
                ///print("l:", left, "r:", right)
                return left && right                                                                // выводим результат в виде Bool
            }
            .share(replay: 2)
        
        mainObs
            .do(onNext: {_ in
                self.launchAnimation()                                                              // запускаем
            })
            .delay(RxTimeInterval.seconds(Int(duration)), scheduler: MainScheduler.instance)
            .do(onNext: {_ in
                self.returnAnimation()                                                              // возвращаем
            })
            .map { !$0 }                                                                            // меняем на обратное, чтобы отменить значение кнопок
            .subscribe(onNext: {
                ///print("binder", $0, "\n")
                self.infoLable.text = "Ракета запущена"
                self.launchButton.isSelected = $0                                                   // отменяем нажатие в свифте
                self.zapuskButton.isSelected = $0
            })
            .disposed(by: bag)
        
        mainObs
            .bind(to: launchButton.rx.isSelected, zapuskButton.rx.isSelected)                       // вероятнее всего проблема тут
            .disposed(by: bag)                                                                      // мне кажется, что байнд срабатывает раньше, чем подписка
    }
    
    
    private func setupButtons() {
        
// Кнопка "Запуск"
        zapuskObs = zapuskButton
            .rx
            .tap
            .map { el -> Bool in
                ///print("запуск",self.zapuskButton.isSelected)
                return !self.zapuskButton.isSelected                                                // изначально false, так что мы меняем на true
            }
            .map { el in                                                                            // тестовая функция
                ///print("запуск",el, "\n")
                return el
            }
            .share(replay: 2)

        zapuskObs
            .bind(to: self.zapuskButton.rx.isSelected)
            .disposed(by: bag)

// Кнопка "Launch"
        launchObs = launchButton
            .rx
            .tap
            .map { el -> Bool in
                ///print("Launch", self.launchButton.isSelected)
                return !self.launchButton.isSelected
            }
            .map { el in
                ///print("Launch",el, "\n")
                return el
            }
            .share(replay: 2)

        launchObs
            .bind(to: self.launchButton.rx.isSelected)
            .disposed(by: bag)
    }
    
    
//MARK: - Helpers
    private func moveUp(view: UIImageView) { view.center.y -= 300 }                                     // отправляем на
    private func moveDown(view: UIImageView) { view.center.y += 300 }                                   // возвращаем на
    
    private func animate(fun: @escaping (UIImageView) -> (), view: UIImageView, image: UIImage) {       // функция для анимаций
        UIView.animate(withDuration: self.duration, delay: 0, options: .curveEaseIn , animations: {
            self.rocketImageView.image = image
            fun(view)
        })
    }
    
//MARK: - Animate Funcs
    private func launchAnimation() {
        animate(fun: moveUp, view: rocketImageView, image: launchRocket!)                                // запуск
    }
    private func returnAnimation() {
        animate(fun: moveDown, view: rocketImageView, image: returnRocket!)                              // посадка
    }
}





//Старый вариант
//zapuskObs = zapuskButton
//    .rx
//    .tap
//    .throttle(RxTimeInterval.seconds(Int(duration * 2)), scheduler: MainScheduler.instance)     // запрещаем много запусков
//    .do(onNext: {
//        self.launchAnimation()                                                                  // запускаем
//    })
//    .delay(RxTimeInterval.seconds(Int(duration)), scheduler: MainScheduler.instance)            // откладываем возвращение
//    .do(onNext: {
//        self.returnAnimation()                                                                  // возвращаем
//    })
//            .share(replay: 1)
//            .subscribe(onNext: {
//                self.infoLable.text = "Ракета запущена"                                                 // показываем лейбл
//            })
//            .disposed(by: bag)
