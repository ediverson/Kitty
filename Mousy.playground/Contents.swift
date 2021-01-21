import UIKit

// 1. Можно ли ограничить протокол только для классов?

// можно
protocol ClassOnly: AnyObject{
    var string: String {get}
}


//2. Можно ли создать опциональные функции (необязательные к реализации) у протоколов?

// можно
@objc protocol Optional{
    @objc optional func opt()
}


//3. Можно ли в extension создавать хранимые свойства (stored property)?

// нет, но можно создать через инициализацию
extension Int {
    init(p: Int){
        _ = p
        self.init()
    }
}

// 4. Можно ли в extension объявлять вложенные типы, а именно: классы/структуры/перечисления/протоколы.

// можно

extension String{
    struct Struct{
        let value = ""
    }
}


//5. Можно ли в extension класса/структуры/перечисления реализовать соответствие протоколу?

// можно

final class Class{
    var value = 0
}

extension Class: ClassOnly{
    var string: String {
        return "hello"
    }
}


//6. Можно ли в протоколе объявить инициализатор?

protocol Init{
    init(value: Int)
}

extension Class: Init{
    convenience init(value: Int) {
        self.init()
        self.value = value
    }
}


//7. Как в протоколе объявить readonly свойство?
// через get
protocol ReadOnly{
    var property: Int {get}
}
// можно
struct Read: ReadOnly{
    let property: Int
    
    init(property: Int){
        self.property = property
    }
}


//8. Поддерживают ли протоколы множественное наследование?
// да

protocol All: ReadOnly, Init, Optional, ClassOnly{
    
}

//9. Можно ли создать протокол, реализовать который могут только определенные классы/структуры/перечисления?

// нет, единственное ограничение подобного плана: протокол, доступный только для классов

//10. Можно ли определить тип, который реализует одновременно несколько несвязанных между собой протоколов?
// да

class Alls: ClassOnly, Optional, ReadOnly{
    var string: String = ""
    
    var property: Int = 0
    
    func opt() {
        print(string, property)
    }
    
}
