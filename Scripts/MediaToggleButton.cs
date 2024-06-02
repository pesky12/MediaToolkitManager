using UnityEditor;
using UnityEngine;
using VRC.SDKBase;

namespace PeskyBox.MediaToolkitManager
{
    public enum MediaToolkitManagerType
    {
        Lights,
        Microphone,
        Camera
    }

    public enum LightOption
    {
        LightOne,
        LightTwo,
        LightThree,
        LightFour,
        Toggle,
    }
    
    public enum MicrophoneOption
    {
        Toggle,
        DistanceCheck,
        Reset
    }
    
    public enum CameraOption
    {
        Toggle,
        Reset
    }
    
    public class MediaToggleButton : MonoBehaviour, IEditorOnly
    {
        public MediaToolkitManagerType managerType;
        public int optionIndex;
    }
    
    [CustomEditor(typeof(MediaToggleButton))]
    public class MediaToggleButtonEditor : Editor
    {
        public override void OnInspectorGUI()
        {
            MediaToggleButton mediaToggleButton = (MediaToggleButton)target;
            
            // Fancy title
            EditorGUILayout.LabelField("Media Toolkit Button Assigner", EditorStyles.boldLabel);
            
            // Info section
            EditorGUILayout.HelpBox("This script is used to automatically detect toggles in the Media Toolkit Manager.", MessageType.Info);
            
            // Manager type
            mediaToggleButton.managerType = (MediaToolkitManagerType)EditorGUILayout.EnumPopup("Manager Type", mediaToggleButton.managerType);
            
            // Set the option index based on the manager type
            switch (mediaToggleButton.managerType)
            {
                case MediaToolkitManagerType.Lights:
                    mediaToggleButton.optionIndex = (int)(LightOption)EditorGUILayout.EnumPopup("Option", (LightOption)mediaToggleButton.optionIndex);
                    break;
                case MediaToolkitManagerType.Microphone:
                    mediaToggleButton.optionIndex = (int)(MicrophoneOption)EditorGUILayout.EnumPopup("Option", (MicrophoneOption)mediaToggleButton.optionIndex);
                    break;
                case MediaToolkitManagerType.Camera:
                    mediaToggleButton.optionIndex = (int)(CameraOption)EditorGUILayout.EnumPopup("Option", (CameraOption)mediaToggleButton.optionIndex);
                    break;
            }
        }
    }
}
