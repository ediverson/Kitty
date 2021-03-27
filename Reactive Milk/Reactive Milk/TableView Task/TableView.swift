import RxSwift
import RxCocoa
import UIKit

class TableView: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
// Default value
    private let names = BehaviorRelay(value: ["Кирилл", "Матвей", "Василий", "Яков"])
    private var searchString = Observable.of("")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {                                                                     // чтобы таблица строилась
        super.viewDidAppear(true)                                                                                       // до появления на экране
        setupView()
        setUpTF()
    }
    
//MARK: - Setup view
    private func setupView(){
        names
            .bind(to: tableView.rx.items) { (tableView, row, element) in                                                // привязываем BR к таблице
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell        // настраиваем таблицу
                cell.nameLabel.text = element                                                                           // настраиваем ячейку
                return cell
            }
            .disposed(by: bag)
        
        tableView.rx
            .itemSelected
            .subscribe(onNext: { indexPath in
                self.tableView.deselectRow(at: indexPath, animated: true)                                               // рекция на нажатие на ячейку
            })
            .disposed(by: bag)
    }
    
    private func setUpTF(){
        searchString = textField
            .rx
            .text
            .orEmpty
            .throttle(RxTimeInterval.seconds(2), scheduler: MainScheduler.instance)
            .map { "\($0)" }
            .skip(1)                                                                                                    // пропускаем при первом нажатии
            .distinctUntilChanged()
                                        /// фильтрации через .filter {  $0 != "" } нет, так как нам нужно получать пустую строку, когда пользователь задал что-то в поиске а потом стер
        searchString
            .map { el -> String in
                self.names.accept(Names.filterName(value: self.names.value, el: el))                                    // вся логика в модели
                return el                                                                                               // для красивого принта
            }
            .subscribe(onNext: { el in
                print("Ищем: \(el)")                                                                                    // только для галочки
            })
            .disposed(by: bag)
    }
//MARK: - Create buttons
    @IBAction func addButton(_ sender: Any) {
        names.accept([Names.getName()] + names.value)                                                                   // BR получает новое значение
    }                                                                                                                   // и добавляет в него дефолное
    
    @IBAction func deleteButton(_ sender: Any) {
        names.accept(Names.removeName(names: names.value))                                                              // BR принимает обновленный массив
    }
}
