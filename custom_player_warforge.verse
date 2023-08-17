using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/SpatialMath }

custom_player := class<unique>():
    Player : player
    PetAsset : creative_prop_asset
    var PetProp<private> : creative_prop = creative_prop{}

    var CurrentElims<private> : int = 0

    AwardElimination():void=
        set CurrentElims += 1

    GetElimCount()<transacts>:int=
        return CurrentElims

    Init():void=
        if:
            Agent := agent[Player]
            Fort := Agent.GetFortCharacter[]
        then:
            # Spawning prop at player location + offset
            Scale := 1.0
            Tran := transform{Rotation:= Fort.GetViewRotation(), Translation:=Fort.GetTransform().Translation + vector3{Y:=120.0}, Scale := vector3{X:=Scale, Y:=Scale, Z:= Scale}}
            if (Prop := SpawnProp(PetAsset, Tran)(0)?):
                set PetProp = Prop
                spawn{MovePet(Fort)}

    Dispose():void=
        PetProp.Dispose()

    MovePet<private>(Fort : fort_character)<suspends>:void=
        loop:
            # Break if not valid or we'll get an error
            if (not PetProp.IsValid[]):
                break

            Scale := 1.0
            Tran := transform{Rotation:= Fort.GetViewRotation(), Translation:=Fort.GetTransform().Translation + vector3{Y:=120.0}, Scale := vector3{X:=Scale, Y:=Scale, Z:= Scale}}

            PetProp.MoveTo(Tran, 0.5)

