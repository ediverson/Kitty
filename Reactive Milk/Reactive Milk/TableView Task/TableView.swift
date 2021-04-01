import RxSwift
import RxCocoa
import UIKit

class TableView: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
// Default value
    private let names = BehaviorRelay(value: ["Кирилл", "Матвей", "Василий", "Яков"])
    var namesRelay = BehaviorRelay<[String]>(value: [])
    private var searchString = Observable.of("")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setupView()
    }
    
    func setupTF(){
        namesRelay = BehaviorRelay(value: names.value)
        _ = textField
            .rx
            .text
            .orEmpty
            .throttle(RxTimeInterval.milliseconds(2000), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map({ query in
                self.names.value.filter({ name in
                    return name.lowercased().contains(query.lowercased())
                })
            })
            .subscribe(onNext: { el in
                if self.textField.text != "" {
                    self.names.accept(el)
                } else {
                    self.names.accept(self.namesRelay.value)
                }
            })
            .disposed(by: bag)
    }
    
//MARK: - Setup view
    private func setupView(){
        setupTF()

        names
            .bind(to: tableView.rx.items) { (tableView, row, element) in
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
                cell.nameLabel?.text = element
                return cell
            }
            .disposed(by: bag)
          
        tableView.rx
            .itemSelected
            .subscribe(onNext: { indexPath in
                self.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: bag)
    }

    
//MARK: - Create buttons
    @IBAction func addButton(_ sender: Any) {
        let name = Names.getName()
        names.accept([name] + names.value)
        namesRelay.accept(names.value)
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        names.accept(Names.removeName(names: names.value))
        namesRelay.accept(names.value)
    }
}

