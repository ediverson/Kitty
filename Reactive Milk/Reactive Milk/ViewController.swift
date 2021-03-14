import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
// Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var helpLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    
    private var validUser: Observable<Bool?>!
    private var validPass: Observable<Bool?>!
    
// helpers
    private let time: RxTimeInterval = .milliseconds(300)
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sendButton.isEnabled = false

        setUpVC()
    }
    
    private func setUpVC() { /// чтобы было красиво
        setUpPass()
        setUpLogin()
        setUpButton()
    }
 
//MARK: - Button
    private func setUpButton() {
        let allValid = Observable<Bool>
            .combineLatest(validUser, validPass) { (left, right) -> Bool in
                guard left != nil && right != nil else { return false }
                return left! && right!
            }
            .share(replay: 1)
        
        sendButton
            .rx
            .tap
            .throttle(time, scheduler: MainScheduler.instance)
            .bind { [weak self] in
                print("Login: ", self!.emailTextField.text!, "\n",  // тут у нас точно будет значение,
                      "Password: ", self!.passTextField.text!)      // так как иначе кнопка недоступна
            }
            .disposed(by: bag)
        
        allValid
            .bind(to: sendButton.rx.isEnabled )
            .disposed(by: bag)
    }
    
//MARK: - TextFields
    
    //два метода идентичны, различатся лишь название valid check и переменных, так что все опишу тут
    private func setUpLogin() {
        validUser = emailTextField
            .rx                                                     // вызываем rx функционал
            .text                                                   // работаем с текстом
            .orEmpty                                                // защита от nil + развертываем из опционала
            .skip(1)                                                // пропускаем значение при создании
            .observeOn(MainScheduler.asyncInstance)                 // для асинхронной работы
            .throttle(time, scheduler: MainScheduler.instance)      // уменьшаем частоту запросов и просим работать на главном потоке
                                                                        /// scheduler - не поток, а контекст,
                                                                        /// в который мы оборачиваем что-то, в этом случае обернули поток
            .map { [weak self] in
                self?.loginValid(value: $0)                         // valid check через специальный метод (он ниже)
            }
            .map { [weak self] in
                if $0 == true {
                    self?.helpLabel.text = ""                       // если все круто, то идем дальше
                    return $0
                } else {
                    self?.helpLabel.text = "Invalid email"          // если не круто, то
                    return $0
                }
            }
            .distinctUntilChanged()                                 // пропускаем одинаковые значения, пока что-то не изменится
            .share(replay: 1)                                       // делимся для кнопки
        
        validUser
            .subscribe(onNext: {
                print($0!)                                          // принт для наглядности
            })
            .disposed(by: bag)
    }
    
    private func setUpPass() {
        validPass = passTextField
            .rx
            .text
            .orEmpty
            .skip(1)
            .observeOn(MainScheduler.asyncInstance)
            .throttle(time, scheduler: MainScheduler.instance)
            .map { [weak self] in
                self?.passValid(value: $0)
            }
            .map { [weak self] in
                if $0 == true {
                    self?.helpLabel.text = ""
                    return $0
                } else {
                    self?.helpLabel.text = "Password is too short"
                    return $0
                }
            }
            .distinctUntilChanged()
            .share(replay: 1)

        validPass
            .subscribe(onNext: {
                print($0!) // для наглядности
            })
            .disposed(by: bag)
    }
    

//MARK: - Valid check
    
    private func loginValid(value: String) -> Bool {                // нашел в интернетах
        let emailRegEx = "[A_Z0-9a-z.%+-]+@[A_Z0-9a-z.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: value)
    }
    
    private func passValid(value: String) -> Bool {                 // сделал сам на основе того, что нашел в интернетах
        let passRegEx = "[A_Z0-9a-z]{6,99}"
        let passTest = NSPredicate(format: "SELF MATCHES[c] %@", passRegEx)
        return passTest.evaluate(with: value)
    }
}
    
    
    
    
    
//MARK: - Trash
/// нерабочая попытка создать функцию для подписок на текстовые поля

/*
private func setUpPass() {
     
// вариант реализации 1
    self.setUp(obs: &validPass, tf: passTextField, handler: self.passValid(value:))
     
// вариант реализации 2
     setUp(obs: &validPass, tf: passTextField) { (value) -> Bool in
         let passRegEx = "[A_Z0-9a-z]{6,99}"
         let passTest = NSPredicate(format: "SELF MATCHES[c] %@", passRegEx)

         return passTest.evaluate(with: value)
     }
}
     
// общая функция
func setUp(obs: inout Observable<Bool>!, tf: UITextField, handler: @escaping (String) -> Bool){
    obs = tf
        .rx
        .text
        .orEmpty
        .skip(1)
        .observeOn(MainScheduler.asyncInstance)
        .throttle(time, scheduler: MainScheduler.instance)
        .map { handler($0) }
        .map { [weak self] in
            if $0 == true {
                self?.helpLabel.text = ""
                return $0
            } else {
                self?.helpLabel.text = "Password is too short"
                return $0
            }
        }
        .distinctUntilChanged()
        .share(replay: 1)
    
    obs
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: bag)
}
*/

