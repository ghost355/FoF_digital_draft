// Mission.swfit

class Mission: Codable {
    let name: String
    let campaign: Campaign
    let turns: Int
    let missionType: MissionType

    

}

// MARK: Demo json String 

let demoMission = """
{
    "name": "DemoMission",
    "campaign": "DemoCampaign",
    "turns": 10,
    "missionType": "offensive"
}
"""


