
using System;
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

namespace PeskyBox.MediaToolkitManager
{
    
        [UdonBehaviourSyncMode(BehaviourSyncMode.Continuous)]

    public class MicPickup : UdonSharpBehaviour
    {
        public MicScript micScript;
        
        private bool resetByDistance = false;
        public float resetDistance = 8f;
        public Vector3 resetPosition = new Vector3(0, 0, 0);

        private VRC_Pickup thisPickup;

        //--------------------THIS CODE IS A PUBLIC VARABLE, AS SUCH THIS SETTING CAN DIFFER DEPENDING ON THE SETTINGS IN THE SCENE FILE--------------------

        //--------------------THIS CODE IS A PUBLIC VARABLE, AS SUCH THIS SETTING CAN DIFFER DEPENDING ON THE SETTINGS IN THE SCENE FILE--------------------

        private void Start()
        {
            Debug.Assert(micScript != null, "You forgot to set the mic script on the pickup");
            thisPickup = (VRC_Pickup)GetComponent(typeof(VRC_Pickup));
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

        private void Update()
        {
            if (resetByDistance)
            {
                if (Vector3.Distance(Networking.LocalPlayer.GetPosition(), resetPosition) > resetDistance)
                {
                    thisPickup.Drop();
                    thisPickup.transform.position = resetPosition;
                }
            }
        }
        
        public void SetResetByDistance(bool b)
        {
            resetByDistance = b;
        }

        private bool validatePlayer()
        {
            // string localPlayerName = Networking.LocalPlayer.displayName;

            return true;
        }
    }

}