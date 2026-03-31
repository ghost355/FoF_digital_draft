# Тесты ActionDeckEngine

## Обзор

| Файл | Тестов | Описание |
|------|--------|----------|
| `ActionCardTests.swift` | 15 | Тесты структуры `ActionCard` |
| `ActionDeckEngineTests.swift` | 2 | Тесты методов `ActionDeckEngine` |
| `ActionDeckTests.swift` | 13 | Тесты логики `ActionDeck` |
| `JSONLoaderTests.swift` | 3 | Тесты загрузки JSON |
| **Итого** | **33** | |

---

## ActionCardTests.swift

### hasIcon

| Тест | Описание |
|------|----------|
| `testHasIcon_cardContainsIcon_returnsTrue` | Карта содержит иконку → возвращает `true` |
| `testHasIcon_cardDoesNotContainIcon_returnsFalse` | Карта не содержит иконку → возвращает `false` |
| `testHasIcon_emptyIcons_returnsFalse` | Пустой массив иконок → возвращает `false` |

### randomNumber

| Тест | Описание |
|------|----------|
| `testRandomNumber_options2_returnsTableIndex0` | options=2 → table[0] |
| `testRandomNumber_options3_returnsTableIndex1` | options=3 → table[1] |
| `testRandomNumber_options7_returnsTableIndex5` | options=7 → table[5] |
| `testRandomNumber_options12_returnsTableIndex10` | options=12 → table[10] |

### combatResult

| Тест | Описание |
|------|----------|
| `testCombatResult_ncmMinus4_returnsFirstElement` | NCM=-4 → первый элемент (index 0) |
| `testCombatResult_ncm0_returnsFifthElement` | NCM=0 → пятый элемент (index 4) |
| `testCombatResult_ncm6_returnsLastElement` | NCM=6 → последний элемент (index 10) |
| `testCombatResult_ncmBelowMinus4_clampedToMinus4` | NCM=-10 → clamped до -4 |
| `testCombatResult_ncmAbove6_clampedTo6` | NCM=10 → clamped до 6 |

### isReshuffleCard

| Тест | Описание |
|------|----------|
| `testIsReshuffleCard_id51_returnsTrue` | id=51 → `true` |
| `testIsReshuffleCard_id50_returnsFalse` | id=50 → `false` |
| `testIsReshuffleCard_id1_returnsFalse` | id=1 → `false` |

---

## ActionDeckEngineTests.swift

### hqEvent

| Тест | Описание |
|------|----------|
| `testHqEvent_cardHasHqEventIcon_returnSuccess` | Карта с иконкой `hqEvent` → `.success` |
| `testHqEvent_cardHasHqEventIcon_returnFailure` | Карта без иконки `hqEvent` → `.failure` |

---

## ActionDeckTests.swift

### draw

| Тест | Описание |
|------|----------|
| `testDraw_count1_addsOneCardToHand` | draw(1) → handCount = 1 |
| `testDraw_count3_addsThreeCardsToHand` | draw(3) → handCount = 3 |
| `testDraw_multipleTimes_accumulatesCards` | draw(2) дважды → handCount = 4 |
| `testDraw_removesCardsFromDrawDeck` | draw уменьшает drawDeckCount |
| `testDraw_reshuffleCard_triggersReshuffle` | Карта reshuffle вызывает перемешивание |

### discardHand

| Тест | Описание |
|------|----------|
| `testDiscardHand_clearsHand` | discardHand() → handCount = 0 |
| `testDiscardHand_movesCardsToDiscardPile` | Карты перемещаются в discardPile |
| `testDiscardHand_emptyHand_doesNothing` | Пустая рука → discardPileCount = 0 |

### currentHand

| Тест | Описание |
|------|----------|
| `testCurrentHand_returnsAllDrawnCards` | currentHand возвращает все вытянутые карты |
| `testCurrentHand_emptyDeck_returnsEmptyArray` | Пустая рука → пустой массив |

### counters

| Тест | Описание |
|------|----------|
| `testTotalCount_equalsDrawDeckPlusDiscardPile` | totalCount = drawDeck + discardPile |
| `testDrawDeckCount_decreasesOnDraw` | draw уменьшает drawDeckCount |

### reshuffle

| Тест | Описание |
|------|----------|
| `testReshuffle_reshuffleCardInsertedInFirstHalfOfDeck` | Карта reshuffle вставляется в первую половину колоды |

---

## JSONLoaderTests.swift

### loadJSON

| Тест | Описание |
|------|----------|
| `testLoadJSON_validFile_returnsDecodedData` | Загрузка JSON возвращает массив карт |
| `testLoadJSON_validFile_decodesAllCardFields` | Все поля карты декодируются корректно |
| `testLoadJSON_reshuffleCardExists` | В JSON существует карта reshuffle (id=51) |

---

## Структура тестов (AAA)

Каждый тест следует паттерну **Arrange-Act-Assert**:

```swift
func testExample() {
    // 1. ARRANGE - подготовка тестовых данных
    let card = makeCard(...)
    let engine = ActionDeckEngine(cards: [card])
    
    // 2. ACT - выполнение действия
    let result = engine.someMethod()
    
    // 3. ASSERT - проверка результата
    XCTAssertEqual(result, .expectedValue)
}
```

---

## Запуск тестов

```bash
swift test
```

Для запуска конкретного теста:

```bash
swift test --filter ActionCardTests
swift test --filter testHasIcon
```

---

## Тестовые данные

Тесты используют `makeCard` helper для создания тестовых карт с контролируемыми параметрами:

```swift
private func makeCard(
    id: Int = 1,
    activatedCommands: Int = 0,
    initiativeCommands: Int = 0,
    atNumber: Int = 0,
    icons: [ActionCardIcon] = [],
    combatResults: [CombatResult] = [...],
    hitEffects: HitEffectTable = ...,
    randomNumberTable: [Int] = [...]
) -> ActionCard
```
