
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

namespace PeskyBox.MediaToolkitManager
{
    [UdonBehaviourSyncMode(BehaviourSyncMode.None)]
    public class syncPositionManager : UdonSharpBehaviour
    {
        [HideInInspector]
        public bool isSyncing;

        public VRC_Pickup syncedPickup;
        public VRC_Pickup localPickup;

        
        public void sync(bool b)
        {
            if (b)
            {
                gameObject.transform.SetParent(syncedPickup.transform);
            }
            
            else
            {
                gameObject.transform.SetParent(localPickup.transform);
            }
            
            gameObject.transform.localPosition = Vector3.zero;
        }
    }

}