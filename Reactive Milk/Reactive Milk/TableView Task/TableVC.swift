import UIKit
import RxSwift
import RxCocoa

class TableVC: UITableViewController {
    private var presavedNames = ["Name1","Name2","Name3","Name4","Name5",
                                "Name6","Name7","Name8","Name9","Name10",
                                "Name11","Name12","Name13","Name14","Name15",
                                "Name16","Name17","Name18","Name19","Name20"]
    
    let objNames = Observable.of(["Name1","Name2","Name3","Name4","Name5",
                                    "Name6","Name7","Name8","Name9","Name10",
                                    "Name11","Name12","Name13","Name14","Name15",
                                    "Name16","Name17","Name18","Name19","Name20"])
    let disposeBag = DisposeBag()
    
    @IBOutlet var table: UITableView!
    @IBOutlet weak var add: UIBarButtonItem!
    @IBOutlet weak var delete: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
//        
//        table.dataSource = self
//        table.delegate = self
//        
        objNames
            .bind(to: table.rx.items) { (tableView: UITableView, index: Int, element: String) in
                
                let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
                cell.textLabel?.text = element
                return cell
                }
              .disposed(by: disposeBag)
            

    }
    @IBAction func addButton(_ sender: Any) {
        showAlert()
    }
    @IBAction func deleteButton(_ sender: Any) {
        presavedNames.removeLast()
        self.table.reloadData()
    }
    
    // MARK: - Table view data source


//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return presavedNames.count
//    }
//
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//
//        cell.textLabel?.text = presavedNames[indexPath.row]
//
//        return cell
//    }
}



extension TableVC {
    
    func showAlert(){
        let alert = UIAlertController(title: nil, message: "Who you want to add?", preferredStyle: .alert)

        let addAction = UIAlertAction(title: "Add", style: .default, handler: { action in
                if let name = alert.textFields?.first?.text {
                    self.presavedNames.append(name)
                    print(name,self.presavedNames.count)
                    self.table.reloadData()
                }
        })
        addAction.isEnabled = false
        alert.addAction(addAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        alert.addTextField { field in
            field.placeholder = "Enter name"
            
            field.addTarget(self,
                            action: #selector(self.alertTextFieldDidChange(_:)),
                            for: UIControl.Event.editingChanged)
        }
        
        present(alert, animated: true)
    }
    
    @objc private func alertTextFieldDidChange(_ sender: UITextField) {
        let alert: UIAlertController = self.presentedViewController as! UIAlertController
        alert.actions[0].isEnabled = sender.text!.count > 0
    }
}
