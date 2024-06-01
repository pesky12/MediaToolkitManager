
using System;
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
        
        private Collider localCollider;
        private Collider syncedCollider;

        private void Start()
        {
            sync(isSyncing);
            
            localCollider = localPickup.GetComponent<Collider>();
            syncedCollider = syncedPickup.GetComponent<Collider>();
        }

        public void sync(bool b)
        {
            if (b)
            {
                gameObject.transform.SetParent(syncedPickup.transform);
                
                localCollider.enabled = false;
                syncedCollider.enabled = true;
            }
            
            else
            {
                gameObject.transform.SetParent(localPickup.transform);
                
                localCollider.enabled = true;
                syncedCollider.enabled = false;
            }
            
            gameObject.transform.localPosition = Vector3.zero;
        }
    }

}