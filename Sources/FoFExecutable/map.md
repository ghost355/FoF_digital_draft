# Fields of Fire Digital — Архитектура

## 1. GameEngine (оркестратор)

* GameEngine
  * GameContext
  * PhaseProcessor
  * Factories

---

## 2. GameContext (состояние игры)

A. Campaign

    - name: String
    - specialRules: [CampaignSpecialRule]
    - usGrenadesVOF: Int
    - enemyGrenadesVOF: Int
    - replacements: Replacements?

B. Mission

    1. name: String
    2. duration: Int
    3. type: MissionType
        - offensive
        - defensive
        - patrol
    4. visibility: Visibility
        - clear
        - rain
        - fog
        - night
    5. tacticalControls: TacticalControl
        a) lineOfDeparture: Row
        b) lineOfAdvance: Row
        c) leftBoundary: Column
        d) rightBoundary: Column
        e) primaryObjective: GridPosition
        f) secondaryObjective: GridPosition?
        g) attackPosition: GridPosition
    6. pcPlacement: [PotentialContact]
    7. enemyTactics: EnemyTactic
        - deliberateDefense
        - hastyDefense
        - delayDefense
        - offensiveAssault
    8. enemyExperience: ExperienceLevel
        - green
        - line
        - veteran
    9. friendlyUnits: [Unit]
    10. enemyUnits: [Unit]
    11. attachments: [Unit]
    12. fireSupport: [FireSupport]
    13. friendlyEvents: [Event]
    14. enemyEvents: [Event]
    15. enemyForcePackages: EnemyForcePackages

C. Map

    * GridCell[rows][columns]
        - position: GridPosition
        - terrainStack: [TerrainCard]  (холмы в стеке)
        - isFaceUp: Bool
        - friendlyUnits: [Unit]
        - enemyUnits: [Unit]
        - vofMarkers: [VOFMarker]
        - combatModifiers: [CombatModifier]
        - tacticalMarkers: [TacticalMarker]
        - pc: PotentialContact?
        - covers: [Cover]

D. Units[]

    * Unit
        a) id: String
        b) name: String
        c) side: Side
            - us
            - german
            - northKorean
            - vietcong
            - nva
            - katusa
            - chinese
        d) type: UnitType
            - squad
            - hq
            - fo
            - weaponsTeam
            - sniper
            - leader
            - spotter
            - vehicle
            - aircraft
            - staff
            - runner
            - aboveHQ
        e) status: UnitStatus
            - goodOrder
            - pinned
            - assaultTeam
            - fireTeam
            - litterTeam
            - paralyzedTeam
            - casualty
        f) vofRating: VOFRating
            - small
            - auto
            - heavy
            - autoTripod
            - heavyTripod
            - sniper
            - grenade
            - autoSmall
            - smallGrenade
            - autoSmallGrenade
            - flamethrower
            - demolition
            - wp
        g) steps: Int
        h) experience: ExperienceLevel
            - green
            - line
            - veteran
        i) position: GridPosition?
        j) ammo: [AmmoType: Int]
        k) equipment: [EquipmentID]
        l) assignedTo: String? (HQ id)
        m) isExposed: Bool
        n) receivedVOF: [ReceivedVOF]
        o) breakdownRules: [UnitBreakdown]?

E. ActionEngine

    * ActionDeck
        - drawPile: [ActionCard]
        - discardPile: [ActionCard]
        - hand: [ActionCard]
        - reshuffleCardId: Int

---

## 3. PhaseProcessor (последовательность фаз)

1. phases:[TurnPhase] (жесткий список)

    a) friendlyHigherHQEvent

    b) enemyActivityDefensive

    c) friendlyCommandActivation

    d) friendlyCommandInitiative

    e) enemyActivityOffensive

    f) mutualCaptureAndRetreat

    g) atCombatAndVehicleMovement

    h) mutualCombat

        - fireMissionUpdate
        - potentialContactEvaluation
        - pinnedRecovery
        - combatEffects

    i) cleanup

2. currentPhaseIndex: Int

---

## 4. Factories (создание объектов)

A. PackageFactory

    *context: GameContext
    * create(packageId: Int) -> EnemyPackage

B. OrderFactory

    *availableOrders: [OrderType]
    * create(input: String) -> Order?

---

## 5. Orders (44 приказа игрока)

* MoveOrder
* AttackOrder
* SeekCoverOrder
* RallyOrder
* InfiltrateOrder
* SpotOrder
* ExhortOrder
* ConcentrateFireOrder
* GrenadeAttackOrder
* CallForFireOrder
* DetachTeamOrder
* ReattachTeamOrder
* RecoverUnitOrder
* UsePyrotechnicOrder
* SendRunnerOrder
* ActivateOrder
* ... (остальные 30)

---

## 6. Ключевые enum

**TurnPhase**

* friendlyHigherHQEvent
* enemyActivityDefensive
* friendlyCommandActivation
* friendlyCommandInitiative
* enemyActivityOffensive
* mutualCaptureAndRetreat
* atCombatAndVehicleMovement
* mutualCombat
* cleanup

**AttemptResult**

* success
* failure
* jam
* short
* mines
* criticalHit
* bnFireMisson

**AttemptType**

* random(for: Int)
* activationCommands
* initiativeCommands
* atNumber
* combatResult(ncm: Int)
* hitEffect(experience: ExperienceLevel)
* hqEvent
* infiltration(cards: Int)
* cover(cards: Int)
* spotting(cards: Int)
* contact(cards: Int)
* rally(cards: Int)
* mines
* grenade(cards: Int, canJam: Bool)
* concentrate(cards: Int, canJam: Bool)
* callForFire(cards: Int, hasBnFireMission: Bool)

**CombatResult**

* miss
* pin
* hit

**HitEffect**

* casualty (C)
* paralyzed (P)
* litter (L)
* fire (F)
* assault (A)

**ActionCardIcon**

* infiltrate
* contact
* cover
* crosshairs
* grenade
* burst
* tripleBurst
* short
* jam
* hqEvent

**VOFMarker**

* pinned
* smallArms
* automaticWeapons
* heavyWeapons
* grenade
* sniper
* mines
* incoming
* airStrike

**CombatModifier**

* crossfire (-1)
* concentratedFire (-1)
* grenadeMiss (-1)
* demoMiss (-2)

**TacticalMarker**

* lod(GridPosition)
* loa(GridPosition)
* mlr(GridPosition)
* phaseLine(GridPosition)
* leftBoundary(GridPosition)
* rightBoundary(GridPosition)
* primaryObjective(GridPosition)
* secondaryObjective(GridPosition)
* attackPosition(GridPosition)
* casualtyCollectionPoint(GridPosition)
* landingZone(GridPosition)
* combatOutpost(GridPosition)
* routePoint(GridPosition)
* fpl(GridPosition, Direction)
* fpf(GridPosition, Direction)

**Cover**

* basic
* foxholes
* trench
* bunker
* pillbox
* deepBunker
* building(value: Int)

**Direction**

* north
* northEast
* east
* southEast
* south
* southWest
* west
* northWest

**CampaignSpecialRule**

* bocageTerrain
* elevationCards
* helicopterAssault
* tunnelComplexes
* humanWave
