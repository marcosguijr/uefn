using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/SpatialMath }

radio_track := class<concrete>:
    TrackDevice : radio_device = radio_device {}
    TrackLength : float = 0.0

radio_sequence_controller := class(creative_device):
    
    # Editable Properties    
    @editable Tracks : []radio_track = array {}
    @editable DelayBetweenTracks : float = 1.0

    # Variables
    var CurrentTrackIndex : int = 0
    var RemainingTime : float = 0.0
    var Playing : logic = false

    OnBegin<override>()<suspends> : void =
        loop:
            if (Playing = true):
                if (RemainingTime <= 0.0):
                    PlayNextTrack()
                else:
                    Sleep(0.1)
                    set RemainingTime -= 0.1
            else:
                Sleep(1.0)

    # Stop playing the sequence    
    StopPlaying() : void =
        set Playing = false
        if(Track := Tracks[CurrentTrackIndex]):
            set RemainingTime = Track.TrackLength
            Track.TrackDevice.Stop()
    
    # Play the current track
    PlayCurrentTrack() : void =
        if (CurrentTrackIndex >= 0 and CurrentTrackIndex < Tracks.Length):
            if(Track := Tracks[CurrentTrackIndex]):
                set RemainingTime = Track.TrackLength
                Track.TrackDevice.Play()
        else:
            StopPlaying()

    # Play the next track
    PlayNextTrack()<suspends> : void =
        set CurrentTrackIndex = CurrentTrackIndex + 1
        if (CurrentTrackIndex >= Tracks.Length):
            set CurrentTrackIndex = 0
        PlayCurrentTrack()
        Sleep(DelayBetweenTracks)
