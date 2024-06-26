// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Chanoler/MicBubble"
{
	Properties
	{
		_Color("Color", Color) = (0.9811321,1,0,0)
		_DepthRange("Depth Range", Float) = 0
		_EdgeGain("Edge Gain", Float) = 0
		_Intensity("Intensity", Float) = 0
		_EdgeContrast("Edge Contrast", Float) = 0.54
		_GridTile("Grid Tile", Float) = 0
		_GridSize("Grid Size", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend One One
		
		CGPROGRAM
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform float4 _Color;
		uniform float _Intensity;
		uniform float _EdgeGain;
		uniform float _EdgeContrast;
		uniform float _DepthRange;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _GridTile;
		uniform float _GridSize;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 temp_cast_0 = (-0.5).xx;
			float2 uv_TexCoord48 = i.uv_texcoord + temp_cast_0;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth37 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth37 = abs( ( screenDepth37 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 1.0 ) );
			float lerpResult38 = lerp( 0.0 , _DepthRange , distanceDepth37);
			float temp_output_46_0 = ( (0.0 + (pow( length( uv_TexCoord48 ) , _EdgeGain ) - 0.0) * (1.0 - 0.0) / (_EdgeContrast - 0.0)) + saturate( ( 1.0 - lerpResult38 ) ) );
			o.Emission = ( _Color * _Intensity * temp_output_46_0 ).rgb;
			float2 temp_cast_2 = (_GridTile).xx;
			float temp_output_2_0_g1 = _GridSize;
			float2 appendResult10_g2 = (float2(temp_output_2_0_g1 , temp_output_2_0_g1));
			float2 temp_output_11_0_g2 = ( abs( (frac( (i.uv_texcoord*temp_cast_2 + float2( 0,0 )) )*2.0 + -1.0) ) - appendResult10_g2 );
			float2 break16_g2 = ( 1.0 - ( temp_output_11_0_g2 / fwidth( temp_output_11_0_g2 ) ) );
			o.Alpha = ( temp_output_46_0 * ( 1.0 - ( 0.4 * saturate( min( break16_g2.x , break16_g2.y ) ) ) ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
1364;73;1194;1010;1228.955;494.4223;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;50;-2129.534,42.37154;Inherit;False;Constant;_Float1;Float 1;4;0;Create;True;0;0;0;False;0;False;-0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-1580.33,391.9267;Inherit;False;Property;_DepthRange;Depth Range;2;0;Create;True;0;0;0;False;0;False;0;4.92;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;48;-1935.298,-2.353554;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;40;-1570.774,311.3916;Inherit;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;37;-1655.405,479.2863;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-1697.431,97.36664;Inherit;False;Property;_EdgeGain;Edge Gain;3;0;Create;True;0;0;0;False;0;False;0;3.41;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;49;-1690.258,-1.233452;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-1191.779,780.7765;Inherit;False;Property;_GridSize;Grid Size;7;0;Create;True;0;0;0;False;0;False;0;0.86;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-1200.558,616.4779;Inherit;False;Property;_GridTile;Grid Tile;6;0;Create;True;0;0;0;False;0;False;0;71.58;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;38;-1274.57,371.4513;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;52;-1503.61,-0.643364;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;62;-970.9201,611.0494;Inherit;False;Grid;-1;;1;a9240ca2be7e49e4f9fa3de380c0dbe9;0;3;5;FLOAT2;8,8;False;6;FLOAT2;0,0;False;2;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;41;-1106.711,371.2659;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-1379.296,238.9564;Inherit;False;Property;_EdgeContrast;Edge Contrast;5;0;Create;True;0;0;0;False;0;False;0.54;0.42;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-1013.684,498.5841;Inherit;False;Constant;_Float2;Float 2;7;0;Create;True;0;0;0;False;0;False;0.4;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-777.8965,476.0088;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;43;-936.2779,369.8563;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;56;-1137.617,-2.723549;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;14;-944.4565,-340.8093;Inherit;False;Property;_Color;Color;1;0;Create;True;0;0;0;False;0;False;0.9811321,1,0,0;0.9811321,0.6350405,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;59;-889.6507,-149.9966;Inherit;False;Property;_Intensity;Intensity;4;0;Create;True;0;0;0;False;0;False;0;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;46;-811.4735,163.3383;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;67;-673.7988,384.4531;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-525.8045,175.0036;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-683.571,-223.9166;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-599.802,-59.52963;Inherit;False;Property;_Float3;Float 3;8;0;Create;True;0;0;0;False;0;False;0;0.91;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-165.6964,-52.26406;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Chanoler/MicBubble;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;False;Transparent;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;5;False;4;1;False;-1;1;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;6.28;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.3;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;48;1;50;0
WireConnection;49;0;48;0
WireConnection;38;0;40;0
WireConnection;38;1;39;0
WireConnection;38;2;37;0
WireConnection;52;0;49;0
WireConnection;52;1;53;0
WireConnection;62;5;63;0
WireConnection;62;2;64;0
WireConnection;41;0;38;0
WireConnection;69;0;70;0
WireConnection;69;1;62;0
WireConnection;43;0;41;0
WireConnection;56;0;52;0
WireConnection;56;2;57;0
WireConnection;46;0;56;0
WireConnection;46;1;43;0
WireConnection;67;0;69;0
WireConnection;71;0;46;0
WireConnection;71;1;67;0
WireConnection;58;0;14;0
WireConnection;58;1;59;0
WireConnection;58;2;46;0
WireConnection;0;2;58;0
WireConnection;0;9;71;0
ASEEND*/
//CHKSM=6512A879902C8D2B3D35EF7D9E20FF2E5D1A75BC