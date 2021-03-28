import RxSwift
import RxCocoa
import UIKit

class TableView: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
// Default value
    private let names = BehaviorRelay(value: ["Кирилл", "Матвей", "Василий", "Яков"])
    private var presavedNames = BehaviorRelay<[String]>(value:[])
    private var presavedNames2: [String] = []
    private var searchString = Observable.of("")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        names
            .do(onNext: {
                print(1, $0.count)
            })
            .bind(to: presavedNames)
            .disposed(by: bag)
        
        presavedNames2.append(contentsOf: names.value)
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
                if el != ""{
                    self.names.accept(Names.filterName(value: self.names.value, el: el))                                    // вся логика в модели
                } else {
                    self.names.accept(self.presavedNames2)
                }
                print("presaved2: \(self.presavedNames2.count), names2: \(self.names.value.count)")
                return el                                                                                               // для красивого принта
            }
            .subscribe(onNext: { el in
                ///print("Ищем: \(el)")                                                                                    // только для галочки
            })
            .disposed(by: bag)
    }
//MARK: - Create buttons
    @IBAction func addButton(_ sender: Any) {
        names.accept([Names.getName()] + names.value)                                                                   // BR получает новое значение
        self.presavedNames2.insert(Names.getName(), at: 0)
    }                                                                                                                   // и добавляет к нему дефолное
    
    
    @IBAction func deleteButton(_ sender: Any) {
        names.accept(Names.removeName(names: names.value))                                                              // BR принимает обновленный массив
        self.presavedNames2.removeLast()
        
    }
}
