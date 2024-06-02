using UdonSharp;
using UnityEngine;
using UnityEngine.UI;
using VRC.SDK3.Components;
using VRC.SDKBase;
using VRC.Udon;

namespace PJKT
{
    public class UserLightControlReceiver : UdonSharpBehaviour
    {
        [SerializeField, UdonSynced(UdonSyncMode.None)] private bool UIEnabled = false;

        [SerializeField] private GameObject canvas;

        private void Start() {
            OnDeserialization();
        }

        public override void OnPickupUseDown()
        {
            if (!Networking.IsOwner(gameObject)) Networking.SetOwner(Networking.LocalPlayer, gameObject);
            UIEnabled = !UIEnabled;
            RequestSerialization();
            OnDeserialization();
        }

        public override void OnDeserialization()
        {
            base.OnDeserialization();
            canvas.SetActive(UIEnabled);
        }
    }
}