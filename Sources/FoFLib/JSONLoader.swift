// JSONLoader.swift
import Foundation

// let cards: [ActionCard] = JSONLoader.load(fromFile: "actionDeck")
// let terrain: [TerrainCard] = JSONLoader.load(fromFile: "terrainDeck")
// let units: [Unit] = JSONLoader.load(fromFile: "units")Ckk

enum JSONLoader {
    static func load<T: Decodable>(
        _ type: T.Type, fromFile fileName: String, bundle: Bundle = .main
    ) -> T {
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            fatalError("Файл \(fileName).json не найден")
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Ошибка парсинга \(fileName).json: \(error)")
        }
    }

    static func load<T: Decodable>(_ type: T.Type, fromJSON jsonString: String) -> T {
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
}
