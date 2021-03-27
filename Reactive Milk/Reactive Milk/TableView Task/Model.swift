import Foundation

class Names {
    static let names: [String] = ["Георгий", "Вадим", "Сергей",
                                  "Владимир", "Александр", "Артём",
                                  "Тимур", "Виталий", "Руслан",
                                  "Глеб", "Николай", "Анатолий"]
    
    static func getName() -> String {
        return(Names.names[Int.random(in: 0..<Names.names.count)])    // выдаем рандомное значение через .random
                                                                      // в диапазоне от нуля до кол-ва элементов в массиве names
    }
    
    static func removeName(names: [String]) -> [String] {
        if names != [] {
        var newNames = names                                          // создаем переменную
        newNames.removeLast()                                         // удаляем последнее значение
        return newNames                                               // возвращаем обновленный массив
        } else {
            return names                                              // если массив пустой, то удалять нечего
        }
    }
}



