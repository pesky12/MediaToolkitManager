// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Chanoler/SpotlightVolume"
{
	Properties
	{
		_Distance("Distance", Float) = 2
		_Multiplier("Multiplier", Float) = 1
		_ObjectLength("ObjectLength", Float) = 2
		_LengthFalloff("Length Falloff", Float) = 2
		_WidthFalloff("Width Falloff", Float) = 2
		_Color("Color", Color) = (1,1,1,0)
		_Normal("Normal", 2D) = "bump" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Overlay"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		Blend One One
		
		CGPROGRAM
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow 
		struct Input
		{
			float4 screenPos;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
			half ASEVFace : VFACE;
		};

		uniform float4 _Color;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Distance;
		uniform float _ObjectLength;
		uniform float _LengthFalloff;
		uniform float _Multiplier;
		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform float _WidthFalloff;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Normal = float3(0,0,1);
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth16 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth16 = abs( ( screenDepth16 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _Distance ) );
			float3 ase_worldPos = i.worldPos;
			float3 worldToObj25 = mul( unity_WorldToObject, float4( ase_worldPos, 1 ) ).xyz;
			float clampResult29 = clamp( ( distanceDepth16 * pow( ( 1.0 - ( worldToObj25.y / _ObjectLength ) ) , _LengthFalloff ) * _Multiplier ) , 0.0 , 1.0 );
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult49 = dot( (WorldNormalVector( i , UnpackNormal( tex2D( _Normal, uv_Normal ) ) )) , ase_worldViewDir );
			float4 temp_cast_0 = (0.0).xxxx;
			float4 temp_cast_1 = (1024.0).xxxx;
			float4 clampResult50 = clamp( ( _Color * clampResult29 * pow( dotResult49 , _WidthFalloff ) ) , temp_cast_0 , temp_cast_1 );
			float4 switchResult17 = (((i.ASEVFace>0)?(clampResult50):(float4( 0,0,0,0 ))));
			o.Emission = switchResult17.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
1343;73;1215;1010;811.8599;169.6191;1.303142;True;False
Node;AmplifyShaderEditor.CommentaryNode;35;-1846.282,231.4073;Inherit;False;888.1445;358.8447;Fade over distance;5;24;32;25;33;27;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;24;-1796.282,287.3609;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformPositionNode;25;-1554.569,281.4074;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;32;-1534.564,475.2521;Inherit;False;Property;_ObjectLength;ObjectLength;3;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;40;-944.4919,255.7822;Inherit;False;245.3377;316.137;Adjust Falloff;2;39;38;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;33;-1287.414,335.1779;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;46;-470.576,360.0634;Inherit;False;476.999;396.6;Traditional nDotV to fake thickness;3;49;48;47;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-875.1542,456.9192;Inherit;False;Property;_LengthFalloff;Length Falloff;4;0;Create;True;0;0;0;False;0;False;2;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;58;-932.9703,685.7028;Inherit;True;Property;_Normal;Normal;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;27;-1145.137,323.6978;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-712.9551,25.3514;Inherit;False;Property;_Distance;Distance;1;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;48;-344.2763,567.6633;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;31;-56.07043,169.3544;Inherit;False;Property;_Multiplier;Multiplier;2;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;38;-894.4919,305.7822;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;52;88.22312,449.3995;Inherit;False;245.3377;316.137;Adjust Falloff;2;54;53;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DepthFade;16;-455.3784,7.490133;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;47;-420.5761,410.0631;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;49;-152.5769,528.063;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-59.41069,9.71146;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;200.6487,127.1186;Inherit;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;157.5608,650.5366;Inherit;False;Property;_WidthFalloff;Width Falloff;5;0;Create;True;0;0;0;False;0;False;2;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;29;199.1967,9.319519;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;45;102.5605,-273.9721;Inherit;False;Property;_Color;Color;6;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;54;138.2231,499.3995;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;517.5475,335.6244;Inherit;False;Constant;_FinalClampMin;FinalClampMin;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;521.4337,419.705;Inherit;False;Constant;_FinalClampMax;FinalClampMax;2;0;Create;True;0;0;0;False;0;False;1024;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;507.3183,-11.0396;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;50;706.0955,153.8253;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SwitchByFaceNode;17;886.7643,0.4862404;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1184.129,-40.94875;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Chanoler/SpotlightVolume;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Overlay;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;4;1;False;-1;1;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;0;24;0
WireConnection;33;0;25;2
WireConnection;33;1;32;0
WireConnection;27;0;33;0
WireConnection;38;0;27;0
WireConnection;38;1;39;0
WireConnection;16;0;18;0
WireConnection;47;0;58;0
WireConnection;49;0;47;0
WireConnection;49;1;48;0
WireConnection;26;0;16;0
WireConnection;26;1;38;0
WireConnection;26;2;31;0
WireConnection;29;0;26;0
WireConnection;29;1;30;0
WireConnection;54;0;49;0
WireConnection;54;1;53;0
WireConnection;44;0;45;0
WireConnection;44;1;29;0
WireConnection;44;2;54;0
WireConnection;50;0;44;0
WireConnection;50;1;51;0
WireConnection;50;2;55;0
WireConnection;17;0;50;0
WireConnection;0;2;17;0
ASEEND*/
//CHKSM=7233F09FE2026216CD078324A246EB6012F61E04