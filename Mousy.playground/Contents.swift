import UIKit
// Вспомогательные инструменты
var count = 0
func increment() {
    count += 1
}
func newPrint<T>(_ a: T, _ b: T){
    print("6.\(count) –– a = \(a), b = \(b)")
}

protocol Summable { static func +(lhs: Self, rhs: Self) -> Self }
protocol Multiplicable { static func *(lhs: Self, rhs: Self) -> Self }
// решил воспользоваться наработками из прошлой домашки, чтобы сделать текущий код более универсальным


//4
/*
 Дженерики нужны для того, чтобы сделать код гибким и переиспользуемым. Так мы указав дженерик вместо типа, можем использовать разные типы, а не один заданный изначально. Соответственно мы значительно сокращаем код
 */

//5
/*
 Если уж честно, то это практически одно и то же, только в разных обертках. Основная разница в том, что ассоциативные типы мы используем в основом в протоколах, чтобы задать плейсхолдер для типа, который еще не обозначен, а дженерики по большей части нужны для объявления в функциях
 Так же в ассоциативных типах мы можем легко указать тип, после еще и ограничение поставить.
 Пример: associatedtype Suffix: SuffixableContainer where Suffix.Item == Item
 */


//6.1
increment()
func equate<T: Equatable>(_ a: T, _ b: T){
    if a == b{
        newPrint(a, b)
    }else{
        newPrint(a, b)
    }
}
equate(1, 1)
equate("1", "2")

//6.2
increment()
func compare<T: Comparable>(_ a: T, _ b: T){
    if a > b{
        newPrint(a, b)
    }else if a < b{
        newPrint(a, b)
    }else{
        newPrint(a, b)
    }
}
compare(3, 5)
compare("2", "2")


//6.3
increment()
func replace<T: Comparable>(_ a: inout T, _ b: inout T){
    if a > b{
        let tempA = a
        a = b
        b = tempA
        newPrint(a, b)
    }else if a < b{
        let tempB = b
        b = a
        a = tempB
        newPrint(a, b)
    }else{
        newPrint(a, b)
    }
}
var someInt = "5"
var anotherInt = "3"
replace(&someInt, &anotherInt)

//6.4
//ближайшее, что я смог сделать. Совсем не понимаю, что именно должно получиться
typealias pops<T> = (T) -> Void
typealias lops = ()
var some = 0

func one<T>(_ value: T){
    some += 1
}
func two<T>(_ value: T){
    some += 1
    
}

func three<T>(_ c: T){
    one(T.self)
    two(T.self)
    some += 1
}
//let test = three


//func oneTwo<T>(_ a: (T) -> Void, _ b: (T) -> Void) -> ((T) -> Void){
//    return test
//}


//7.1

extension Array  where Element: Comparable{
    
    var maxEl: Element?{
            let result = self.sorted(){$0 < $1}
            return result.last ?? nil
    }
}
var array: [Int] = [1,2,3,2]
array.maxEl

//7.2

//extension Array where Element:Equatable {
//
//    func removeDuplicates() -> [Element] {
//        var result = [Element]()
//
//        for (index, value) in self.enumerated() {
//
//            if result.contains(value) == false {
//                result.append(value)
//            }
////            }else{
////                print("–",self[index], value, result)
////                result.remove(at: self[index - 1] as! Int)
////            }
//        }
//        return result
//    }
//}
//array.removeDuplicates()


extension Int: Summable, Multiplicable { }
extension String: Summable { }
extension Double: Summable, Multiplicable { }

//8.1
infix operator ^^
/*
func ^^<T: Multiplicable>(left: T, right: Int) -> T{
    var result = 1.0 as! T //здесь у меня ошибка, если подставлять в значение left –– не тот же тип, что и сам result. Получается если я хочу возвести в степень число типа Double, то result тоже должен быть типа Double. Вроде звучит логично, но если я задаю ему тип Т, при этом на входе указываю, что тип Т –– Int/Double, разве result не должен автоматически извлекаться в нужный мне тип?
    for _ in 1...right{
        result = left  * result
    }
    return result
}
2.2^^3 // из-за этой ошибки проще всегда задавать число с точкой, так и считать будет правильно, и все типы поддерживаются
2.2^^4
*/
//Рабочий вариант, но только для Int

func ^^(left: Int, right: Int) -> Int{
    var result = 1
    for _ in 1...right{
        result = left  * result
    }
    return result
}
2^^3


//8.2

infix operator ~>
func ~><T: Summable>(left: T, right: inout T) -> T?{
        right = left + left
    return right
}

var a = "0"
"4"~>a
var b = 0.0
10.1~>b
var c = 0
3~>c

//8.3
infix operator <*

extension UIViewController: UITableViewDelegate{
    static func <*(left: UIViewController, right: UITableView) -> UITableViewDelegate{
        right.delegate = left
        return left
    }
}

class View: UIViewController{ }
class TableView: UITableView{ }

var view = View()
var table = TableView()

view <* table

//8.4
infix operator +++

func +++<T: Summable>(left: T, right: String) -> String{
    return "\(left)" + right
}

b+++a
c+++a

//9
protocol Animator{
    associatedtype Target
    associatedtype Value
    
    func background(target: Target, color: UIColor)
    func viewCenter(target: Target, x: Value, y: Value)
    func form(target: Target, x: Value, y: Value)
}

class Animate: Animator{
    func background(target: UIView, color: UIColor) {
        UIView.animate(withDuration: 0.5) {
            target.backgroundColor = color
        }
    }
    func viewCenter(target: UIView, x: CGFloat, y: CGFloat) {
        UIView.animate(withDuration: 0.5) {
            target.center = .init(x: x, y: y)
        }
    }
    func form(target: UIView, x: CGFloat, y: CGFloat) {
        UIView.animate(withDuration: 0.5) {
            target.transform = .init(scaleX: x, y: y)
        }
    }
}

class newView: UIView{
    let change = Animate()
    
    func changeView(){
        change.background(target: self, color: .red)
        change.form(target: self, x: 20, y: 20)
        change.viewCenter(target: self, x: 5, y: 5)
    }
    
}
