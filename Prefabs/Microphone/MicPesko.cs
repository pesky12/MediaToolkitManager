
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class MicPesko : UdonSharpBehaviour
{
    void Start()
    {
        
    }

    public override void Interact()
    {
        VRCPlayerApi[] players = new VRCPlayerApi[VRCPlayerApi.GetPlayerCount()];

        players = VRCPlayerApi.GetPlayers(players);

        foreach(VRCPlayerApi player in players)
        {
            player.SetVoiceDistanceFar(0);
            player.SetVoiceDistanceNear(0);
            Debug.Log("Set" + player.playerId + "mute");
        }
    }
}
