
using UdonSharp;
using Unity.Mathematics;
using UnityEditor;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

namespace PJKT
{
    public class UserLightControls : UdonSharpBehaviour
    {
        //----------Scene references----------//
        [SerializeField] public Light UserLight;
        [SerializeField] public Transform LightRig;
        [Space]
        [SerializeField] public MeshRenderer PointMesh;
        [SerializeField] public MeshRenderer SpotMesh;
        [SerializeField] public MeshRenderer MenuHandle;
        [Space]
        [SerializeField] public UnityEngine.UI.Toggle LightToggle;
        [SerializeField] public UnityEngine.UI.Toggle PointToggle;
        [SerializeField] public UnityEngine.UI.Toggle SpotToggle;
        [SerializeField] public UnityEngine.UI.Toggle DirectionalToggle;
        [SerializeField] public UnityEngine.UI.Slider RangeSlider;
        [SerializeField] public UnityEngine.UI.Slider SpotAngleSlider;
        [SerializeField] public UnityEngine.UI.Slider SaturationSlider;
        [SerializeField] public UnityEngine.UI.Slider HueSlider;
        [SerializeField] public UnityEngine.UI.Slider IntensitySlider;
        [SerializeField] public UnityEngine.UI.Toggle ShadowOffToggle;
        [SerializeField] public UnityEngine.UI.Toggle ShadowHardToggle;
        [SerializeField] public UnityEngine.UI.Toggle ShadowSoftToggle;
        [SerializeField] public UnityEngine.UI.Toggle RenderModeAutoToggle;
        [SerializeField] public UnityEngine.UI.Toggle RenderModeImportantToggle;
        [SerializeField] public UnityEngine.UI.Toggle RenderModeNotImportantToggle;
        [SerializeField] public UnityEngine.UI.Toggle CullingMaskPlayersToggle;
        [SerializeField] public UnityEngine.UI.Toggle CullingMaskWorldToggle;
        [SerializeField] public UnityEngine.UI.Toggle ShowInCameraToggle;
        [SerializeField] public UnityEngine.UI.Toggle WorldLockToggle;
        [Space]
        

        //----------Configuration----------//
        //Layer picker
        [SerializeField] private int LayerIndexUI = 5;
        [SerializeField] private int LayerIndexDefault = 13;
        [Space]


        //----------Networked variables----------//
        [UdonSynced(UdonSyncMode.None), HideInInspector] public bool lightEnabled;
        [UdonSynced(UdonSyncMode.None), HideInInspector] public byte lightMode;
        [UdonSynced(UdonSyncMode.None), HideInInspector] public float lightRange;
        [UdonSynced(UdonSyncMode.None), HideInInspector] public float lightSpotAngle;
        [UdonSynced(UdonSyncMode.None), HideInInspector] public Color lightColor;
        [UdonSynced(UdonSyncMode.None), HideInInspector] public float lightIntensity;
        [UdonSynced(UdonSyncMode.None), HideInInspector] public int lightShadowType;
        [UdonSynced(UdonSyncMode.None), HideInInspector] public int lightRenderMode;
        [UdonSynced(UdonSyncMode.None), HideInInspector] public int lightCullingMask;
        [UdonSynced(UdonSyncMode.None), HideInInspector] public bool showInCamera;
        [UdonSynced(UdonSyncMode.None), HideInInspector] public bool lightRigLockedInWorld;
        [UdonSynced(UdonSyncMode.None), HideInInspector] public Vector3 worldLockedPos;
        [UdonSynced(UdonSyncMode.None), HideInInspector] public Quaternion worldLockedRot;


        //----------Runtime variables----------//
        private bool dirty = false;
        private int worldCullingMask;
        private int playerCullingMask;


        private void Start() {
            //Have to do this for some reason
            SendCustomEventDelayedSeconds(nameof(_LateStart), 1f);

            //Player is layers 9 and 10
            playerCullingMask = 1 << 9 | 1 << 10;
            //World is everything except 9 and 10
            worldCullingMask = ~playerCullingMask;

            //Read the data from the light and write it to the UI
            OnPreSerialization();
            OnDeserialization();
        }

        public void _LateStart()
        {
            MenuHandle.enabled = WorldLockToggle.isOn;
            _UpdateColor();
        }

        public void _Serialize() => dirty = true;
        
        public void _Point() {
            SpotMesh.enabled = false;
            PointMesh.enabled = true;
            UserLight.type = LightType.Point;
            PointToggle.SetIsOnWithoutNotify(true);
            SpotToggle.SetIsOnWithoutNotify(false);
            DirectionalToggle.SetIsOnWithoutNotify(false);
        }
        public void _Spot() {
            SpotMesh.enabled = true;
            PointMesh.enabled = false;
            UserLight.type = LightType.Spot;
            PointToggle.SetIsOnWithoutNotify(false);
            SpotToggle.SetIsOnWithoutNotify(true);
            DirectionalToggle.SetIsOnWithoutNotify(false);
        }
        public void _Directional() {
            UserLight.type = LightType.Directional;
            PointToggle.SetIsOnWithoutNotify(false);
            SpotToggle.SetIsOnWithoutNotify(false);
            DirectionalToggle.SetIsOnWithoutNotify(true);
        }

        public void _UpdateColor()
        {
            Color newColor = Color.HSVToRGB(HueSlider.value, SaturationSlider.value, 1f);
            UserLight.color = newColor;
            _UpdateMeshColor();
        } 

        public void _ShadowOff() {
            UserLight.shadows = LightShadows.None;
            ShadowOffToggle.SetIsOnWithoutNotify(true);
            ShadowHardToggle.SetIsOnWithoutNotify(false);
            ShadowSoftToggle.SetIsOnWithoutNotify(false);
        }
        public void _ShadowHard() {
            UserLight.shadows = LightShadows.Hard;
            ShadowOffToggle.SetIsOnWithoutNotify(false);
            ShadowHardToggle.SetIsOnWithoutNotify(true);
            ShadowSoftToggle.SetIsOnWithoutNotify(false);
        }
        public void _ShadowSoft() {
            UserLight.shadows = LightShadows.Soft;
            ShadowOffToggle.SetIsOnWithoutNotify(false);
            ShadowHardToggle.SetIsOnWithoutNotify(false);
            ShadowSoftToggle.SetIsOnWithoutNotify(true);
        }

        public void _RenderModeAuto() {
            UserLight.renderMode = LightRenderMode.Auto;
            RenderModeAutoToggle.SetIsOnWithoutNotify(true);
            RenderModeImportantToggle.SetIsOnWithoutNotify(false);
            RenderModeNotImportantToggle.SetIsOnWithoutNotify(false);
        }
        public void _RenderModeImportant() {
            UserLight.renderMode = LightRenderMode.ForcePixel;
            RenderModeAutoToggle.SetIsOnWithoutNotify(false);
            RenderModeImportantToggle.SetIsOnWithoutNotify(true);
            RenderModeNotImportantToggle.SetIsOnWithoutNotify(false);
        }
        public void _RenderModeNotImportant() {
            UserLight.renderMode = LightRenderMode.ForceVertex;
            RenderModeAutoToggle.SetIsOnWithoutNotify(false);
            RenderModeImportantToggle.SetIsOnWithoutNotify(false);
            RenderModeNotImportantToggle.SetIsOnWithoutNotify(true);
        }

        public void _UpdateCulling()
        {
            UserLight.cullingMask = (CullingMaskPlayersToggle.isOn ? playerCullingMask : 0) | (CullingMaskWorldToggle.isOn ? worldCullingMask : 0);
        }

        public void _UpdateMeshColor()
        {
            SpotMesh.enabled = UserLight.type == LightType.Spot;
            PointMesh.enabled = UserLight.type == LightType.Point;

            Color newColor = UserLight.enabled ? UserLight.color * UserLight.intensity : Color.black;

            MaterialPropertyBlock block = new MaterialPropertyBlock();
            PointMesh.GetPropertyBlock(block);
            block.SetColor("_EmissionColor", newColor);
            PointMesh.SetPropertyBlock(block);

            MaterialPropertyBlock block2 = new MaterialPropertyBlock();
            SpotMesh.GetPropertyBlock(block2);
            block2.SetColor("_EmissionColor", newColor);
            SpotMesh.SetPropertyBlock(block2);

            MaterialPropertyBlock block3 = new MaterialPropertyBlock();
            MenuHandle.GetPropertyBlock(block3);
            block3.SetColor("_EmissionColor", newColor);
            MenuHandle.SetPropertyBlock(block3);
        }

        public void _UpdateShowInCamera()
        {
            SpotMesh.gameObject.layer = ShowInCameraToggle.isOn ? LayerIndexDefault : LayerIndexUI;
        }

        public void _UpdateWorldLock()
        {
            if (WorldLockToggle.isOn)
            {
                LightRig.SetParent(null);
                MenuHandle.enabled = true;
            }
            else
            {
                LightRig.SetParent(transform);
                LightRig.localPosition = Vector3.zero;
                LightRig.localRotation = Quaternion.identity;
                MenuHandle.enabled = false;
            }
        }

        private void Update()
        {
            if (dirty && !Networking.IsClogged) {
                dirty = false;
                if (!Networking.IsOwner(gameObject)) Networking.SetOwner(Networking.LocalPlayer, gameObject);
                Debug.Log("Serializing light " + UserLight.name + " on " + gameObject.name);
                RequestSerialization();
            }
        }


        public override void OnPreSerialization()
        {
            base.OnPreSerialization();

            //Serialize the light's properties
            lightEnabled = UserLight.enabled;
            lightMode = (byte)UserLight.type;
            lightRange = UserLight.range;
            lightSpotAngle = UserLight.spotAngle;
            lightColor = UserLight.color;
            lightIntensity = UserLight.intensity;
            lightShadowType = (int)UserLight.shadows;
            lightRenderMode = (int)UserLight.renderMode;
            lightCullingMask = UserLight.cullingMask;

            //Serialize whether or not the mesh is visible in the camera
            showInCamera = SpotMesh.gameObject.layer == LayerIndexDefault;

            //Serialize whether or not the light rig is locked in the world
            lightRigLockedInWorld = LightRig.parent == null;
            worldLockedPos = LightRig.position;
            worldLockedRot = LightRig.rotation;
        }

        public override void OnDeserialization()
        {
            base.OnDeserialization();
            UserLight.enabled = lightEnabled;
            UserLight.type = (LightType)lightMode;
            UserLight.range = lightRange;
            UserLight.spotAngle = lightSpotAngle;
            UserLight.color = lightColor;
            UserLight.intensity = lightIntensity;
            UserLight.shadows = (LightShadows)lightShadowType;
            UserLight.renderMode = (LightRenderMode)lightRenderMode;
            UserLight.cullingMask = lightCullingMask;

            LightToggle.SetIsOnWithoutNotify(lightEnabled);
            PointToggle.SetIsOnWithoutNotify(UserLight.type == LightType.Point);
            SpotToggle.SetIsOnWithoutNotify(UserLight.type == LightType.Spot);
            DirectionalToggle.SetIsOnWithoutNotify(UserLight.type == LightType.Directional);
            RangeSlider.SetValueWithoutNotify(lightRange);
            SpotAngleSlider.SetValueWithoutNotify(lightSpotAngle);
            Color.RGBToHSV(lightColor, out float hue, out float saturation, out float value);
            const float colorTolerance = 0.01f;
            if (SaturationSlider.value < saturation - colorTolerance || SaturationSlider.value > saturation + colorTolerance)
                SaturationSlider.SetValueWithoutNotify(saturation);
            if (HueSlider.value < hue - colorTolerance || HueSlider.value > hue + colorTolerance)
                HueSlider.SetValueWithoutNotify(hue);
            IntensitySlider.SetValueWithoutNotify(lightIntensity);
            ShadowOffToggle.SetIsOnWithoutNotify(UserLight.shadows == LightShadows.None);
            ShadowHardToggle.SetIsOnWithoutNotify(UserLight.shadows == LightShadows.Hard);
            ShadowSoftToggle.SetIsOnWithoutNotify(UserLight.shadows == LightShadows.Soft);
            RenderModeAutoToggle.SetIsOnWithoutNotify(UserLight.renderMode == LightRenderMode.Auto);
            RenderModeImportantToggle.SetIsOnWithoutNotify(UserLight.renderMode == LightRenderMode.ForcePixel);
            RenderModeNotImportantToggle.SetIsOnWithoutNotify(UserLight.renderMode == LightRenderMode.ForceVertex);
            CullingMaskPlayersToggle.SetIsOnWithoutNotify((UserLight.cullingMask & playerCullingMask) != 0);
            CullingMaskWorldToggle.SetIsOnWithoutNotify((UserLight.cullingMask & worldCullingMask) != 0);

            //Preview mesh
            SpotMesh.enabled = UserLight.type == LightType.Spot;
            PointMesh.enabled = UserLight.type == LightType.Point;
            _UpdateMeshColor();

            //Show in camera
            ShowInCameraToggle.SetIsOnWithoutNotify(showInCamera);
            SpotMesh.gameObject.layer = showInCamera ? LayerIndexDefault : LayerIndexUI;
            PointMesh.gameObject.layer = showInCamera ? LayerIndexDefault : LayerIndexUI;

            //World lock
            WorldLockToggle.SetIsOnWithoutNotify(lightRigLockedInWorld);
            if (lightRigLockedInWorld)
            {
                if (LightRig.parent != null) LightRig.SetParent(null);
                LightRig.position = worldLockedPos;
                LightRig.rotation = worldLockedRot;
                MenuHandle.enabled = true;
            }
            else
            {
                if (LightRig.parent != transform) LightRig.SetParent(transform);
                LightRig.localPosition = Vector3.zero;
                LightRig.localRotation = Quaternion.identity;
                MenuHandle.enabled = false;
            }
        }
    }
}