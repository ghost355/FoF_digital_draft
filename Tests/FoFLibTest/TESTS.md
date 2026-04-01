# Тесты ActionDeckEngine

## Обзор

| Файл | Тестов | Описание |
|------|--------|----------|
| `ActionCardTests.swift` | 15 | Тесты структуры `ActionCard` |
| `ActionDeckEngineTests.swift` | 25 | Тесты методов `ActionDeckEngine` |
| `ActionDeckTests.swift` | 13 | Тесты логики `ActionDeck` |
| `JSONLoaderTests.swift` | 3 | Тесты загрузки JSON |
| **Итого** | **56** | |

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
| `testHqEvent_cardLacksHqEventIcon_returnFailure` | Карта без иконки `hqEvent` → `.failure` |

### mines (вытягивает 3 карты)

| Тест | Описание |
|------|----------|
| `testMines_handContainsBurstIcon_returnSuccess` | Карта с `burst` → `.success` |
| `testMines_handContainsTripleBurstIcon_returnSuccess` | Карта с `tripleBurst` → `.success` |
| `testMines_handContainsShortIcon_returnSuccess` | Карта с `short` → `.success` |
| `testMines_handLacksBurstIcons_returnFailure` | Карты без нужных иконок → `.failure` |
| `testMines_multipleCards_noneHasBurstIcon_returnFailure` | Несколько карт, ни одна с нужной иконкой → `.failure` |

### infiltration

| Тест | Описание |
|------|----------|
| `testInfiltration_cardHasInfiltrateIcon_returnSuccess` | Одна карта с `infiltrate` → `.success` |
| `testInfiltration_cardLacksInfiltrateIcon_returnFailure` | Одна карта без `infiltrate` → `.failure` |
| `testInfiltration_multipleCards_oneHasInfiltrateIcon_returnSuccess` | 3 карты, хотя бы одна с `infiltrate` → `.success` |
| `testInfiltration_multipleCards_noneHasInfiltrateIcon_returnFailure` | 3 карты, ни одна с `infiltrate` → `.failure` |
| `testInfiltration_multipleCards_infiltrateAtFirstPosition_returnSuccess` | 3 карты, `infiltrate` первая → `.success` |
| `testInfiltration_multipleCards_infiltrateAtLastPosition_returnSuccess` | 3 карты, `infiltrate` последняя → `.success` |

### cover

| Тест | Описание |
|------|----------|
| `testCover_cardHasCoverIcon_returnSuccess` | Одна карта с `cover` → `.success` |
| `testCover_cardLacksCoverIcon_returnFailure` | Одна карта без `cover` → `.failure` |
| `testCover_multipleCards_oneHasCoverIcon_returnSuccess` | 3 карты, хотя бы одна с `cover` → `.success` |
| `testCover_multipleCards_noneHasCoverIcon_returnFailure` | 3 карты, ни одна с `cover` → `.failure` |
| `testCover_multipleCards_coverAtFirstPosition_returnSuccess` | 3 карты, `cover` первая → `.success` |
| `testCover_multipleCards_coverAtLastPosition_returnSuccess` | 3 карты, `cover` последняя → `.success` |

### rally

| Тест | Описание |
|------|----------|
| `testRally_cardHasRallyIcon_returnSuccess` | Одна карта с `rally` → `.success` |
| `testRally_cardLacksRallyIcon_returnFailure` | Одна карта без `rally` → `.failure` |
| `testRally_multipleCards_oneHasRallyIcon_returnSuccess` | 3 карты, хотя бы одна с `rally` → `.success` |
| `testRally_multipleCards_noneHasRallyIcon_returnFailure` | 3 карты, ни одна с `rally` → `.failure` |
| `testRally_multipleCards_rallyAtFirstPosition_returnSuccess` | 3 карты, `rally` первая → `.success` |
| `testRally_multipleCards_rallyAtLastPosition_returnSuccess` | 3 карты, `rally` последняя → `.success` |

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

## Запуск тестов

```bash
swift test
```

Для запуска конкретного набора тестов:

```bash
swift test --filter ActionDeckEngineTests
swift test --filter testInfiltration
```
