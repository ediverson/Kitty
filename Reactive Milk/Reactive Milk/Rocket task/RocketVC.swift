import UIKit
import RxSwift
import RxCocoa

class RocketVC: UIViewController {
    @IBOutlet weak var rocketImageView: UIImageView!
    @IBOutlet weak var zapuskButton: UIButton!
    @IBOutlet weak var launchButton: UIButton!
    @IBOutlet weak var infoLable: UILabel!
    
    private let launchRocket = UIImage(named: "rocket")
    private let returnRocket = UIImage(named: "rocket 2")
    private let duration = 2.0
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    
 //MARK: - Setup
    private func setupVC() {
        
// Кнопка "Запуск"
        zapuskButton
            .rx
            .tap
            .throttle(RxTimeInterval.seconds(Int(duration * 2)), scheduler: MainScheduler.instance)     // запрещаем много запусков
            .do(onNext: {
                self.launchAnimation()                                                                  // запускаем
            })
            .delay(RxTimeInterval.seconds(Int(duration)), scheduler: MainScheduler.instance)            // откладываем возвращение
            .do(onNext: {
                self.returnAnimation()                                                                  // возвращаем
            })
            .subscribe(onNext: {
                self.infoLable.text = "Ракета запущена"                                                 // показываем лейбл
            })
            .disposed(by: bag)

// Кнопка "Launch"
        launchButton
            .rx
            .tap
            .throttle(RxTimeInterval.seconds(Int(duration * 2)), scheduler: MainScheduler.instance)
            .do(onNext: {
                self.launchAnimation()
            })
            .delay(RxTimeInterval.seconds(Int(duration)), scheduler: MainScheduler.instance)
            .do(onNext: {
                self.returnAnimation()
            })
            .subscribe(onNext: {
                self.infoLable.text = "Rocket launched"
            })
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
