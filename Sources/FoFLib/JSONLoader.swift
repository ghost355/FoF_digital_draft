import Foundation

public func loadJSON<T: Decodable>(
    _ filename: String, as type: T.Type, from bundle: Bundle
)
    -> T
{
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
