import Foundation

class Names {
    static let names: [String] = ["Георгий", "Вадим", "Сергей",
                                  "Владимир", "Александр", "Артём",
                                  "Тимур", "Виталий", "Руслан",
                                  "Глеб", "Николай", "Анатолий"]
    
    static func getName() -> String {
        return (Names.names[Int.random(in: 0..<Names.names.count)])         // выдаем рандомное значение через .random
                                                                            // в диапазоне от нуля до кол-ва элементов в массиве names
    }
            
    static func removeName(names: [String]) -> [String] {
        if names != [] {
            var newNames = names                                            // создаем переменную
            newNames.removeLast()                                           // удаляем последнее значение
            return newNames                                                 // возвращаем обновленный массив
        } else {
            return names                                                    // если массив пустой, то удалять нечего
        }
    }
            
    static func filterName(value: [String], el: String) -> [String] {
        var filteredNames: [String] = []                                    // пустой массив
        
        if el != "" {                                                       // если в поиске не пусто
            for name in value {                                             // проходимся по элементам массива
                if name.contains(el){                                       // смотрим содержит ли элементы нужные нам данные
                    filteredNames.append(name)                              // если да, то добавляем в новый массив
                }
            }
            ///print("f", filteredNames)
            return filteredNames                                            // возвращаем его
        } else {                                                            // если строка пустая
            ///print("v", value)
            return value                                                    // возвращаем исходный массив
        }
        
    }
}



