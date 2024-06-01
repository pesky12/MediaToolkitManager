// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Chanoler/MicBubble2"
{
	Properties
	{
		_GridFalloff("Grid Falloff", Float) = 23
		_GridIntensity("GridIntensity", Float) = 1
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_GridDensity("GridDensity", Float) = 1
		[HDR]_GridColor("Grid Color", Color) = (0.5,0.2193396,0.4638,1)
		_Texture0("Texture 0", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow exclude_path:deferred noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog 
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
		};

		uniform float4 _GridColor;
		uniform sampler2D _Texture0;
		uniform float _GridDensity;
		uniform float _GridFalloff;
		uniform float _GridIntensity;
		uniform float _Cutoff = 0.5;


		inline float4 TriplanarSampling69( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = tex2D( topTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
			yNorm = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			zNorm = tex2D( topTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
		}


		float2 voronoihash78( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi78( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash78( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return F1;
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Normal = float3(0,0,1);
			float2 temp_cast_0 = (_GridDensity).xx;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float4 triplanar69 = TriplanarSampling69( _Texture0, ase_worldPos, ase_worldNormal, _GridFalloff, temp_cast_0, 1.0, 0 );
			float4 clampResult82 = clamp( triplanar69 , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			float4 triplanarColor75 = clampResult82;
			float mulTime80 = _Time.y * 0.1;
			float time78 = ( mulTime80 * 5.0 );
			float2 coords78 = i.uv_texcoord * 20.0;
			float2 id78 = 0;
			float2 uv78 = 0;
			float fade78 = 0.5;
			float voroi78 = 0;
			float rest78 = 0;
			for( int it78 = 0; it78 <4; it78++ ){
			voroi78 += fade78 * voronoi78( coords78, time78, id78, uv78, 0 );
			rest78 += fade78;
			coords78 *= 2;
			fade78 *= 0.5;
			}//Voronoi78
			voroi78 /= rest78;
			float lerpResult84 = lerp( 0.0 , ( _GridIntensity * 2.74 ) , voroi78);
			float clampResult83 = clamp( lerpResult84 , 0.0 , 1.0 );
			o.Emission = ( _GridColor * triplanarColor75 * clampResult83 ).rgb;
			o.Alpha = 1;
			clip( ( clampResult83 * triplanarColor75 ).x - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
1122;73;1436;1010;-95.9339;53.65118;1;True;False
Node;AmplifyShaderEditor.SimpleTimeNode;80;-116.6996,144.7222;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;365.8987,-770.7571;Inherit;False;Property;_GridDensity;GridDensity;3;0;Create;True;0;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;2;68.14516,-895.6407;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TexturePropertyNode;71;310.0021,-1179.562;Inherit;True;Property;_Texture0;Texture 0;7;0;Create;True;0;0;0;False;0;False;afcaf30d1fda5c34d8eb9ee52eaed1b1;afcaf30d1fda5c34d8eb9ee52eaed1b1;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;36;372.3732,-677.0439;Inherit;False;Property;_GridFalloff;Grid Falloff;0;0;Create;True;0;0;0;False;0;False;23;23;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;410.567,145.0421;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;615.99,287.0775;Inherit;False;Property;_GridIntensity;GridIntensity;1;0;Create;True;0;0;0;False;0;False;1;23;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;69;699.9979,-935.0616;Inherit;True;Spherical;World;False;Top Texture 1;_TopTexture1;white;2;Assets/Microphone/GridTex.png;Mid Texture 1;_MidTexture1;white;0;None;Bot Texture 1;_BotTexture1;white;1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;82;1158.671,-931.1785;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;1,1,1,1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.VoronoiNode;78;776.6047,-49.45779;Inherit;True;0;0;1;0;4;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;2.04;False;2;FLOAT;20;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;836.9523,294.5668;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2.74;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;1407.428,-940.3791;Inherit;False;triplanarColor;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;84;995.1658,-38.63483;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;2.74;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;76;1276.817,325.1649;Inherit;False;75;triplanarColor;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;63;1083.052,-390.6371;Inherit;False;Property;_GridColor;Grid Color;5;1;[HDR];Create;True;0;0;0;False;0;False;0.5,0.2193396,0.4638,1;0.415094,0.162513,0.3243579,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;77;1100.75,-197.5479;Inherit;False;75;triplanarColor;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ClampOpNode;83;1251.166,-40.63483;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;1568.29,304.1733;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;85;201.6921,-5.123657;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;79;462.8341,-52.38171;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;86;31.49115,25.78174;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;188.8123,523.8945;Float;False;Property;_IntersectIntensity;Intersect Intensity;4;0;Create;True;0;0;0;False;0;False;0.2;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;1178.743,490.6397;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;1568.763,-219.3457;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT4;1,1,1,1;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;49;874.8248,504.7724;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;51;558.9523,505.7874;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;53;581.0974,666.5592;Float;False;Property;_IntersectColor;Intersect Color;6;0;Create;True;0;0;0;False;0;False;0.03137255,0.2588235,0.3176471,1;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1887.887,128.6116;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Chanoler/MicBubble2;False;False;False;False;True;True;True;True;True;True;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;TransparentCutout;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;88;0;80;0
WireConnection;69;0;71;0
WireConnection;69;9;2;0
WireConnection;69;3;35;0
WireConnection;69;4;36;0
WireConnection;82;0;69;0
WireConnection;78;1;88;0
WireConnection;90;0;89;0
WireConnection;75;0;82;0
WireConnection;84;1;90;0
WireConnection;84;2;78;0
WireConnection;83;0;84;0
WireConnection;87;0;83;0
WireConnection;87;1;76;0
WireConnection;85;1;86;0
WireConnection;79;1;85;0
WireConnection;86;0;80;0
WireConnection;57;0;49;0
WireConnection;57;1;53;0
WireConnection;61;0;63;0
WireConnection;61;1;77;0
WireConnection;61;2;83;0
WireConnection;49;0;51;0
WireConnection;51;0;52;0
WireConnection;0;2;61;0
WireConnection;0;10;87;0
ASEEND*/
//CHKSM=4B9F4B6519F868B4382C143F9344B21198E1A92A