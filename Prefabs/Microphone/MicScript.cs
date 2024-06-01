
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

[UdonBehaviourSyncMode(BehaviourSyncMode.Manual)]
public class MicScript : UdonSharpBehaviour
{
    [Tooltip("Number of decibels to boost the mic holder by when used")]
    [Range(0, 9)]
    public float MicGain = 3f;
    private float DefaultVoiceDistnaceNear = 0f;
    private float DefaultVoiceDistnaceFar = 25f;
    //public float DefaulDistanceNear = 0f;
    //public float DefaulDistanceFar = 25f;

    //Radius in which to mute players
    [Tooltip("Radius in which to muffle people. Everyone becomes progressively quieter depending on how close the local player is to the microphone.")]
    public float MuffleRange = 10f;


    //State settings
    [UdonSynced(UdonSyncMode.None)]
    private bool poweredOn = false;
    [UdonSynced(UdonSyncMode.None)]
    private int MicHolderId = -1;
    //Indicator to give power state
    [Tooltip("Gameobject that will be enabled and disabled to indicate mic active status")]
    public GameObject PowerIndicator;
    public GameObject RadiusSphere;
    public Material RadiusSphereMaterial;
    private float RadiusSphereIntensity = 1f;
    public bool KeepSphereUpright = true;
    
    //Player list
    private VRCPlayerApi[] players = new VRCPlayerApi[0];


    private void Start() {
        Debug.Assert(PowerIndicator != null, "Power Indicator is set to null!");
        Debug.Assert(RadiusSphere != null, "Radius Sphere is set to null!");
        Debug.Assert(RadiusSphereMaterial != null, "Radius Sphere Material is set to null!");

        RadiusSphere.transform.localScale = Vector3.one * MuffleRange * 2;
        UpdateIndicators();
    }

    public void OnPickupExternal()
    {
        Networking.SetOwner(Networking.LocalPlayer, gameObject);
    }

    public void OnPickupUseDownExternal()
    {
        //Set user and power state
        poweredOn = true;
        MicHolderId = Networking.LocalPlayer.playerId;

        //Update indicator status
        UpdateIndicators();

        RequestSerialization();
    }

    public void OnPickupUseUpExternal()
    {
        //Set user and power state
        poweredOn = false;
        MicHolderId = -1;

        //Update indicator status
        UpdateIndicators();

        OnDeserialization();

        RequestSerialization();
    }

    public void OnDropExternal()
    {
        OnPickupUseUpExternal();
    }

    

    private void Update() {
        //Update the RadiusSphere
        if (RadiusSphere != null)
        {
            bool isEnabled = RadiusSphereIntensity > 0.0001f;
            //Disable is the intensity is zero
            RadiusSphere.SetActive(isEnabled);

            if (poweredOn)
                RadiusSphereIntensity += Time.deltaTime;
            else
                RadiusSphereIntensity -= Time.deltaTime;

            RadiusSphereIntensity = Mathf.Clamp01(RadiusSphereIntensity);

            RadiusSphereMaterial.SetFloat("_GridIntensity", RadiusSphereIntensity);

            if (KeepSphereUpright)
                RadiusSphere.transform.rotation = Quaternion.identity;
        }
            
        //Do not continue update if not powered on
        if (!poweredOn)
            return;

        

        //Validate player array
        if (players.Length != VRCPlayerApi.GetPlayerCount())
        {
           players = new VRCPlayerApi[VRCPlayerApi.GetPlayerCount()];
        }

        //Update player array
        players = VRCPlayerApi.GetPlayers(players);



        //Get distance from mic
        float radius = Vector3.Distance(gameObject.transform.position, Networking.LocalPlayer.GetPosition());

        //Get radius as a percentage
        //float desiredLoudness = Mathf.InverseLerp(0 , MuffleRange, radius);

        //Clamp radius to a 0-1 value
        //desiredLoudness = Mathf.Clamp01(radius);


        //Lower all volumes depending on radius to the mic
        foreach(VRCPlayerApi player in players)
        {
            if (player == null) continue;

            //DO NOT LOWER IF NOT IN SPHERE OF INFLUENCE
            //SET DEFAULT AND CANCEL IF NOT IN INFLUENCE
            if (radius > MuffleRange)
            {
                player.SetVoiceDistanceFar(DefaultVoiceDistnaceFar);
                player.SetVoiceDistanceNear(DefaultVoiceDistnaceNear);
                continue;
            }


            //Mic Holder Loud
            if (player.playerId == MicHolderId)
            {
                player.SetVoiceDistanceFar(1000);
                player.SetVoiceDistanceNear(DefaultVoiceDistnaceNear);
                Debug.Log("Loud" + player.displayName + player.playerId);
                continue;
            }


            //Others quiet
            player.SetVoiceDistanceFar(0);
            player.SetVoiceDistanceNear(0);
            Debug.Log("Quiet" + player.displayName + player.playerId);
        }
    }

    public override void OnDeserialization()
    {
        //Update indicator status
        UpdateIndicators();

        //Only run if powered off. Revert all to normal settings
        if (poweredOn)
            return;

        //***THE BELOW CODE ONLY RUNS IF THE MIC IS POWERED OFF, POWER ON UPDATES ARE HANDLED IN UPDATE()***//

        //Validate player array
        if (players.Length != VRCPlayerApi.GetPlayerCount())
        {
           players = new VRCPlayerApi[VRCPlayerApi.GetPlayerCount()];
        }

        //Update player array
        players = VRCPlayerApi.GetPlayers(players);

        foreach(VRCPlayerApi player in players)
        {
            player.SetVoiceDistanceNear(DefaultVoiceDistnaceNear);
            player.SetVoiceDistanceFar(DefaultVoiceDistnaceFar);
        }        
    }

    private void UpdateIndicators() {
        if (PowerIndicator != null)
            PowerIndicator.SetActive(poweredOn);
    }
}
