
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

[UdonBehaviourSyncMode(BehaviourSyncMode.Continuous)]
public class MicPickup : UdonSharpBehaviour
{
    public MicScript micScript;

    //--------------------THIS CODE IS A PUBLIC VARABLE, AS SUCH THIS SETTING CAN DIFFER DEPENDING ON THE SETTINGS IN THE SCENE FILE--------------------
    [Tooltip("List of people who are allowed to fire the gun")]
    private string[] allowedPlayers = {
        "Splitco",
        "Pesky12",
        "SHERR01",
        "Chanoler",
        "PulpFreeFiction",
        "DTJester"
    };
    //--------------------THIS CODE IS A PUBLIC VARABLE, AS SUCH THIS SETTING CAN DIFFER DEPENDING ON THE SETTINGS IN THE SCENE FILE--------------------

    private void Start() {
        Debug.Assert(micScript != null, "You forgot to set the mic script on the pickup");
    }

    public override void OnPickup()
    {
        Networking.SetOwner(Networking.LocalPlayer, gameObject);
        micScript.OnPickupExternal();
    }

    public override void OnPickupUseDown()
    {
        if (validatePlayer()) micScript.OnPickupUseDownExternal();
    }
    public override void OnPickupUseUp()
    {
        if (validatePlayer()) micScript.OnPickupUseUpExternal();
    }
    public override void OnDrop()
    {
        if (validatePlayer()) micScript.OnDropExternal();
    }

    private bool validatePlayer()
    {
        string localPlayerName = Networking.LocalPlayer.displayName;

        foreach (string allowedplayer in allowedPlayers)
        {
            if (localPlayerName.Equals(allowedplayer))
                return true;
        }

        return false;
    }
}
