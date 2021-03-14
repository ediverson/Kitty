import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var helpLabel: UILabel!
    @IBOutlet weak var sendButton: NSLayoutConstraint!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendButton.isActive = false
        
        let label = helpLabel.rx.text.orEmpty
        
        passTextField.rx.text.orEmpty
            .filter {!$0.isEmpty}
            .map { lenght in
                if lenght.count < 6 {
                    label.map {helpLabel.text = "error"}
                }
            }
            .subscribe(onNext: { value in
                print(value)
            })
            .disposed(by: bag)
    }
    

}

