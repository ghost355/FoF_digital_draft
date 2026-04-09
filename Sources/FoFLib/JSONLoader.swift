import Foundation

func loadJSON<T: Decodable>(
    _ filename: String, as type: T.Type, from bundle: Bundle
) -> T {
    guard let url = bundle.url(forResource: filename, withExtension: "json") else {
        fatalError("Файл \(filename).json не найден")
    }

    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Ошибка парсинга \(filename).json: \(error)")
    }
}

func loadJSON<T: Decodable>(_ jsonString: String, as type: T.Type) -> T {
    guard let data = jsonString.data(using: .utf8) else {
        fatalError("Не удалось преобразовать строку в Data")
    }
    
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Ошибка парсинга JSON строки: \(error)")
    }
}
