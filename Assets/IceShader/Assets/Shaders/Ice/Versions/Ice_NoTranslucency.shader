// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Ice/Versions/Ice_NoTranslucency"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Texture1("Ramp", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_Noise("Noise", 2D) = "white" {}
		_Specular("Specular", Float) = 0.5
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 25.8
		_DepthFade("DepthFade", Float) = 0
		_IceCracksColor2("IceCracksColor2", Color) = (0,0,0,0)
		_IceCracksColor("IceCracksColor", Color) = (0,0,0,0)
		_IceDepthColor2("IceDepthColor2", Color) = (0,0,0,0)
		_IceDepthColor("IceDepthColor", Color) = (0,0,0,0)
		_FresnelPower("FresnelPower", Float) = 0
		_FresnelScale("FresnelScale", Float) = 0
		_AlbedoFresnelColor("AlbedoFresnelColor", Color) = (1,1,1,0)
		_CracksAreasPower("CracksAreasPower", Float) = 0.3
		_DarnessAreasPower("DarnessAreasPower", Float) = 4
		_HighIceDepthDark("HighIceDepthDark", Float) = 0.24
		_HighNumSteps("HighNumSteps", Float) = 40.7
		_HighIceMarchDistance("HighIceMarchDistance", Range( 0 , 0.51)) = 0.236
		_HighIceDepthPower("HighIceDepthPower", Float) = 2.41
		_LowIceDepthPower("LowIceDepthPower", Float) = 13.37
		_LowIceNumSteps("LowIceNumSteps", Float) = 28.8
		_LowIceMarchDistance("LowIceMarchDistance", Range( 0 , 0.51)) = 0.232
		_LowIceScale("LowIceScale", Range( -0.05 , 0.05)) = 0.001
		_LowIceDepthDark("LowIceDepthDark", Float) = 0
		_LowIceTiling("LowIceTiling", Float) = 0.85
		_LowIceHeight("LowIceHeight", Float) = 8.8
		_LowIceDarkness("LowIceDarkness", Float) = 0.4
		_LowerIceMarchDistance("LowerIceMarchDistance", Range( 0 , 0.51)) = 0.232
		_LowerIceNumSteps("LowerIceNumSteps", Float) = 28.8
		_LowerIceDepthPower("LowerIceDepthPower", Float) = 13.37
		_LowerIceScale("LowerIceScale", Range( -0.05 , 0.05)) = -0.0025
		_LowerIceDepthDark("LowerIceDepthDark", Float) = 0
		_LowerIceTiling("LowerIceTiling", Float) = 0.45
		_LowerIceHeight("LowerIceHeight", Float) = 31.79
		_LowerIceDarkness("LowerIceDarkness", Float) = 0.2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Transparent+0" }
		Cull Back
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 viewDir;
			INTERNAL_DATA
			float4 screenPos;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform sampler2D _Normal;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _Noise;
		uniform float4 _Noise_ST;
		uniform float _CracksAreasPower;
		uniform float _DarnessAreasPower;
		uniform float _HighIceMarchDistance;
		uniform float _HighNumSteps;
		uniform sampler2D _Texture1;
		uniform float4 _IceDepthColor2;
		uniform float4 _IceCracksColor2;
		uniform float _HighIceDepthDark;
		uniform float _HighIceDepthPower;
		uniform float _LowIceDarkness;
		uniform float _LowIceTiling;
		uniform float _LowIceHeight;
		uniform float _LowIceScale;
		uniform float _LowIceMarchDistance;
		uniform float _LowIceNumSteps;
		uniform float _LowIceDepthDark;
		uniform float _LowIceDepthPower;
		uniform float _LowerIceDarkness;
		uniform float _LowerIceTiling;
		uniform float _LowerIceHeight;
		uniform float _LowerIceScale;
		uniform float _LowerIceMarchDistance;
		uniform float _LowerIceNumSteps;
		uniform float _LowerIceDepthDark;
		uniform float _LowerIceDepthPower;
		uniform float4 _AlbedoFresnelColor;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _DepthFade;
		uniform float4 _IceDepthColor;
		uniform float4 _IceCracksColor;
		uniform float _FresnelScale;
		uniform float _FresnelPower;
		uniform float _Specular;
		uniform float _EdgeLength;


		float3 MyCustomExpression225( float2 UV , float _marchDistance , float _numSteps , sampler2D _MainTex , float3 _viewDir , sampler2D _InnerRamp )
		{
			float3 InnerStructure = float3(0, 0, 0);
			float2 UV2 = UV;
			float offset = 1;
			for (float d = 0; d < _marchDistance; d += _marchDistance / _numSteps)
			{
				UV2 -= (_viewDir*d)/_numSteps *  tex2D (_MainTex, UV).g;
				float4 Ldensity = tex2D(_MainTex, UV2).r;
				InnerStructure += saturate(Ldensity[0])*tex2D(_InnerRamp, float2(1/_numSteps * offset, 0.5));
				offset ++;
			}
			return InnerStructure;
		}


		float3 MyCustomExpression221( float2 UV , float _marchDistance , float _numSteps , sampler2D _MainTex , float3 _viewDir , sampler2D _InnerRamp )
		{
			float3 InnerStructure = float3(0, 0, 0);
			float2 UV2 = UV;
			float offset = 1;
			for (float d = 0; d < _marchDistance; d += _marchDistance / _numSteps)
			{
				UV2 -= (_viewDir*d)/_numSteps *  tex2D (_MainTex, UV).g;
				float4 Ldensity = tex2D(_MainTex, UV2).r;
				InnerStructure += saturate(Ldensity[0])*tex2D(_InnerRamp, float2(1/_numSteps * offset, 0.5));
				offset ++;
			}
			return InnerStructure;
		}


		float3 MyCustomExpression220( float2 UV , float _marchDistance , float _numSteps , sampler2D _MainTex , float3 _viewDir , sampler2D _InnerRamp )
		{
			float3 InnerStructure = float3(0, 0, 0);
			float2 UV2 = UV;
			float offset = 1;
			for (float d = 0; d < _marchDistance; d += _marchDistance / _numSteps)
			{
				UV2 -= (_viewDir*d)/_numSteps *  tex2D (_MainTex, UV).g;
				float4 Ldensity = tex2D(_MainTex, UV2).r;
				InnerStructure += saturate(Ldensity[0])*tex2D(_InnerRamp, float2(1/_numSteps * offset, 0.5));
				offset ++;
			}
			return InnerStructure;
		}


		float3 MyCustomExpression7( float2 UV , float _marchDistance , float _numSteps , sampler2D _MainTex , float3 _viewDir , sampler2D _InnerRamp )
		{
			float3 InnerStructure = float3(0, 0, 0);
			float2 UV2 = UV;
			float offset = 1;
			for (float d = 0; d < _marchDistance; d += _marchDistance / _numSteps)
			{
				UV2 -= (_viewDir*d)/_numSteps *  tex2D (_MainTex, UV).g;
				float4 Ldensity = tex2D(_MainTex, UV2).r;
				InnerStructure += saturate(Ldensity[0])*tex2D(_InnerRamp, float2(1/_numSteps * offset, 0.5));
				offset ++;
			}
			return InnerStructure;
		}


		float3 MyCustomExpression70( float2 UV , float _marchDistance , float _numSteps , sampler2D _MainTex , float3 _viewDir , sampler2D _InnerRamp )
		{
			float3 InnerStructure = float3(0, 0, 0);
			float2 UV2 = UV;
			float offset = 1;
			for (float d = 0; d < _marchDistance; d += _marchDistance / _numSteps)
			{
				UV2 -= (_viewDir*d)/_numSteps *  tex2D (_MainTex, UV).g;
				float4 Ldensity = tex2D(_MainTex, UV2).r;
				InnerStructure += saturate(Ldensity[0])*tex2D(_InnerRamp, float2(1/_numSteps * offset, 0.5));
				offset ++;
			}
			return InnerStructure;
		}


		float3 MyCustomExpression136( float2 UV , float _marchDistance , float _numSteps , sampler2D _MainTex , float3 _viewDir , sampler2D _InnerRamp )
		{
			float3 InnerStructure = float3(0, 0, 0);
			float2 UV2 = UV;
			float offset = 1;
			for (float d = 0; d < _marchDistance; d += _marchDistance / _numSteps)
			{
				UV2 -= (_viewDir*d)/_numSteps *  tex2D (_MainTex, UV).g;
				float4 Ldensity = tex2D(_MainTex, UV2).r;
				InnerStructure += saturate(Ldensity[0])*tex2D(_InnerRamp, float2(1/_numSteps * offset, 0.5));
				offset ++;
			}
			return InnerStructure;
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv0_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 temp_output_311_0 = ( uv0_MainTex * 2.0 );
			float2 SecondUV319 = temp_output_311_0;
			float2 FirstUV318 = uv0_MainTex;
			float2 uv_Noise = i.uv_texcoord * _Noise_ST.xy + _Noise_ST.zw;
			float4 tex2DNode281 = tex2D( _Noise, uv_Noise );
			float temp_output_282_0 = pow( tex2DNode281.g , _CracksAreasPower );
			float3 lerpResult316 = lerp( UnpackNormal( tex2D( _Normal, SecondUV319 ) ) , UnpackNormal( tex2D( _Normal, FirstUV318 ) ) , temp_output_282_0);
			float clampResult291 = clamp( ( tex2DNode281.r * _DarnessAreasPower ) , 0.0 , 1.0 );
			float3 lerpResult317 = lerp( float3( 0,0,0 ) , lerpResult316 , clampResult291);
			o.Normal = lerpResult317;
			float2 UV225 = temp_output_311_0;
			float _marchDistance225 = _HighIceMarchDistance;
			float _numSteps225 = _HighNumSteps;
			sampler2D _MainTex225 = _MainTex;
			float3 _viewDir225 = i.viewDir;
			sampler2D _InnerRamp225 = _Texture1;
			float3 localMyCustomExpression225 = MyCustomExpression225( UV225 , _marchDistance225 , _numSteps225 , _MainTex225 , _viewDir225 , _InnerRamp225 );
			float temp_output_236_0 = ( 1.0 - localMyCustomExpression225.x );
			float4 lerpResult260 = lerp( ( temp_output_236_0 * _IceDepthColor2 ) , ( _IceCracksColor2 * localMyCustomExpression225.x ) , localMyCustomExpression225.x);
			float clampResult259 = clamp( ( 1.0 - pow( temp_output_236_0 , ( 0.5 * _HighIceDepthPower ) ) ) , 0.0 , 1.0 );
			float clampResult270 = clamp( ( localMyCustomExpression225.x + clampResult259 ) , 0.0 , 1.0 );
			float4 lerpResult275 = lerp( ( lerpResult260 * _HighIceDepthDark ) , lerpResult260 , clampResult270);
			float2 Offset215 = ( ( _LowIceHeight - 1 ) * i.viewDir.xy * _LowIceScale ) + ( temp_output_311_0 * _LowIceTiling );
			float2 UV221 = Offset215;
			float _marchDistance221 = _LowIceMarchDistance;
			float _numSteps221 = _LowIceNumSteps;
			sampler2D _MainTex221 = _MainTex;
			float3 _viewDir221 = i.viewDir;
			sampler2D _InnerRamp221 = _Texture1;
			float3 localMyCustomExpression221 = MyCustomExpression221( UV221 , _marchDistance221 , _numSteps221 , _MainTex221 , _viewDir221 , _InnerRamp221 );
			float temp_output_229_0 = ( 1.0 - localMyCustomExpression221.x );
			float4 lerpResult248 = lerp( ( temp_output_229_0 * _IceDepthColor2 ) , ( _IceCracksColor2 * localMyCustomExpression221.x ) , localMyCustomExpression221.x);
			float clampResult251 = clamp( ( 1.0 - pow( temp_output_229_0 , _LowIceDepthPower ) ) , 0.0 , 1.0 );
			float clampResult267 = clamp( ( localMyCustomExpression221.x + clampResult251 ) , 0.0 , 1.0 );
			float4 lerpResult273 = lerp( ( lerpResult248 * _LowIceDepthDark ) , lerpResult248 , clampResult267);
			float2 Offset207 = ( ( _LowerIceHeight - 1 ) * i.viewDir.xy * _LowerIceScale ) + ( _LowerIceTiling * temp_output_311_0 );
			float2 UV220 = Offset207;
			float _marchDistance220 = _LowerIceMarchDistance;
			float _numSteps220 = _LowerIceNumSteps;
			sampler2D _MainTex220 = _MainTex;
			float3 _viewDir220 = i.viewDir;
			sampler2D _InnerRamp220 = _Texture1;
			float3 localMyCustomExpression220 = MyCustomExpression220( UV220 , _marchDistance220 , _numSteps220 , _MainTex220 , _viewDir220 , _InnerRamp220 );
			float temp_output_230_0 = ( 1.0 - localMyCustomExpression220.x );
			float4 lerpResult246 = lerp( ( temp_output_230_0 * _IceDepthColor2 ) , ( _IceCracksColor2 * localMyCustomExpression220.x ) , localMyCustomExpression220.x);
			float clampResult247 = clamp( ( 1.0 - pow( temp_output_230_0 , _LowerIceDepthPower ) ) , 0.0 , 1.0 );
			float clampResult266 = clamp( ( localMyCustomExpression220.x + clampResult247 ) , 0.0 , 1.0 );
			float4 lerpResult268 = lerp( ( lerpResult246 * _LowerIceDepthDark ) , lerpResult246 , clampResult266);
			float4 temp_output_279_0 = ( lerpResult275 + ( _LowIceDarkness * lerpResult273 ) + ( _LowerIceDarkness * lerpResult268 ) );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth187 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD( ase_screenPos ))));
			float distanceDepth187 = abs( ( screenDepth187 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthFade ) );
			float clampResult189 = clamp( distanceDepth187 , 0.0 , 1.0 );
			float2 UV7 = uv0_MainTex;
			float _marchDistance7 = _HighIceMarchDistance;
			float _numSteps7 = _HighNumSteps;
			sampler2D _MainTex7 = _MainTex;
			float3 _viewDir7 = i.viewDir;
			sampler2D _InnerRamp7 = _Texture1;
			float3 localMyCustomExpression7 = MyCustomExpression7( UV7 , _marchDistance7 , _numSteps7 , _MainTex7 , _viewDir7 , _InnerRamp7 );
			float temp_output_26_0 = ( 1.0 - localMyCustomExpression7.x );
			float4 lerpResult23 = lerp( ( temp_output_26_0 * _IceDepthColor ) , ( _IceCracksColor * localMyCustomExpression7.x ) , localMyCustomExpression7.x);
			float clampResult37 = clamp( ( 1.0 - pow( temp_output_26_0 , _HighIceDepthPower ) ) , 0.0 , 1.0 );
			float clampResult40 = clamp( ( localMyCustomExpression7.x + clampResult37 ) , 0.0 , 1.0 );
			float4 lerpResult41 = lerp( ( lerpResult23 * _HighIceDepthDark ) , lerpResult23 , clampResult40);
			float2 Offset54 = ( ( _LowIceHeight - 1 ) * i.viewDir.xy * _LowIceScale ) + ( _LowIceTiling * uv0_MainTex );
			float2 UV70 = Offset54;
			float _marchDistance70 = _LowIceMarchDistance;
			float _numSteps70 = _LowIceNumSteps;
			sampler2D _MainTex70 = _MainTex;
			float3 _viewDir70 = i.viewDir;
			sampler2D _InnerRamp70 = _Texture1;
			float3 localMyCustomExpression70 = MyCustomExpression70( UV70 , _marchDistance70 , _numSteps70 , _MainTex70 , _viewDir70 , _InnerRamp70 );
			float temp_output_80_0 = ( 1.0 - localMyCustomExpression70.x );
			float4 lerpResult88 = lerp( ( temp_output_80_0 * _IceDepthColor ) , ( _IceCracksColor * localMyCustomExpression70.x ) , localMyCustomExpression70.x);
			float clampResult89 = clamp( ( 1.0 - pow( temp_output_80_0 , _LowIceDepthPower ) ) , 0.0 , 1.0 );
			float clampResult78 = clamp( ( localMyCustomExpression70.x + clampResult89 ) , 0.0 , 1.0 );
			float4 lerpResult79 = lerp( ( lerpResult88 * _LowIceDepthDark ) , lerpResult88 , clampResult78);
			float2 Offset130 = ( ( _LowerIceHeight - 1 ) * i.viewDir.xy * _LowerIceScale ) + ( _LowerIceTiling * uv0_MainTex );
			float2 UV136 = Offset130;
			float _marchDistance136 = _LowerIceMarchDistance;
			float _numSteps136 = _LowerIceNumSteps;
			sampler2D _MainTex136 = _MainTex;
			float3 _viewDir136 = i.viewDir;
			sampler2D _InnerRamp136 = _Texture1;
			float3 localMyCustomExpression136 = MyCustomExpression136( UV136 , _marchDistance136 , _numSteps136 , _MainTex136 , _viewDir136 , _InnerRamp136 );
			float temp_output_138_0 = ( 1.0 - localMyCustomExpression136.x );
			float4 lerpResult146 = lerp( ( temp_output_138_0 * _IceDepthColor ) , ( _IceCracksColor * localMyCustomExpression136.x ) , localMyCustomExpression136.x);
			float clampResult147 = clamp( ( 1.0 - pow( temp_output_138_0 , _LowerIceDepthPower ) ) , 0.0 , 1.0 );
			float clampResult151 = clamp( ( localMyCustomExpression136.x + clampResult147 ) , 0.0 , 1.0 );
			float4 lerpResult154 = lerp( ( lerpResult146 * _LowerIceDepthDark ) , lerpResult146 , clampResult151);
			float4 temp_output_53_0 = ( lerpResult41 + ( _LowIceDarkness * lerpResult79 ) + ( _LowerIceDarkness * lerpResult154 ) );
			float grayscale107 = Luminance(temp_output_53_0.rgb);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV99 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode99 = ( 0.0 + _FresnelScale * pow( 1.0 - fresnelNdotV99, _FresnelPower ) );
			float clampResult105 = clamp( ( grayscale107 + fresnelNode99 ) , 0.0 , 1.1 );
			float temp_output_191_0 = ( clampResult189 * clampResult105 );
			float4 lerpResult285 = lerp( ( temp_output_279_0 * _AlbedoFresnelColor ) , temp_output_279_0 , temp_output_191_0);
			float4 lerpResult102 = lerp( ( _AlbedoFresnelColor * temp_output_53_0 ) , temp_output_53_0 , temp_output_191_0);
			float4 lerpResult284 = lerp( lerpResult285 , lerpResult102 , temp_output_282_0);
			float4 lerpResult293 = lerp( float4( 0,0,0,0 ) , lerpResult284 , clampResult291);
			o.Albedo = lerpResult293.rgb;
			float3 temp_cast_2 = (( clampResult291 * _Specular )).xxx;
			o.Specular = temp_cast_2;
			float Smoothness184 = localMyCustomExpression7.x;
			o.Smoothness = ( 1.0 - Smoothness184 );
			o.Occlusion = ( clampResult291 * temp_output_191_0 );
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardSpecular keepalpha fullforwardshadows exclude_path:deferred vertex:vertexDataFunc tessellate:tessFunction 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 screenPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputStandardSpecular o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecular, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
-1692;76;1666;974;-1036.62;-282.9423;1;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;8;-3284.988,920.881;Float;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;125;-2389.342,1568.555;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;124;-2347.999,1466.994;Float;False;Property;_LowerIceTiling;LowerIceTiling;37;0;Create;True;0;0;False;0;0.45;0.45;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-2397.347,451.308;Float;False;Property;_LowIceTiling;LowIceTiling;29;0;Create;True;0;0;False;0;0.85;0.85;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;64;-2435.957,551.755;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;312;-1954.607,-2237.82;Float;False;Constant;_Float1;Float 1;38;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-2265.906,708.6108;Float;False;Property;_LowIceScale;LowIceScale;27;0;Create;True;0;0;False;0;0.001;0.001;-0.05;0.05;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-2194.052,623.61;Float;False;Property;_LowIceHeight;LowIceHeight;30;0;Create;True;0;0;False;0;8.8;-75.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;58;-2190.433,802.8251;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;126;-2147.437,1640.41;Float;False;Property;_LowerIceHeight;LowerIceHeight;38;0;Create;True;0;0;False;0;31.79;46.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;127;-2143.818,1819.625;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;129;-2219.291,1725.411;Float;False;Property;_LowerIceScale;LowerIceScale;35;0;Create;True;0;0;False;0;-0.0025;-0.0061;-0.05;0.05;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-2163.115,499.8431;Float;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;128;-2116.5,1516.643;Float;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;67;-1823.591,1148.604;Float;True;Property;_Texture1;Ramp;1;0;Create;False;0;0;False;0;None;d603acd0ed242ad4ea6a8fb04ee90016;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.ParallaxMappingNode;130;-1870.772,1667.116;Float;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;131;-2001.881,2058.899;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WireNode;159;-1909.561,983.5676;Float;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;311;-1759.064,-2256.677;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-1881.349,898.4681;Float;False;Property;_LowIceNumSteps;LowIceNumSteps;25;0;Create;True;0;0;False;0;28.8;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;134;-1882.581,1834.182;Float;False;Property;_LowerIceMarchDistance;LowerIceMarchDistance;32;0;Create;True;0;0;False;0;0.232;0.232;0;0.51;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;133;-1834.732,1915.268;Float;False;Property;_LowerIceNumSteps;LowerIceNumSteps;33;0;Create;True;0;0;False;0;28.8;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;160;-2474.663,1904.4;Float;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;69;-2048.496,1042.1;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WireNode;161;-2406.758,-84.09679;Float;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-1929.198,817.3821;Float;False;Property;_LowIceMarchDistance;LowIceMarchDistance;26;0;Create;True;0;0;False;0;0.232;0.091;0;0.51;0;1;FLOAT;0
Node;AmplifyShaderEditor.ParallaxMappingNode;54;-1917.389,650.3159;Float;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;13;-1738.885,27.22451;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CustomExpressionNode;136;-1432.234,1855.886;Float;False;float3 InnerStructure = float3(0, 0, 0)@$float2 UV2 = UV@$float offset = 1@$for (float d = 0@ d < _marchDistance@ d += _marchDistance / _numSteps)${$	UV2 -= (_viewDir*d)/_numSteps *  tex2D (_MainTex, UV).g@$	float4 Ldensity = tex2D(_MainTex, UV2).r@$	InnerStructure += saturate(Ldensity[0])*tex2D(_InnerRamp, float2(1/_numSteps * offset, 0.5))@$	offset ++@$}$return InnerStructure@;3;False;6;True;UV;FLOAT2;0,0;In;;Float;True;_marchDistance;FLOAT;0;In;;Float;True;_numSteps;FLOAT;0;In;;Float;True;_MainTex;SAMPLER2D;;In;;Float;True;_viewDir;FLOAT3;0,0,0;In;;Float;True;_InnerRamp;SAMPLER2D;;In;;Float;My Custom Expression;True;False;0;6;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;SAMPLER2D;;False;4;FLOAT3;0,0,0;False;5;SAMPLER2D;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CustomExpressionNode;70;-1478.851,839.0861;Float;False;float3 InnerStructure = float3(0, 0, 0)@$float2 UV2 = UV@$float offset = 1@$for (float d = 0@ d < _marchDistance@ d += _marchDistance / _numSteps)${$	UV2 -= (_viewDir*d)/_numSteps *  tex2D (_MainTex, UV).g@$	float4 Ldensity = tex2D(_MainTex, UV2).r@$	InnerStructure += saturate(Ldensity[0])*tex2D(_InnerRamp, float2(1/_numSteps * offset, 0.5))@$	offset ++@$}$return InnerStructure@;3;False;6;True;UV;FLOAT2;0,0;In;;Float;True;_marchDistance;FLOAT;0;In;;Float;True;_numSteps;FLOAT;0;In;;Float;True;_MainTex;SAMPLER2D;;In;;Float;True;_viewDir;FLOAT3;0,0,0;In;;Float;True;_InnerRamp;SAMPLER2D;;In;;Float;My Custom Expression;True;False;0;6;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;SAMPLER2D;;False;4;FLOAT3;0,0,0;False;5;SAMPLER2D;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1613.404,-200.1468;Float;False;Property;_HighIceMarchDistance;HighIceMarchDistance;22;0;Create;True;0;0;False;0;0.236;0.289;0;0.51;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-1597.392,-335.7693;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;314;-1488.742,-1743.385;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;162;-1617.953,570.1283;Float;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-1528.739,-122.4079;Float;False;Property;_HighNumSteps;HighNumSteps;21;0;Create;True;0;0;False;0;40.7;30;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;30;-2110.423,66.81783;Float;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.BreakToComponentsNode;77;-1127.359,839.8121;Float;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;203;-1082.615,-1134.073;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BreakToComponentsNode;137;-1080.742,1856.612;Float;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;204;-1053.297,-1246.055;Float;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;199;-1118.23,-2109.872;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CustomExpressionNode;7;-1241.604,-109.8879;Float;False;float3 InnerStructure = float3(0, 0, 0)@$float2 UV2 = UV@$float offset = 1@$for (float d = 0@ d < _marchDistance@ d += _marchDistance / _numSteps)${$	UV2 -= (_viewDir*d)/_numSteps *  tex2D (_MainTex, UV).g@$	float4 Ldensity = tex2D(_MainTex, UV2).r@$	InnerStructure += saturate(Ldensity[0])*tex2D(_InnerRamp, float2(1/_numSteps * offset, 0.5))@$	offset ++@$}$return InnerStructure@;3;False;6;True;UV;FLOAT2;0,0;In;;Float;True;_marchDistance;FLOAT;0;In;;Float;True;_numSteps;FLOAT;0;In;;Float;True;_MainTex;SAMPLER2D;;In;;Float;True;_viewDir;FLOAT3;0,0,0;In;;Float;True;_InnerRamp;SAMPLER2D;;In;;Float;My Custom Expression;True;False;0;6;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;SAMPLER2D;;False;4;FLOAT3;0,0,0;False;5;SAMPLER2D;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;202;-1087.479,-2258.756;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;81;-551.4209,1213.515;Float;False;Property;_LowIceDepthPower;LowIceDepthPower;24;0;Create;True;0;0;False;0;13.37;13.37;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;139;-562.5438,2251.966;Float;False;Property;_LowerIceDepthPower;LowerIceDepthPower;34;0;Create;True;0;0;False;0;13.37;13.37;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;210;-704.4783,-963.8962;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;209;-815.3951,-1984.632;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ParallaxMappingNode;215;-845.1869,-2262.381;Float;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ParallaxMappingNode;207;-798.5695,-1245.582;Float;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;138;-661.6157,1949.224;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;24;-899.3379,-109.4719;Float;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.OneMinusNode;80;-708.232,932.4241;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;220;-360.0312,-1056.811;Float;False;float3 InnerStructure = float3(0, 0, 0)@$float2 UV2 = UV@$float offset = 1@$for (float d = 0@ d < _marchDistance@ d += _marchDistance / _numSteps)${$	UV2 -= (_viewDir*d)/_numSteps *  tex2D (_MainTex, UV).g@$	float4 Ldensity = tex2D(_MainTex, UV2).r@$	InnerStructure += saturate(Ldensity[0])*tex2D(_InnerRamp, float2(1/_numSteps * offset, 0.5))@$	offset ++@$}$return InnerStructure@;3;False;6;True;UV;FLOAT2;0,0;In;;Float;True;_marchDistance;FLOAT;0;In;;Float;True;_numSteps;FLOAT;0;In;;Float;True;_MainTex;SAMPLER2D;;In;;Float;True;_viewDir;FLOAT3;0,0,0;In;;Float;True;_InnerRamp;SAMPLER2D;;In;;Float;My Custom Expression;True;False;0;6;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;SAMPLER2D;;False;4;FLOAT3;0,0,0;False;5;SAMPLER2D;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-467.9498,270.445;Float;False;Property;_HighIceDepthPower;HighIceDepthPower;23;0;Create;True;0;0;False;0;2.41;7.57;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;222;-561.1609,-2935.067;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CustomExpressionNode;221;-406.6487,-2073.611;Float;False;float3 InnerStructure = float3(0, 0, 0)@$float2 UV2 = UV@$float offset = 1@$for (float d = 0@ d < _marchDistance@ d += _marchDistance / _numSteps)${$	UV2 -= (_viewDir*d)/_numSteps *  tex2D (_MainTex, UV).g@$	float4 Ldensity = tex2D(_MainTex, UV2).r@$	InnerStructure += saturate(Ldensity[0])*tex2D(_InnerRamp, float2(1/_numSteps * offset, 0.5))@$	offset ++@$}$return InnerStructure@;3;False;6;True;UV;FLOAT2;0,0;In;;Float;True;_marchDistance;FLOAT;0;In;;Float;True;_numSteps;FLOAT;0;In;;Float;True;_MainTex;SAMPLER2D;;In;;Float;True;_viewDir;FLOAT3;0,0,0;In;;Float;True;_InnerRamp;SAMPLER2D;;In;;Float;My Custom Expression;True;False;0;6;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;SAMPLER2D;;False;4;FLOAT3;0,0,0;False;5;SAMPLER2D;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;83;-322.6098,1129.581;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;26;-604.3337,-16.8595;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;28;-1132.947,1184.479;Float;False;Property;_IceDepthColor;IceDepthColor;14;0;Create;True;0;0;False;0;0,0,0,0;0.4720986,0.5140231,0.9716981,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;313;-1184.396,-2848.942;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;1;-1155.203,438.2621;Float;False;Property;_IceCracksColor;IceCracksColor;12;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;140;-275.9933,2146.38;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;-437.9272,1950.016;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;-484.5435,933.2161;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;145;-112.9073,2101.78;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;143;-462.2897,1735.486;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;227;-55.15646,-2072.885;Float;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.BreakToComponentsNode;226;-8.539764,-1056.085;Float;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.PowerNode;31;-218.7112,180.2972;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;-508.9062,718.6865;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;85;-159.5239,1084.98;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;225;-169.4011,-3022.584;Float;False;float3 InnerStructure = float3(0, 0, 0)@$float2 UV2 = UV@$float offset = 1@$for (float d = 0@ d < _marchDistance@ d += _marchDistance / _numSteps)${$	UV2 -= (_viewDir*d)/_numSteps *  tex2D (_MainTex, UV).g@$	float4 Ldensity = tex2D(_MainTex, UV2).r@$	InnerStructure += saturate(Ldensity[0])*tex2D(_InnerRamp, float2(1/_numSteps * offset, 0.5))@$	offset ++@$}$return InnerStructure@;3;False;6;True;UV;FLOAT2;0,0;In;;Float;True;_marchDistance;FLOAT;0;In;;Float;True;_numSteps;FLOAT;0;In;;Float;True;_MainTex;SAMPLER2D;;In;;Float;True;_viewDir;FLOAT3;0,0,0;In;;Float;True;_InnerRamp;SAMPLER2D;;In;;Float;My Custom Expression;True;False;0;6;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;SAMPLER2D;;False;4;FLOAT3;0,0,0;False;5;SAMPLER2D;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-405.0075,-230.5976;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;33;-55.62528,135.6971;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;230;410.5868,-963.4735;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;89;23.15929,1013.989;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-380.6449,-16.0679;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;147;69.7759,2030.789;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;229;363.9706,-1980.273;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;88;-294.6154,791.9141;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;146;-247.9989,1808.714;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;232;172.8647,-3022.168;Float;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;148;105.0212,1759.157;Float;False;Property;_LowerIceDepthDark;LowerIceDepthDark;36;0;Create;True;0;0;False;0;0;1.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;37;127.0581,64.7059;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;150;-45.89102,1742.394;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;234;-60.74484,-1728.218;Float;False;Property;_IceDepthColor2;IceDepthColor2;13;0;Create;True;0;0;False;0;0,0,0,0;0.4720986,0.5140231,0.9716981,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;238;796.2096,-766.3177;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;23;-190.7166,-157.3694;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;90;198.7598,952.9901;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;236;467.869,-2929.556;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;237;749.5929,-1783.116;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;235;-83.00095,-2474.434;Float;False;Property;_IceCracksColor2;IceCracksColor2;11;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;149;245.3765,1969.789;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;91;-92.50763,725.5944;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;92;58.40457,742.3577;Float;False;Property;_LowIceDepthDark;LowIceDepthDark;28;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;323;684.5908,-2626.016;Float;False;2;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;61;11.39086,-223.69;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;78;352.0795,899.774;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;240;853.4918,-2732.399;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;162.3031,-206.9264;Float;False;Property;_HighIceDepthDark;HighIceDepthDark;20;0;Create;True;0;0;False;0;0.24;0.24;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;151;398.696,1916.574;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;243;912.6793,-1827.717;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;242;587.6592,-1979.481;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;239;634.2755,-962.6815;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;241;609.9132,-1177.212;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;302.6582,3.70599;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;284.6055,676.3578;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;152;331.2221,1693.157;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;245;563.2965,-2194.01;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;244;959.2954,-810.9177;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;246;824.2037,-1103.984;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;250;691.5577,-2928.765;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;249;1016.578,-2776.999;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;388.5043,-272.9262;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;79;563.7222,777.1941;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;252;667.1954,-3143.294;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;154;610.3388,1793.994;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;122;590.9398,579.5535;Float;False;Property;_LowIceDarkness;LowIceDarkness;31;0;Create;True;0;0;False;0;0.4;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;153;559.6829,1502.085;Float;False;Property;_LowerIceDarkness;LowerIceDarkness;39;0;Create;True;0;0;False;0;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;40;455.9781,-49.51002;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;248;777.5875,-2120.783;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;247;1141.98,-881.9087;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;251;1095.363,-1898.708;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;41;633.5031,-174.5265;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;260;881.4866,-3070.066;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;256;1026.312,-1170.303;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;258;979.6953,-2187.103;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;156;831.1175,1597.859;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;257;1317.58,-942.9087;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;259;1199.262,-2847.991;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;254;1270.963,-1959.707;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;825.6345,690.8613;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;265;1403.425,-1219.541;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;262;904.5349,-2977.223;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;100;1257.872,1215.48;Float;False;Property;_FresnelPower;FresnelPower;15;0;Create;True;0;0;False;0;0;0.32;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;266;1470.899,-996.1238;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;267;1424.282,-2012.923;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;263;1356.809,-2236.339;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;101;1256.872,1120.48;Float;False;Property;_FresnelScale;FresnelScale;16;0;Create;True;0;0;False;0;0;1.39;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;53;1258.672,672.5457;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;261;1374.861,-2908.991;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;273;1635.926,-2135.503;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;269;1281.648,-3026.459;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;188;1500.755,859.5919;Float;False;Property;_DepthFade;DepthFade;10;0;Create;True;0;0;False;0;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;268;1682.542,-1118.704;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;270;1528.181,-2962.206;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;107;1531.684,996.1512;Float;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;99;1497.734,1090.905;Float;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;274;1897.838,-2221.836;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;109;1836.658,998.8099;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;187;1746.865,841.691;Float;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;275;1705.706,-3087.223;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;276;1903.321,-1314.839;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;279;2335.689,-2242.559;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;189;2037.881,842.7906;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;318;-994.5714,-350.0875;Float;False;FirstUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;105;2040.163,999.5823;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;104;1551.353,-243.5275;Float;False;Property;_AlbedoFresnelColor;AlbedoFresnelColor;17;0;Create;True;0;0;False;0;1,1,1,0;0.1115917,0.1519957,0.9485294,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;319;-1369.732,-2350.629;Float;False;SecondUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;191;2239.897,907.1725;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;286;2103.689,-264.1337;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;1917.813,296.7525;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;321;2221.771,476.7607;Float;False;319;SecondUV;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;283;2230.872,82.0459;Float;False;Property;_CracksAreasPower;CracksAreasPower;18;0;Create;True;0;0;False;0;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;290;2220.394,187.5476;Float;False;Property;_DarnessAreasPower;DarnessAreasPower;19;0;Create;True;0;0;False;0;4;4.56;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;322;2205.075,682.9935;Float;False;318;FirstUV;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;281;2159.215,-110.6494;Float;True;Property;_Noise;Noise;3;0;Create;True;0;0;False;0;004603b76f5639d47b5bc5e454e8e77d;004603b76f5639d47b5bc5e454e8e77d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;315;2536.161,455.0962;Float;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;None;None;True;0;True;bump;Auto;True;Instance;182;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;289;2546.479,170.6573;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;182;2537.709,659.9252;Float;True;Property;_Normal;Normal;2;0;Create;True;0;0;False;0;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;282;2546.872,21.046;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;184;-557.8928,-341.8177;Float;False;Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;102;2525.4,288.7405;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;285;2548.305,-264.0279;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;316;2941.101,555.7216;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;284;2845.687,-24.22043;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;185;2980.432,794.138;Float;False;184;Smoothness;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;291;2849.138,169.7858;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;298;3013.591,712.3541;Float;False;Property;_Specular;Specular;4;0;Create;True;0;0;False;0;0.5;0.43;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;317;3235.293,533.9549;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;186;3229.663,798.3659;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;293;3227.351,308.961;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;329;3250.952,891.4053;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;308;3241.437,694.1196;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3597.489,744.8591;Float;False;True;6;Float;ASEMaterialInspector;0;0;StandardSpecular;Ice/Versions/Ice_NoTranslucency;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Translucent;0.5;True;True;0;False;Opaque;;Transparent;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;25.8;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;5;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;125;2;8;0
WireConnection;64;2;8;0
WireConnection;73;0;74;0
WireConnection;73;1;64;0
WireConnection;128;0;124;0
WireConnection;128;1;125;0
WireConnection;130;0;128;0
WireConnection;130;1;126;0
WireConnection;130;2;129;0
WireConnection;130;3;127;0
WireConnection;159;0;8;0
WireConnection;311;0;64;0
WireConnection;311;1;312;0
WireConnection;160;0;8;0
WireConnection;161;0;8;0
WireConnection;54;0;73;0
WireConnection;54;1;56;0
WireConnection;54;2;57;0
WireConnection;54;3;58;0
WireConnection;136;0;130;0
WireConnection;136;1;134;0
WireConnection;136;2;133;0
WireConnection;136;3;160;0
WireConnection;136;4;131;0
WireConnection;136;5;67;0
WireConnection;70;0;54;0
WireConnection;70;1;65;0
WireConnection;70;2;66;0
WireConnection;70;3;159;0
WireConnection;70;4;69;0
WireConnection;70;5;67;0
WireConnection;6;2;161;0
WireConnection;314;0;311;0
WireConnection;162;0;67;0
WireConnection;30;0;8;0
WireConnection;77;0;70;0
WireConnection;137;0;136;0
WireConnection;204;0;124;0
WireConnection;204;1;314;0
WireConnection;7;0;6;0
WireConnection;7;1;9;0
WireConnection;7;2;11;0
WireConnection;7;3;30;0
WireConnection;7;4;13;0
WireConnection;7;5;162;0
WireConnection;202;0;311;0
WireConnection;202;1;74;0
WireConnection;215;0;202;0
WireConnection;215;1;56;0
WireConnection;215;2;57;0
WireConnection;215;3;199;0
WireConnection;207;0;204;0
WireConnection;207;1;126;0
WireConnection;207;2;129;0
WireConnection;207;3;203;0
WireConnection;138;0;137;0
WireConnection;24;0;7;0
WireConnection;80;0;77;0
WireConnection;220;0;207;0
WireConnection;220;1;134;0
WireConnection;220;2;133;0
WireConnection;220;3;8;0
WireConnection;220;4;210;0
WireConnection;220;5;67;0
WireConnection;221;0;215;0
WireConnection;221;1;65;0
WireConnection;221;2;66;0
WireConnection;221;3;8;0
WireConnection;221;4;209;0
WireConnection;221;5;67;0
WireConnection;83;0;80;0
WireConnection;83;1;81;0
WireConnection;26;0;24;0
WireConnection;313;0;311;0
WireConnection;140;0;138;0
WireConnection;140;1;139;0
WireConnection;144;0;138;0
WireConnection;144;1;28;0
WireConnection;86;0;80;0
WireConnection;86;1;28;0
WireConnection;145;0;140;0
WireConnection;143;0;1;0
WireConnection;143;1;137;0
WireConnection;227;0;221;0
WireConnection;226;0;220;0
WireConnection;31;0;26;0
WireConnection;31;1;32;0
WireConnection;87;0;1;0
WireConnection;87;1;77;0
WireConnection;85;0;83;0
WireConnection;225;0;313;0
WireConnection;225;1;9;0
WireConnection;225;2;11;0
WireConnection;225;3;8;0
WireConnection;225;4;222;0
WireConnection;225;5;67;0
WireConnection;25;0;1;0
WireConnection;25;1;24;0
WireConnection;33;0;31;0
WireConnection;230;0;226;0
WireConnection;89;0;85;0
WireConnection;27;0;26;0
WireConnection;27;1;28;0
WireConnection;147;0;145;0
WireConnection;229;0;227;0
WireConnection;88;0;86;0
WireConnection;88;1;87;0
WireConnection;88;2;77;0
WireConnection;146;0;144;0
WireConnection;146;1;143;0
WireConnection;146;2;137;0
WireConnection;232;0;225;0
WireConnection;37;0;33;0
WireConnection;150;0;146;0
WireConnection;238;0;230;0
WireConnection;238;1;139;0
WireConnection;23;0;27;0
WireConnection;23;1;25;0
WireConnection;23;2;24;0
WireConnection;90;0;77;0
WireConnection;90;1;89;0
WireConnection;236;0;232;0
WireConnection;237;0;229;0
WireConnection;237;1;81;0
WireConnection;149;0;137;0
WireConnection;149;1;147;0
WireConnection;91;0;88;0
WireConnection;323;1;32;0
WireConnection;61;0;23;0
WireConnection;78;0;90;0
WireConnection;240;0;236;0
WireConnection;240;1;323;0
WireConnection;151;0;149;0
WireConnection;243;0;237;0
WireConnection;242;0;229;0
WireConnection;242;1;234;0
WireConnection;239;0;230;0
WireConnection;239;1;234;0
WireConnection;241;0;235;0
WireConnection;241;1;226;0
WireConnection;36;0;24;0
WireConnection;36;1;37;0
WireConnection;93;0;91;0
WireConnection;93;1;92;0
WireConnection;152;0;150;0
WireConnection;152;1;148;0
WireConnection;245;0;235;0
WireConnection;245;1;227;0
WireConnection;244;0;238;0
WireConnection;246;0;239;0
WireConnection;246;1;241;0
WireConnection;246;2;226;0
WireConnection;250;0;236;0
WireConnection;250;1;234;0
WireConnection;249;0;240;0
WireConnection;39;0;61;0
WireConnection;39;1;43;0
WireConnection;79;0;93;0
WireConnection;79;1;88;0
WireConnection;79;2;78;0
WireConnection;252;0;235;0
WireConnection;252;1;232;0
WireConnection;154;0;152;0
WireConnection;154;1;146;0
WireConnection;154;2;151;0
WireConnection;40;0;36;0
WireConnection;248;0;242;0
WireConnection;248;1;245;0
WireConnection;248;2;227;0
WireConnection;247;0;244;0
WireConnection;251;0;243;0
WireConnection;41;0;39;0
WireConnection;41;1;23;0
WireConnection;41;2;40;0
WireConnection;260;0;250;0
WireConnection;260;1;252;0
WireConnection;260;2;232;0
WireConnection;256;0;246;0
WireConnection;258;0;248;0
WireConnection;156;0;153;0
WireConnection;156;1;154;0
WireConnection;257;0;226;0
WireConnection;257;1;247;0
WireConnection;259;0;249;0
WireConnection;254;0;227;0
WireConnection;254;1;251;0
WireConnection;75;0;122;0
WireConnection;75;1;79;0
WireConnection;265;0;256;0
WireConnection;265;1;148;0
WireConnection;262;0;260;0
WireConnection;266;0;257;0
WireConnection;267;0;254;0
WireConnection;263;0;258;0
WireConnection;263;1;92;0
WireConnection;53;0;41;0
WireConnection;53;1;75;0
WireConnection;53;2;156;0
WireConnection;261;0;232;0
WireConnection;261;1;259;0
WireConnection;273;0;263;0
WireConnection;273;1;248;0
WireConnection;273;2;267;0
WireConnection;269;0;262;0
WireConnection;269;1;43;0
WireConnection;268;0;265;0
WireConnection;268;1;246;0
WireConnection;268;2;266;0
WireConnection;270;0;261;0
WireConnection;107;0;53;0
WireConnection;99;2;101;0
WireConnection;99;3;100;0
WireConnection;274;0;122;0
WireConnection;274;1;273;0
WireConnection;109;0;107;0
WireConnection;109;1;99;0
WireConnection;187;0;188;0
WireConnection;275;0;269;0
WireConnection;275;1;260;0
WireConnection;275;2;270;0
WireConnection;276;0;153;0
WireConnection;276;1;268;0
WireConnection;279;0;275;0
WireConnection;279;1;274;0
WireConnection;279;2;276;0
WireConnection;189;0;187;0
WireConnection;318;0;6;0
WireConnection;105;0;109;0
WireConnection;319;0;311;0
WireConnection;191;0;189;0
WireConnection;191;1;105;0
WireConnection;286;0;279;0
WireConnection;286;1;104;0
WireConnection;103;0;104;0
WireConnection;103;1;53;0
WireConnection;315;1;321;0
WireConnection;289;0;281;1
WireConnection;289;1;290;0
WireConnection;182;1;322;0
WireConnection;282;0;281;2
WireConnection;282;1;283;0
WireConnection;184;0;24;0
WireConnection;102;0;103;0
WireConnection;102;1;53;0
WireConnection;102;2;191;0
WireConnection;285;0;286;0
WireConnection;285;1;279;0
WireConnection;285;2;191;0
WireConnection;316;0;315;0
WireConnection;316;1;182;0
WireConnection;316;2;282;0
WireConnection;284;0;285;0
WireConnection;284;1;102;0
WireConnection;284;2;282;0
WireConnection;291;0;289;0
WireConnection;317;1;316;0
WireConnection;317;2;291;0
WireConnection;186;0;185;0
WireConnection;293;1;284;0
WireConnection;293;2;291;0
WireConnection;329;0;291;0
WireConnection;329;1;191;0
WireConnection;308;0;291;0
WireConnection;308;1;298;0
WireConnection;0;0;293;0
WireConnection;0;1;317;0
WireConnection;0;3;308;0
WireConnection;0;4;186;0
WireConnection;0;5;329;0
ASEEND*/
//CHKSM=579B1729900E4BE195F81C2CB47860BAA63C27B4