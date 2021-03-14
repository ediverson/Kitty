import Foundation
import RxDataSources

struct Human {
    let name: String
}

struct SectionModel {
    var header: String
    var items: [Human]
}

extension SectionModel: SectionModelType {
    init(original: SectionModel, items: [Human]) {
        self = original
        self.items = items
    }
}

public let people = ["Anton", "Ira", "Barsik", "Olya"]
