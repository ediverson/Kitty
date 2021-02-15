import UIKit


// 1. Используя generic типы, реализовать структуру данных Stack.
struct Stack<Element>{
    var value = [Element]()
    
    var count : Int {
            return value.count
        }
    
    mutating func push(with el: Element){
        value.append(el)
    }
    mutating func pop() -> Element?{
        value.removeLast()
    }
}


var s1 = Stack(value: [1,2,3,2])
var s2 = Stack(value: [5,6,7,8])

s1.pop()
s1.push(with: 4)





//2. Реализовать очередь Queue.

struct Queqe<Element>{
    var s1 = Stack<Element>()
    var s2 = Stack<Element>()
    
    mutating func enqueue(_ item: Element){
        s1.push(with: item)
    }
    mutating func dequeue() -> Element? {
           fill()
           return s2.pop()
       }
    private mutating func fill() {
           if s2.count == 0 {
               while s1.count != 0 {
                s2.push(with: s1.pop()!)
               }
           }
    }
}

s1.value
s2.value

var s3 = Queqe(s1: s1, s2: s2)
s3.dequeue()
s3.dequeue()
s3.dequeue()
s3.dequeue()
s3.dequeue()
s3.dequeue()
s3.dequeue()

s3.s1.value
s3.s2.value
        
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

protocol Multiplicable { static func *(lhs: Self, rhs: Self) -> Self }
extension Int: Multiplicable {}

 // postfix
postfix operator ^^
postfix func ^^<T: Multiplicable>(value: T) -> T{
    return value * value
}

6^^

// infix
infix operator ≠
func ≠<T: Equatable>(left: T, right: T) -> Bool{
    if left != right {
        return true
    }
    return false
}

"abc"≠"adc"

// prefix
prefix operator %%
prefix func %%(value: Int) -> String{
    if value % 2 == 0{
        return "четное"
    }
    return "нечетное"
}

%%1
