
using UdonSharp;
using UnityEditor;
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

        public Toggle[] cameraTogglesUI;
        public GameObject Cameras;
        public bool cameraActiveByDefault = false;

        private void cameraStart()
        {
            Cameras.SetActive(cameraActiveByDefault);
        }

        public void toggleCamera()
        {
            Cameras.SetActive(cameraTogglesUI[0].isOn);
        }

        #endregion

        // MICROPHONE MANAGER

        #region MicrophoneStuff

        public Toggle[] ActivateMicrophoneToggles;
        public GameObject Microphone;
        public bool microphoneActiveByDefault = false;

        public MicPickup micPickup;

        private void microphoneStart()
        {
            Microphone.SetActive(microphoneActiveByDefault);
        }

        public void toggleMicrophone()
        {
            Microphone.SetActive(ActivateMicrophoneToggles[0].isOn);
        }

        public void toggleMicDistanceCheck()
        {
            micPickup.SetResetByDistance(cameraTogglesUI[0].isOn);
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
            // Warn if light is null
            if (LightObjects[0] == null)
            {
                Debug.LogError("Light 1 is null, either assign a light or remove the toggle");
                return;
            }

            toggleLights(0, ActivateLightOneToggles[0].isOn);
        }

        public void toggleLightTwo()
        {
            // Warn if light is null
            if (LightObjects[1] == null)
            {
                Debug.LogError("Light 2 is null, either assign a light or remove the toggle");
                return;
            }

            toggleLights(1, ActivateLightTwoToggles[0].isOn);
        }

        public void toggleLightThree()
        {
            // Warn if light is null
            if (LightObjects[2] == null)
            {
                Debug.LogError("Light 3 is null, either assign a light or remove the toggle");
                return;
            }

            toggleLights(2, ActivateLightThreeToggles[0].isOn);
        }

        public void toggleLightFour()
        {
            // Warn if light is null
            if (LightObjects[3] == null)
            {
                Debug.LogError("Light 4 is null, either assign a light or remove the toggle");
                return;
            }

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

#if UNITY_EDITOR && !COMPILER_UDONSHARP
    [CustomEditor(typeof(MediaToolkitManager))]
    public class MediaToolkitManagerEditor : Editor
    {
        enum settingModes
        {
            Normal,
            Advanced
        }
        private bool lightsShowToggleUI = false;
        private bool showExtraStats = false;
        
        private bool showLightToggleUISelection = false;
        
        public override void OnInspectorGUI()
        {
            // Draw the default inspector
            // base.OnInspectorGUI();
            
            MediaToolkitManager mediaToolkitManager = (MediaToolkitManager)target;
            
            // Fancy title
            EditorGUILayout.LabelField("Media Toolkit Manager", EditorStyles.boldLabel);
            
            // Info section
            EditorGUILayout.HelpBox("This script is used to manage the Media Toolkit.", MessageType.Info);
            
            // Camera section
            EditorGUILayout.LabelField("Camera Manager", EditorStyles.boldLabel);
            mediaToolkitManager.Cameras = (GameObject)EditorGUILayout.ObjectField("Camera System", mediaToolkitManager.Cameras, typeof(GameObject), true);
            mediaToolkitManager.cameraActiveByDefault = EditorGUILayout.Toggle("Camera Active by Default", mediaToolkitManager.cameraActiveByDefault);
            
            EditorGUILayout.Space(15);
            
            // Microphone section
            EditorGUILayout.LabelField("Microphone Manager", EditorStyles.boldLabel);
            mediaToolkitManager.Microphone = (GameObject)EditorGUILayout.ObjectField("Microphone System", mediaToolkitManager.Microphone, typeof(GameObject), true);
            mediaToolkitManager.micPickup = (MicPickup)EditorGUILayout.ObjectField("Mic Pickup", mediaToolkitManager.micPickup, typeof(MicPickup), true);
            mediaToolkitManager.microphoneActiveByDefault = EditorGUILayout.Toggle("Microphone Active by Default", mediaToolkitManager.microphoneActiveByDefault);
            
            EditorGUILayout.Space(15);
            
            // Lights section
            EditorGUILayout.LabelField("Lights Manager", EditorStyles.boldLabel);
            mediaToolkitManager.lightsActiveByDefault = EditorGUILayout.Toggle("Lights Active by Default", mediaToolkitManager.lightsActiveByDefault);
            mediaToolkitManager.syncActiveByDefault = EditorGUILayout.Toggle("Sync Active by Default", mediaToolkitManager.syncActiveByDefault);
            
            showLightToggleUISelection = EditorGUILayout.Foldout(showLightToggleUISelection, "Light Toggle UI");
            if (showLightToggleUISelection)
            {
                EditorGUILayout.PropertyField(serializedObject.FindProperty("ActivateLightsToggles"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("ActivateLightOneToggles"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("ActivateLightTwoToggles"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("ActivateLightThreeToggles"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("ActivateLightFourToggles"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("positionSyncToggles"));
            }
            
            
            // Text with numbers of all toggles
            showExtraStats = EditorGUILayout.Foldout(showExtraStats, "Extra Stats");
            if (showExtraStats)
            {

                EditorGUILayout.LabelField("Found Toggles", EditorStyles.boldLabel);
                EditorGUILayout.LabelField($"Found `Activate light` buttons: {mediaToolkitManager.ActivateLightsToggles.Length}");
                EditorGUILayout.LabelField($"Found `Light 1` buttons: {mediaToolkitManager.ActivateLightOneToggles.Length}");
                EditorGUILayout.LabelField($"Found `Light 2` buttons: {mediaToolkitManager.ActivateLightTwoToggles.Length}");
                EditorGUILayout.LabelField($"Found `Light 3` buttons: {mediaToolkitManager.ActivateLightThreeToggles.Length}");
                EditorGUILayout.LabelField($"Found `Light 4` buttons: {mediaToolkitManager.ActivateLightFourToggles.Length}");
                EditorGUILayout.LabelField($"Found `Position Sync` buttons: {mediaToolkitManager.positionSyncToggles.Length}");
            
                EditorGUILayout.LabelField($"Found `Activate Microphone` buttons: {mediaToolkitManager.ActivateMicrophoneToggles.Length}");
                EditorGUILayout.LabelField($"Found `Activate Camera` buttons: {mediaToolkitManager.cameraTogglesUI.Length}");
                EditorGUILayout.LabelField($"Found `Mic Distance Check` buttons: {mediaToolkitManager.cameraTogglesUI.Length}");
                EditorGUILayout.LabelField($"Found `Mic Reset` buttons: {mediaToolkitManager.cameraTogglesUI.Length}");
                
            }
            
            
            
            
            // Apply changes
            serializedObject.ApplyModifiedProperties();
            
        }
    }
    #endif
}