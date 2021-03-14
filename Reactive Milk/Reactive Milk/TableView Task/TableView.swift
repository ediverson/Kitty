import RxSwift
import RxCocoa
import RxDataSources
import UIKit

class TableView: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var names = ["Name1","Name2","Name3","Name4","Name5",
                "Name6","Name7","Name8","Name9","Name10"]
    
    

    @IBOutlet weak var add: UIBarButtonItem!
    @IBOutlet weak var delete: UIBarButtonItem!
    let disposeBag = DisposeBag()
    
    let objNames = BehaviorRelay.init(value: [SectionModel(header: "", items: [Human.init(name: "Name1"),
                                                                               Human.init(name: "Name2"),
                                                                               Human.init(name: "Name3"),
                                                                               Human.init(name: "Name4"),
                                                                               Human.init(name: "Name5")]) ])
    
    let dataSourse = RxTableViewSectionedReloadDataSource<SectionModel>(configureCell: { _, table, indexPath, item -> UITableViewCell in
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = item.name
        return cell
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delete.rx.tap.asDriver()
            .drive(onNext: { _ in
                self.objNames.value.map { el in
                    el.items
                }
            })
            .disposed(by: disposeBag)
        
//        add.rx.tap.asDriver()
//            .drive(onNext: {
//                var item: [String] {
//                    var items = [String]()
//                    let random = Int.random(in: 1...4)
//                    items.append(contentsOf: people)
//
//                    return items
//                }
//
//                self.objNames.value += [SectionModel(header: "", items: item)]
//                print(self.names)
//                self.tableView.reloadData()
//            })
//            .disposed(by: disposeBag)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        table()
    }
    
    func table(){
        
        objNames
            .bind(to: tableView
                    .rx
                    .items(dataSource: dataSourse))
            .disposed(by: disposeBag)
        
//        objNames
//            .bind(to: tableView
//                    .rx
//                    .items) { tableView, index, element in
//
//                let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
//                cell.textLabel?.text = element.name
//                return cell
//                }
//
    }
    
    

}
