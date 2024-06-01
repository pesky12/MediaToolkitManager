
using UdonSharp;
using UnityEngine;
using UnityEngine.UI;
using VRC.SDKBase;
using VRC.Udon;

namespace PeskyBox.MediaToolkitManager
{
    [UdonBehaviourSyncMode(BehaviourSyncMode.Manual)]
    public class MediaToolkitManager : UdonSharpBehaviour
    {

        
        private void Start()
        {
            lightsStart();
            microphoneStart();
            cameraStart();
        }
        
        // CAMERA MANAGER
        #region CameraStuff
        public Toggle[] ActivateCameraToggles;
        public GameObject Cameras;
        public bool cameraActiveByDefault = false;
        
        private void cameraStart()
        {
            Cameras.SetActive(cameraActiveByDefault);
        }
        
        public void toggleCamera()
        {
            Cameras.SetActive(ActivateCameraToggles[0].isOn);
        }
        #endregion
        
        // MICROPHONE MANAGER
        #region MicrophoneStuff
        public Toggle[] ActivateMicrophoneToggles;
        public GameObject Microphone;
        public bool microphoneActiveByDefault = false;
        
        private void microphoneStart()
        {
            Microphone.SetActive(microphoneActiveByDefault);
        }
        
        public void toggleMicrophone()
        {
            Microphone.SetActive(ActivateMicrophoneToggles[0].isOn);
        }
        #endregion
        
        // LIGHTS MANAGER
        #region LightingStuff
        public Toggle[] ActivateLightsToggles;
        public Toggle[] ActivateLightOneToggles;
        public Toggle[] ActivateLightTwoToggles;
        public Toggle[] ActivateLightThreeToggles;
        public Toggle[] ActivateLightFourToggles;
        public Toggle[] positionSyncToggles;
        
        public GameObject[] LightObjects;
        
        public bool lightsActiveByDefault = false;
        public bool syncActiveByDefault = false;

        private bool areLightsSynced = false;
        private syncPositionManager[] lightPositionManager;

        

        private void lightsStart()
        {
            toggleAllLights(lightsActiveByDefault);
            foreach (var VARIABLE in lightPositionManager)
            {
                VARIABLE.sync(syncActiveByDefault);
            }
        }

        private void toggleAllLights(bool b)
        {
            foreach (var VARIABLE in LightObjects)
            {  
                VARIABLE.SetActive(b);
            }
        }
        
        private void toggleLights(int i, bool b)
        {
            LightObjects[i].SetActive(b);
        }

        
        // Hell of functions to call from toggles
        public void toggleLightOne()
        {
            toggleLights(0, ActivateLightOneToggles[0].isOn);
        }
        
        public void toggleLightTwo()
        {
            toggleLights(1, ActivateLightTwoToggles[0].isOn);
        }
        
        public void toggleLightThree()
        {
            toggleLights(2, ActivateLightThreeToggles[0].isOn);
        }
        
        public void toggleLightFour()
        {
            toggleLights(3, ActivateLightFourToggles[0].isOn);
        }

        public void lightSyncToggle()
        {
            areLightsSynced = !areLightsSynced;
            foreach (var VARIABLE in lightPositionManager)
            {
                VARIABLE.sync(areLightsSynced);
            }
        }
        #endregion
    }
}
