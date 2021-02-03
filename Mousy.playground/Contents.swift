import UIKit

protocol Summable { static func +(lhs: Self, rhs: Self) -> Self }
protocol Multiplicable { static func *(lhs: Self, rhs: Self) -> Self }
// решил воспользоваться наработками из прошлой домашки, чтобы сделать текущий код более универсальным


//6.1
func equate<T: Equatable>(_ a: T, _ b: T) { print(a == b ? "equal" : "not equal") }
equate(1, 1)
equate("1", "2")

//6.2
func compare<T: Comparable>(_ a: T, _ b: T) { print(a > b ? a : b) }
compare(3, 5)
compare(3.2, 3.1)
compare("2", "2")


//6.3
func replace<T: Comparable>(_ a: inout T, _ b: inout T) {
    if a > b { swap(&a, &b) }
}
var someInt = "5"
var anotherInt = "3"
replace(&someInt, &anotherInt)
someInt
anotherInt

//6.4

func carry<T>(_ a: @escaping (T) -> Void, _ b: @escaping (T) -> Void) -> ((T) -> Void){
    return {
        a($0)
        b($0)
    }
}
// @escaping – указываем, что параметры a и b возвращат значения после того, как возвращает значение сама функция
// $0 - вызываем неназыванный параметр функции, который на данный момент имеет тип Т
// возвращаем мы замыкание (а не функцию), в котором вызываем оба входных параметра, которые так же являютя замыканиями, иу этих параметров вызываем их же неназыванный параметр

carry({ print("\($0) a") }, { print("\($0) b") })("Hihi")
// тут мы вызываем функцию carry, в которую передаем два замыкания, которые принтят наше неназванное значение.
// значение в скобках после функции –– и есть этот неназыванный параметр, который передается в замыкания a и b

//7.1

extension Array  where Element: Comparable {
    
    var maxEl: Element? {
        return self.max()
    }
}
var array: [Int] = [1,2,3,2]
array.maxEl
let newarray = array.max()

//7.2

extension Array where Element: Hashable {

    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        return result
    }
    var uniques: Array {
         var added = Set<Element>()
         return filter { element in
             defer { added.insert(element) }
             return !added.contains(element)
         }
     }
 }

array.removeDuplicates()
array.uniques



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
func ~><T: Summable>(left: T, right: inout T) {
        right = left + left
}

var a = "0"
"4"~>a
var b = 0.0
10.1~>b
var c = 0
3~>c

//8.3
infix operator <*

extension UIViewController: UITableViewDelegate {
    static func <*(left: UIViewController, right: UITableView) -> UITableViewDelegate{
        right.delegate = left
        return left
    }
}

class View: UIViewController { }
class TableView: UITableView { }

var view = View()
var table = TableView()

view <* table

//8.4
infix operator +++

func +++<T: Summable>(left: T, right: String) -> String {
    return String(describing: left) + right
}

b+++a
c+++a

//9
protocol Animator {
    associatedtype Target
    associatedtype Value
    
    func background(target: Target, color: UIColor)
    func viewCenter(target: Target, x: Value, y: Value)
    func form(target: Target, x: Value, y: Value)
}

class Animate: Animator {
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

class NewView: UIView {
    let change = Animate()
    
    func changeView() {
        change.background(target: self, color: .red)
        change.form(target: self, x: 20, y: 20)
        change.viewCenter(target: self, x: 5, y: 5)
    }
    
}
