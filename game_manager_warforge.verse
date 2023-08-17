using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Random }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using {/Verse.org/Simulation/Tags}

spawner := class(tag){}

game_manager := class(creative_device):

    @editable PetAssets : []creative_prop_asset = array{}

    var CustomPlayers : [player]custom_player = map{}

    OnBegin<override>()<suspends>:void=
        GetPlayspace().PlayerRemovedEvent().Subscribe(OnPlayerLeftServer)
        InitSpawners()

    InitSpawners():void=
        Spawners := GetCreativeObjectsWithTag(spawner{}) 
        for (Obj : Spawners):
            if (Spawner := player_spawner_device[Obj]):
                Spawner.SpawnedEvent.Subscribe(OnPlayerSpawned)


    OnPlayerSpawned(Agent : agent):void=
        if (Player := player[Agent]):
            InitPlayer(Player)


    InitPlayer(Player : player):void=
        Rand := GetRandomInt(0, PetAssets.Length - 1)
        if:
            PetAsset := PetAssets[0]
            Agent := agent[Player]
            Fort := Agent.GetFortCharacter[]
        then:
            if (Existing := CustomPlayers[Player]){}
            else:
                Fort.EliminatedEvent().Subscribe(OnPlayerEliminated)
                
                CustomPlayer := custom_player{Player := Player, PetAsset := PetAsset}
                CustomPlayer.Init()
                if (set CustomPlayers[Player] = CustomPlayer) {}


    OnPlayerEliminated(Result : elimination_result):void=
        if:
            Killer := Result.EliminatingCharacter?
            Agent := Killer.GetAgent[]
            Player := player[Agent]
            CustomPlayer := CustomPlayers[Player]
        then:
            if (not (Result.EliminatedCharacter = Result.EliminatingCharacter?)):
                CustomPlayer.AwardElimination()

    OnPlayerLeftServer(PlayerLeaving : player):void=
        if (CustomPlayer := CustomPlayers[PlayerLeaving]):
            # Clean up any assets / data from leaving player
            CustomPlayer.Dispose() 

            # Remove the player from our map to free up memory
            var NewCustomPlayerMap:[player]custom_player = map{}
    
            for (Key -> Value : CustomPlayers, Key <> PlayerLeaving):
                set NewCustomPlayerMap = ConcatenateMaps(NewCustomPlayerMap, map{Key => Value})
            
            set CustomPlayers = NewCustomPlayerMap    
