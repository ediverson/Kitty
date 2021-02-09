import UIKit

//MARK: -Доп Задания

// 1. Используя generic типы, реализовать структуру данных Stack.
struct Stack<Element>{
    var value: [Element]
    
    mutating func append(with el: Element){
        value.append(el)
    }
    mutating func remove(){
        value.removeLast()
    }
}

var p = Stack(value: [1,2,3,4])
p.remove()
p.append(with: 2)


//2. Реализовать очередь Queue.
DispatchQueue.main.async { // выполняем задачу на основном потоке
    print(1)
}

DispatchQueue.global(qos: .background).async { // выполняем задачу на заднем потоке
    print(2)
    DispatchQueue.main.async { // снова на основном потоке
        print(3)
    }
    print(4)
    DispatchQueue.main.async {
        print(5)
    }
}

// Если честно, совсем не понял почему мой код тут при каждом запуске работает вразнобой. Сколько раз запускаю, столько вариантов получаю. Хотя по идее сначала должен сработать главный поток, а потом задний. То есть в ответе мы должны получить 1,3,5,2,4

//3. Реализовать связный список Linked List.
// читал статью (https://habr.com/ru/post/462083/) и понял, что большую часть оттуда вообще не понимаю. Сокрее всего мне еще рано для такого

//4. Какие существуют способы указать ограничения (constraints) для generic-типов?

protocol Constraint: Equatable{
    associatedtype valueOne
}

protocol ConstraintTwo{
    associatedtype value: Equatable
}

protocol ConstraintThree{
    func value<T: Equatable>(_ a: T)
}

//5. Привести примеры ограничения для generic с помощью where.
protocol ConstraintFour{
    associatedtype valueTwo: Constraint where valueTwo.valueOne == valueTwo
}

extension Array where Element: Equatable{
    
}

//6. Можно ли использовать протокол с Associated Type в качестве самостоятельного типа?
// нет, так как: associatedtype != тип
//let f: ConstraintTwo - тут у нас будет ошибка

//7. Можно ли обойти это ограничение?
// задать значение с этим типом в протоколе, а потом указать вместо associatedtype уже настоящий тип


protocol FlyableProtocol{
    associatedtype Object
    func fly() -> Object
}

struct Animal{
    let name: String
}
struct Item {
    let name: String
}

struct Eagle: FlyableProtocol{
    typealias Object = Animal
    
    func fly() -> Animal {
        print("Its flying")
        return Animal(name: "Eagle")
    }
}


struct Plane: FlyableProtocol{
    typealias Object = Item
    
    func fly() -> Item {
        print("Its flying")
        return Item(name: "Boing")
    }
}

struct AnyCreature<Object>: FlyableProtocol{
    private let _fly: () -> Object
    
    init<Something: FlyableProtocol>(_ creature: Something) where Something.Object == Object {
        _fly = creature.fly
    }
    func fly() -> Object {
        return _fly()
    }
}


let creatures = [AnyCreature(Eagle())] // Если захотим добавить сда AnyCreature(Plane()), то получим ошибку, так как класс Eagle и Plane относятся к разным типам. Eagle - Animal, а Plane - Item
creatures.map() { $0.fly() }


// В статье написано про пример из Swift Standard Library - AnySequence, но разве под это не подходят вообще все протоколы с префиксом Any? (AnyHashable, AnyIterator, AnyCollection) Они все нужны примерно для одной цели - своего рода универсальный тип

protocol UserProtocol{
    var name: String { get }
}

protocol ConversationProtocol {
    var threadId: String { get }
    var correspondent: UserProtocol { get }
    var isUnread: Bool { get }
}

extension ConversationProtocol where Self: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(threadId)
    }

    func isEqualTo(_ other: ConversationProtocol) -> Bool {
        guard let otherConversation = other as? Self else {
            return false
        }

        return threadId == otherConversation.threadId
    }

    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.isEqualTo(rhs)
    }
}


struct Conversation: ConversationProtocol {
    var threadId: String
    var correspondent: UserProtocol
    var isUnread: Bool
}

extension Conversation: Hashable {}

struct AnyHashableConversation: ConversationProtocol {

    var threadId: String {
        return conversation.threadId
    }

    var correspondent: UserProtocol {
        return conversation.correspondent
    }

    var isUnread: Bool {
        return conversation.isUnread
    }

    private let conversation: ConversationProtocol

    init(conversation: ConversationProtocol) {
        self.conversation = conversation
    }
}

// Use our existing Hashable implementation
extension AnyHashableConversation: Hashable {}
//10. Реализовать любой infix, prefix, postfix операторы.
var seven = 7
let one = 1
while seven != 10 {
    seven += one
}
// на самом деле нашел тут интересную страничку https://riptutorial.com/swift/example/23548/precedence-of-standard-swift-operators. По сути тут расписаны приоритет и ассоциативность для каждого оператора. Интересно тут то, что для таких базовых операторов как + или - приоритет не указан, плюс стоят они выше, чем * или %, хотя очевидно их приоритет ниже. А еще было любопытно узнать, что пробел –– тоже считается оператором


//MARK: -Домашняя работа

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
              added.insert(element)
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
