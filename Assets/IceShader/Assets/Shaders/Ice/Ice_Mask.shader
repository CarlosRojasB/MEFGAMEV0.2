// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Ice/Ice_Mask"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Texture1("Ramp", 2D) = "white" {}
		_Normal("Normal", 2D) = "white" {}
		_Noise("Noise", 2D) = "white" {}
		_AlbedoColor("AlbedoColor", Color) = (0,0,0,0)
		_AlbedoMain("AlbedoMain", 2D) = "white" {}
		_NormalMain("NormalMain", 2D) = "bump" {}
		_SpecularSmAMain("SpecularSm(A)Main", 2D) = "white" {}
		_SpecularColor("SpecularColor", Color) = (0,0,0,0)
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_AoMain("AoMain", 2D) = "white" {}
		_AlbedoDetailMain("AlbedoDetailMain", 2D) = "white" {}
		_NormalDetail("NormalDetail", 2D) = "bump" {}
		_DetailNormalPower("DetailNormalPower", Float) = 1
		_DetailUVScale("DetailUVScale", Float) = 1
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 25.8
		[Header(Translucency)]
		_Translucency("Strength", Range( 0 , 50)) = 1
		_TransNormalDistortion("Normal Distortion", Range( 0 , 1)) = 0.1
		_TransScattering("Scaterring Falloff", Range( 1 , 50)) = 2
		_TransDirect("Direct", Range( 0 , 1)) = 1
		_TransAmbient("Ambient", Range( 0 , 1)) = 0.2
		_TransShadow("Shadow", Range( 0 , 1)) = 0.9
		_IceCracksColor2("IceCracksColor2", Color) = (0,0,0,0)
		_IceCracksColor("IceCracksColor", Color) = (0,0,0,0)
		_IceDepthColor2("IceDepthColor2", Color) = (0,0,0,0)
		_IceDepthColor("IceDepthColor", Color) = (0,0,0,0)
		_FresnelPower("FresnelPower", Float) = 0
		_FresnelScale("FresnelScale", Float) = 0
		_AlbedoFresnelColor("AlbedoFresnelColor", Color) = (1,1,1,0)
		_DepthFade("DepthFade", Float) = 0
		_CracksAreasPower("CracksAreasPower", Float) = 0.3
		_DarnessAreasPower("DarnessAreasPower", Float) = 4
		_Specular("Specular", Float) = 0.5
		_HighNumSteps("HighNumSteps", Float) = 40.7
		_HighIceDepthDark("HighIceDepthDark", Float) = 0.24
		_HighIceDepthPower("HighIceDepthPower", Float) = 2.41
		_HighIceMarchDistance("HighIceMarchDistance", Range( 0 , 0.51)) = 0.236
		_LowIceMarchDistance("LowIceMarchDistance", Range( 0 , 0.51)) = 0.232
		_LowIceNumSteps("LowIceNumSteps", Float) = 28.8
		_LowIceDepthDark("LowIceDepthDark", Float) = 0
		_LowIceDepthPower("LowIceDepthPower", Float) = 13.37
		_LowIceScale("LowIceScale", Range( -0.05 , 0.05)) = 0.001
		_LowIceTiling("LowIceTiling", Float) = 0.85
		_LowIceHeight("LowIceHeight", Float) = 8.8
		_LowIceDarkness("LowIceDarkness", Float) = 0.4
		_LowerIceNumSteps("LowerIceNumSteps", Float) = 28.8
		_LowerIceMarchDistance("LowerIceMarchDistance", Range( 0 , 0.51)) = 0.232
		_LowerIceScale("LowerIceScale", Range( -0.05 , 0.05)) = -0.0025
		_LowerIceTiling("LowerIceTiling", Float) = 0.45
		_LowerIceHeight("LowerIceHeight", Float) = 31.79
		_LowerIceDepthPower("LowerIceDepthPower", Float) = 13.37
		_LowerIceDepthDark("LowerIceDepthDark", Float) = 0
		_LowerIceDarkness("LowerIceDarkness", Float) = 0.2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Transparent+0" }
		Cull Back
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Tessellation.cginc"
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

		struct SurfaceOutputStandardSpecularCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half3 Specular;
			half Smoothness;
			half Occlusion;
			half Alpha;
			half3 Translucency;
		};

		uniform sampler2D _NormalMain;
		uniform float4 _NormalMain_ST;
		uniform float _DetailNormalPower;
		uniform sampler2D _NormalDetail;
		uniform float _DetailUVScale;
		uniform sampler2D _Normal;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _Noise;
		uniform float4 _Noise_ST;
		uniform float _CracksAreasPower;
		uniform float _DarnessAreasPower;
		uniform float IcePower;
		uniform sampler2D _AlbedoMain;
		uniform float4 _AlbedoMain_ST;
		uniform sampler2D _AlbedoDetailMain;
		uniform float4 _AlbedoColor;
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
		uniform float4 _SpecularColor;
		uniform sampler2D _SpecularSmAMain;
		uniform float4 _SpecularSmAMain_ST;
		uniform float _Specular;
		uniform float _Smoothness;
		uniform sampler2D _AoMain;
		uniform float4 _AoMain_ST;
		uniform half _Translucency;
		uniform half _TransNormalDistortion;
		uniform half _TransScattering;
		uniform half _TransDirect;
		uniform half _TransAmbient;
		uniform half _TransShadow;
		uniform float _EdgeLength;


		float3 MyCustomExpression386( float2 UV , float _marchDistance , float _numSteps , sampler2D _MainTex , float3 _viewDir , sampler2D _InnerRamp )
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


		float3 MyCustomExpression382( float2 UV , float _marchDistance , float _numSteps , sampler2D _MainTex , float3 _viewDir , sampler2D _InnerRamp )
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


		float3 MyCustomExpression381( float2 UV , float _marchDistance , float _numSteps , sampler2D _MainTex , float3 _viewDir , sampler2D _InnerRamp )
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


		float3 MyCustomExpression363( float2 UV , float _marchDistance , float _numSteps , sampler2D _MainTex , float3 _viewDir , sampler2D _InnerRamp )
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


		float3 MyCustomExpression355( float2 UV , float _marchDistance , float _numSteps , sampler2D _MainTex , float3 _viewDir , sampler2D _InnerRamp )
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


		float3 MyCustomExpression353( float2 UV , float _marchDistance , float _numSteps , sampler2D _MainTex , float3 _viewDir , sampler2D _InnerRamp )
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

		inline half4 LightingStandardSpecularCustom(SurfaceOutputStandardSpecularCustom s, half3 viewDir, UnityGI gi )
		{
			#if !DIRECTIONAL
			float3 lightAtten = gi.light.color;
			#else
			float3 lightAtten = lerp( _LightColor0.rgb, gi.light.color, _TransShadow );
			#endif
			half3 lightDir = gi.light.dir + s.Normal * _TransNormalDistortion;
			half transVdotL = pow( saturate( dot( viewDir, -lightDir ) ), _TransScattering );
			half3 translucency = lightAtten * (transVdotL * _TransDirect + gi.indirect.diffuse * _TransAmbient) * s.Translucency;
			half4 c = half4( s.Albedo * translucency * _Translucency, 0 );

			SurfaceOutputStandardSpecular r;
			r.Albedo = s.Albedo;
			r.Normal = s.Normal;
			r.Emission = s.Emission;
			r.Specular = s.Specular;
			r.Smoothness = s.Smoothness;
			r.Occlusion = s.Occlusion;
			r.Alpha = s.Alpha;
			return LightingStandardSpecular (r, viewDir, gi) + c;
		}

		inline void LightingStandardSpecularCustom_GI(SurfaceOutputStandardSpecularCustom s, UnityGIInput data, inout UnityGI gi )
		{
			#if defined(UNITY_PASS_DEFERRED) && UNITY_ENABLE_REFLECTION_BUFFERS
				gi = UnityGlobalIllumination(data, s.Occlusion, s.Normal);
			#else
				UNITY_GLOSSY_ENV_FROM_SURFACE( g, s, data );
				gi = UnityGlobalIllumination( data, s.Occlusion, s.Normal, g );
			#endif
		}

		void surf( Input i , inout SurfaceOutputStandardSpecularCustom o )
		{
			float2 uv_NormalMain = i.uv_texcoord * _NormalMain_ST.xy + _NormalMain_ST.zw;
			float2 temp_output_314_0 = ( _DetailUVScale * i.uv_texcoord );
			float2 uv0_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 temp_output_348_0 = ( uv0_MainTex * 2.0 );
			float2 SecondUV481 = temp_output_348_0;
			float2 FirstUV477 = uv0_MainTex;
			float2 uv_Noise = i.uv_texcoord * _Noise_ST.xy + _Noise_ST.zw;
			float4 tex2DNode486 = tex2D( _Noise, uv_Noise );
			float temp_output_490_0 = pow( tex2DNode486.g , _CracksAreasPower );
			float4 lerpResult499 = lerp( float4( UnpackNormal( tex2D( _Normal, SecondUV481 ) ) , 0.0 ) , tex2D( _Normal, FirstUV477 ) , temp_output_490_0);
			float clampResult497 = clamp( ( tex2DNode486.r * _DarnessAreasPower ) , 0.0 , 1.0 );
			float4 lerpResult502 = lerp( float4( 0,0,0,0 ) , lerpResult499 , clampResult497);
			float clampResult510 = clamp( ( tex2DNode486.b * (0.0 + (IcePower - 0.0) * (7.0 - 0.0) / (1.0 - 0.0)) ) , 0.0 , 1.0 );
			float4 lerpResult304 = lerp( float4( BlendNormals( UnpackNormal( tex2D( _NormalMain, uv_NormalMain ) ) , UnpackScaleNormal( tex2D( _NormalDetail, temp_output_314_0 ), _DetailNormalPower ) ) , 0.0 ) , lerpResult502 , clampResult510);
			o.Normal = lerpResult304.rgb;
			float2 uv_AlbedoMain = i.uv_texcoord * _AlbedoMain_ST.xy + _AlbedoMain_ST.zw;
			float temp_output_9_0_g1 = tex2DNode486.b;
			float temp_output_18_0_g1 = ( 1.0 - temp_output_9_0_g1 );
			float3 appendResult16_g1 = (float3(temp_output_18_0_g1 , temp_output_18_0_g1 , temp_output_18_0_g1));
			float2 UV386 = temp_output_348_0;
			float _marchDistance386 = _HighIceMarchDistance;
			float _numSteps386 = _HighNumSteps;
			sampler2D _MainTex386 = _MainTex;
			float3 _viewDir386 = i.viewDir;
			sampler2D _InnerRamp386 = _Texture1;
			float3 localMyCustomExpression386 = MyCustomExpression386( UV386 , _marchDistance386 , _numSteps386 , _MainTex386 , _viewDir386 , _InnerRamp386 );
			float temp_output_410_0 = ( 1.0 - localMyCustomExpression386.x );
			float4 lerpResult449 = lerp( ( temp_output_410_0 * _IceDepthColor2 ) , ( _IceCracksColor2 * localMyCustomExpression386.x ) , localMyCustomExpression386.x);
			float clampResult447 = clamp( ( 1.0 - pow( temp_output_410_0 , ( 0.5 * _HighIceDepthPower ) ) ) , 0.0 , 1.0 );
			float clampResult463 = clamp( ( localMyCustomExpression386.x + clampResult447 ) , 0.0 , 1.0 );
			float4 lerpResult470 = lerp( ( lerpResult449 * _HighIceDepthDark ) , lerpResult449 , clampResult463);
			float2 Offset366 = ( ( _LowIceHeight - 1 ) * i.viewDir.xy * _LowIceScale ) + ( temp_output_348_0 * _LowIceTiling );
			float2 UV382 = Offset366;
			float _marchDistance382 = _LowIceMarchDistance;
			float _numSteps382 = _LowIceNumSteps;
			sampler2D _MainTex382 = _MainTex;
			float3 _viewDir382 = i.viewDir;
			sampler2D _InnerRamp382 = _Texture1;
			float3 localMyCustomExpression382 = MyCustomExpression382( UV382 , _marchDistance382 , _numSteps382 , _MainTex382 , _viewDir382 , _InnerRamp382 );
			float temp_output_395_0 = ( 1.0 - localMyCustomExpression382.x );
			float4 lerpResult442 = lerp( ( temp_output_395_0 * _IceDepthColor2 ) , ( _IceCracksColor2 * localMyCustomExpression382.x ) , localMyCustomExpression382.x);
			float clampResult436 = clamp( ( 1.0 - pow( temp_output_395_0 , _LowIceDepthPower ) ) , 0.0 , 1.0 );
			float clampResult454 = clamp( ( localMyCustomExpression382.x + clampResult436 ) , 0.0 , 1.0 );
			float4 lerpResult464 = lerp( ( lerpResult442 * _LowIceDepthDark ) , lerpResult442 , clampResult454);
			float2 Offset365 = ( ( _LowerIceHeight - 1 ) * i.viewDir.xy * _LowerIceScale ) + ( _LowerIceTiling * temp_output_348_0 );
			float2 UV381 = Offset365;
			float _marchDistance381 = _LowerIceMarchDistance;
			float _numSteps381 = _LowerIceNumSteps;
			sampler2D _MainTex381 = _MainTex;
			float3 _viewDir381 = i.viewDir;
			sampler2D _InnerRamp381 = _Texture1;
			float3 localMyCustomExpression381 = MyCustomExpression381( UV381 , _marchDistance381 , _numSteps381 , _MainTex381 , _viewDir381 , _InnerRamp381 );
			float temp_output_403_0 = ( 1.0 - localMyCustomExpression381.x );
			float4 lerpResult440 = lerp( ( temp_output_403_0 * _IceDepthColor2 ) , ( _IceCracksColor2 * localMyCustomExpression381.x ) , localMyCustomExpression381.x);
			float clampResult437 = clamp( ( 1.0 - pow( temp_output_403_0 , _LowerIceDepthPower ) ) , 0.0 , 1.0 );
			float clampResult460 = clamp( ( localMyCustomExpression381.x + clampResult437 ) , 0.0 , 1.0 );
			float4 lerpResult465 = lerp( ( lerpResult440 * _LowerIceDepthDark ) , lerpResult440 , clampResult460);
			float4 temp_output_476_0 = ( lerpResult470 + ( _LowIceDarkness * lerpResult464 ) + ( _LowerIceDarkness * lerpResult465 ) );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth474 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD( ase_screenPos ))));
			float distanceDepth474 = abs( ( screenDepth474 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthFade ) );
			float clampResult480 = clamp( distanceDepth474 , 0.0 , 1.0 );
			float2 UV363 = uv0_MainTex;
			float _marchDistance363 = _HighIceMarchDistance;
			float _numSteps363 = _HighNumSteps;
			sampler2D _MainTex363 = _MainTex;
			float3 _viewDir363 = i.viewDir;
			sampler2D _InnerRamp363 = _Texture1;
			float3 localMyCustomExpression363 = MyCustomExpression363( UV363 , _marchDistance363 , _numSteps363 , _MainTex363 , _viewDir363 , _InnerRamp363 );
			float temp_output_378_0 = ( 1.0 - localMyCustomExpression363.x );
			float4 lerpResult415 = lerp( ( temp_output_378_0 * _IceDepthColor ) , ( _IceCracksColor * localMyCustomExpression363.x ) , localMyCustomExpression363.x);
			float clampResult413 = clamp( ( 1.0 - pow( temp_output_378_0 , _HighIceDepthPower ) ) , 0.0 , 1.0 );
			float clampResult435 = clamp( ( localMyCustomExpression363.x + clampResult413 ) , 0.0 , 1.0 );
			float4 lerpResult450 = lerp( ( lerpResult415 * _HighIceDepthDark ) , lerpResult415 , clampResult435);
			float2 Offset340 = ( ( _LowIceHeight - 1 ) * i.viewDir.xy * _LowIceScale ) + ( _LowIceTiling * uv0_MainTex );
			float2 UV355 = Offset340;
			float _marchDistance355 = _LowIceMarchDistance;
			float _numSteps355 = _LowIceNumSteps;
			sampler2D _MainTex355 = _MainTex;
			float3 _viewDir355 = i.viewDir;
			sampler2D _InnerRamp355 = _Texture1;
			float3 localMyCustomExpression355 = MyCustomExpression355( UV355 , _marchDistance355 , _numSteps355 , _MainTex355 , _viewDir355 , _InnerRamp355 );
			float temp_output_368_0 = ( 1.0 - localMyCustomExpression355.x );
			float4 lerpResult394 = lerp( ( temp_output_368_0 * _IceDepthColor ) , ( _IceCracksColor * localMyCustomExpression355.x ) , localMyCustomExpression355.x);
			float clampResult402 = clamp( ( 1.0 - pow( temp_output_368_0 , _LowIceDepthPower ) ) , 0.0 , 1.0 );
			float clampResult427 = clamp( ( localMyCustomExpression355.x + clampResult402 ) , 0.0 , 1.0 );
			float4 lerpResult444 = lerp( ( lerpResult394 * _LowIceDepthDark ) , lerpResult394 , clampResult427);
			float2 Offset343 = ( ( _LowerIceHeight - 1 ) * i.viewDir.xy * _LowerIceScale ) + ( _LowerIceTiling * uv0_MainTex );
			float2 UV353 = Offset343;
			float _marchDistance353 = _LowerIceMarchDistance;
			float _numSteps353 = _LowerIceNumSteps;
			sampler2D _MainTex353 = _MainTex;
			float3 _viewDir353 = i.viewDir;
			sampler2D _InnerRamp353 = _Texture1;
			float3 localMyCustomExpression353 = MyCustomExpression353( UV353 , _marchDistance353 , _numSteps353 , _MainTex353 , _viewDir353 , _InnerRamp353 );
			float temp_output_367_0 = ( 1.0 - localMyCustomExpression353.x );
			float4 lerpResult397 = lerp( ( temp_output_367_0 * _IceDepthColor ) , ( _IceCracksColor * localMyCustomExpression353.x ) , localMyCustomExpression353.x);
			float clampResult398 = clamp( ( 1.0 - pow( temp_output_367_0 , _LowerIceDepthPower ) ) , 0.0 , 1.0 );
			float clampResult430 = clamp( ( localMyCustomExpression353.x + clampResult398 ) , 0.0 , 1.0 );
			float4 lerpResult434 = lerp( ( lerpResult397 * _LowerIceDepthDark ) , lerpResult397 , clampResult430);
			float4 temp_output_458_0 = ( lerpResult450 + ( _LowIceDarkness * lerpResult444 ) + ( _LowerIceDarkness * lerpResult434 ) );
			float grayscale469 = Luminance(temp_output_458_0.rgb);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV467 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode467 = ( 0.0 + _FresnelScale * pow( 1.0 - fresnelNdotV467, _FresnelPower ) );
			float clampResult479 = clamp( ( grayscale469 + fresnelNode467 ) , 0.0 , 1.1 );
			float temp_output_483_0 = ( clampResult480 * clampResult479 );
			float4 lerpResult494 = lerp( ( temp_output_476_0 * _AlbedoFresnelColor ) , temp_output_476_0 , temp_output_483_0);
			float4 lerpResult492 = lerp( ( _AlbedoFresnelColor * temp_output_458_0 ) , temp_output_458_0 , temp_output_483_0);
			float4 lerpResult498 = lerp( lerpResult494 , lerpResult492 , temp_output_490_0);
			float4 lerpResult506 = lerp( float4( 0,0,0,0 ) , lerpResult498 , clampResult497);
			float4 lerpResult300 = lerp( ( float4( ( tex2D( _AlbedoMain, uv_AlbedoMain ).rgb * ( ( ( tex2D( _AlbedoDetailMain, temp_output_314_0 ).rgb * (unity_ColorSpaceDouble).rgb ) * temp_output_9_0_g1 ) + appendResult16_g1 ) ) , 0.0 ) * _AlbedoColor ) , lerpResult506 , clampResult510);
			o.Albedo = lerpResult300.rgb;
			float2 uv_SpecularSmAMain = i.uv_texcoord * _SpecularSmAMain_ST.xy + _SpecularSmAMain_ST.zw;
			float4 tex2DNode299 = tex2D( _SpecularSmAMain, uv_SpecularSmAMain );
			float4 temp_cast_8 = (( clampResult497 * _Specular )).xxxx;
			float4 lerpResult316 = lerp( ( _SpecularColor * tex2DNode299 ) , temp_cast_8 , clampResult510);
			o.Specular = lerpResult316.rgb;
			float Smoothness491 = localMyCustomExpression363.x;
			float lerpResult305 = lerp( ( tex2DNode299.a * _Smoothness ) , ( 1.0 - Smoothness491 ) , clampResult510);
			o.Smoothness = lerpResult305;
			float2 uv_AoMain = i.uv_texcoord * _AoMain_ST.xy + _AoMain_ST.zw;
			float lerpResult306 = lerp( tex2D( _AoMain, uv_AoMain ).r , ( clampResult497 * temp_output_483_0 ) , clampResult510);
			o.Occlusion = lerpResult306;
			float lerpResult519 = lerp( 0.0 , 0.5 , clampResult510);
			float3 temp_cast_10 = (lerpResult519).xxx;
			o.Translucency = temp_cast_10;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardSpecularCustom keepalpha fullforwardshadows exclude_path:deferred vertex:vertexDataFunc tessellate:tessFunction 

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
				SurfaceOutputStandardSpecularCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecularCustom, o )
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
-1673;63;1631;974;-1430.357;-460.8934;1.3;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;322;-3897.668,1078.253;Float;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;None;079d3865152eada4b8f2a3af91979ff8;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;326;-3002.022,1725.927;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;323;-3010.027,608.68;Float;False;Property;_LowIceTiling;LowIceTiling;51;0;Create;True;0;0;False;0;0.85;0.85;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;324;-2960.679,1624.366;Float;False;Property;_LowerIceTiling;LowerIceTiling;57;0;Create;True;0;0;False;0;0.45;0.45;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;325;-3048.637,709.127;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;334;-2775.794,657.215;Float;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;333;-2806.731,780.982;Float;False;Property;_LowIceHeight;LowIceHeight;52;0;Create;True;0;0;False;0;8.8;-75.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;332;-2567.287,-2080.448;Float;False;Constant;_Float1;Float 1;38;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;335;-2803.113,960.197;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;328;-2760.116,1797.782;Float;False;Property;_LowerIceHeight;LowerIceHeight;58;0;Create;True;0;0;False;0;31.79;46.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;327;-2756.498,1976.997;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;329;-2831.97,1882.783;Float;False;Property;_LowerIceScale;LowerIceScale;56;0;Create;True;0;0;False;0;-0.0025;-0.0061;-0.05;0.05;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;331;-2878.586,865.9827;Float;False;Property;_LowIceScale;LowIceScale;50;0;Create;True;0;0;False;0;0.001;0.001;-0.05;0.05;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;330;-2729.179,1674.015;Float;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;345;-2522.241,1140.94;Float;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexturePropertyNode;344;-2436.271,1305.976;Float;True;Property;_Texture1;Ramp;1;0;Create;False;0;0;False;0;None;d603acd0ed242ad4ea6a8fb04ee90016;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.ParallaxMappingNode;343;-2483.452,1824.488;Float;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;348;-2371.744,-2099.305;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;347;-2494.029,1055.84;Float;False;Property;_LowIceNumSteps;LowIceNumSteps;47;0;Create;True;0;0;False;0;28.8;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;346;-3019.438,73.27519;Float;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;337;-2447.412,2072.64;Float;False;Property;_LowerIceNumSteps;LowerIceNumSteps;54;0;Create;True;0;0;False;0;28.8;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;336;-3087.343,2061.772;Float;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;339;-2661.176,1199.472;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ParallaxMappingNode;340;-2530.069,807.6879;Float;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;338;-2495.261,1991.554;Float;False;Property;_LowerIceMarchDistance;LowerIceMarchDistance;55;0;Create;True;0;0;False;0;0.232;0.232;0;0.51;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;342;-2614.561,2216.271;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;341;-2541.878,974.7542;Float;False;Property;_LowIceMarchDistance;LowIceMarchDistance;46;0;Create;True;0;0;False;0;0.232;0.091;0;0.51;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;356;-2141.419,34.9641;Float;False;Property;_HighNumSteps;HighNumSteps;42;0;Create;True;0;0;False;0;40.7;30;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;357;-2226.084,-42.7748;Float;False;Property;_HighIceMarchDistance;HighIceMarchDistance;45;0;Create;True;0;0;False;0;0.236;0.289;0;0.51;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;349;-2101.422,-1586.013;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CustomExpressionNode;355;-2091.531,996.458;Float;False;float3 InnerStructure = float3(0, 0, 0)@$float2 UV2 = UV@$float offset = 1@$for (float d = 0@ d < _marchDistance@ d += _marchDistance / _numSteps)${$	UV2 -= (_viewDir*d)/_numSteps *  tex2D (_MainTex, UV).g@$	float4 Ldensity = tex2D(_MainTex, UV2).r@$	InnerStructure += saturate(Ldensity[0])*tex2D(_InnerRamp, float2(1/_numSteps * offset, 0.5))@$	offset ++@$}$return InnerStructure@;3;False;6;True;UV;FLOAT2;0,0;In;;Float;True;_marchDistance;FLOAT;0;In;;Float;True;_numSteps;FLOAT;0;In;;Float;True;_MainTex;SAMPLER2D;;In;;Float;True;_viewDir;FLOAT3;0,0,0;In;;Float;True;_InnerRamp;SAMPLER2D;;In;;Float;My Custom Expression;True;False;0;6;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;SAMPLER2D;;False;4;FLOAT3;0,0,0;False;5;SAMPLER2D;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;351;-2230.633,727.5003;Float;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.WireNode;352;-2723.103,224.1898;Float;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;354;-2351.565,184.5965;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;350;-2210.072,-178.3973;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CustomExpressionNode;353;-2044.914,2013.258;Float;False;float3 InnerStructure = float3(0, 0, 0)@$float2 UV2 = UV@$float offset = 1@$for (float d = 0@ d < _marchDistance@ d += _marchDistance / _numSteps)${$	UV2 -= (_viewDir*d)/_numSteps *  tex2D (_MainTex, UV).g@$	float4 Ldensity = tex2D(_MainTex, UV2).r@$	InnerStructure += saturate(Ldensity[0])*tex2D(_InnerRamp, float2(1/_numSteps * offset, 0.5))@$	offset ++@$}$return InnerStructure@;3;False;6;True;UV;FLOAT2;0,0;In;;Float;True;_marchDistance;FLOAT;0;In;;Float;True;_numSteps;FLOAT;0;In;;Float;True;_MainTex;SAMPLER2D;;In;;Float;True;_viewDir;FLOAT3;0,0,0;In;;Float;True;_InnerRamp;SAMPLER2D;;In;;Float;My Custom Expression;True;False;0;6;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;SAMPLER2D;;False;4;FLOAT3;0,0,0;False;5;SAMPLER2D;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;358;-1730.91,-1952.5;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CustomExpressionNode;363;-1854.284,47.48412;Float;False;float3 InnerStructure = float3(0, 0, 0)@$float2 UV2 = UV@$float offset = 1@$for (float d = 0@ d < _marchDistance@ d += _marchDistance / _numSteps)${$	UV2 -= (_viewDir*d)/_numSteps *  tex2D (_MainTex, UV).g@$	float4 Ldensity = tex2D(_MainTex, UV2).r@$	InnerStructure += saturate(Ldensity[0])*tex2D(_InnerRamp, float2(1/_numSteps * offset, 0.5))@$	offset ++@$}$return InnerStructure@;3;False;6;True;UV;FLOAT2;0,0;In;;Float;True;_marchDistance;FLOAT;0;In;;Float;True;_numSteps;FLOAT;0;In;;Float;True;_MainTex;SAMPLER2D;;In;;Float;True;_viewDir;FLOAT3;0,0,0;In;;Float;True;_InnerRamp;SAMPLER2D;;In;;Float;My Custom Expression;True;False;0;6;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;SAMPLER2D;;False;4;FLOAT3;0,0,0;False;5;SAMPLER2D;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;364;-1693.422,2013.984;Float;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;361;-1695.295,-976.701;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;360;-1700.159,-2101.384;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;359;-1665.977,-1088.683;Float;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;362;-1740.039,997.1841;Float;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;369;-1175.224,2409.338;Float;False;Property;_LowerIceDepthPower;LowerIceDepthPower;59;0;Create;True;0;0;False;0;13.37;13.37;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ParallaxMappingNode;365;-1411.249,-1088.21;Float;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;367;-1274.296,2106.596;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;368;-1320.912,1089.796;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;370;-1164.101,1370.887;Float;False;Property;_LowIceDepthPower;LowIceDepthPower;49;0;Create;True;0;0;False;0;13.37;13.37;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;372;-1512.018,47.90007;Float;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;373;-1428.075,-1827.26;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ParallaxMappingNode;366;-1457.867,-2105.009;Float;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;371;-1317.158,-806.5241;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WireNode;374;-1797.076,-2691.57;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CustomExpressionNode;382;-1019.328,-1916.239;Float;False;float3 InnerStructure = float3(0, 0, 0)@$float2 UV2 = UV@$float offset = 1@$for (float d = 0@ d < _marchDistance@ d += _marchDistance / _numSteps)${$	UV2 -= (_viewDir*d)/_numSteps *  tex2D (_MainTex, UV).g@$	float4 Ldensity = tex2D(_MainTex, UV2).r@$	InnerStructure += saturate(Ldensity[0])*tex2D(_InnerRamp, float2(1/_numSteps * offset, 0.5))@$	offset ++@$}$return InnerStructure@;3;False;6;True;UV;FLOAT2;0,0;In;;Float;True;_marchDistance;FLOAT;0;In;;Float;True;_numSteps;FLOAT;0;In;;Float;True;_MainTex;SAMPLER2D;;In;;Float;True;_viewDir;FLOAT3;0,0,0;In;;Float;True;_InnerRamp;SAMPLER2D;;In;;Float;My Custom Expression;True;False;0;6;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;SAMPLER2D;;False;4;FLOAT3;0,0,0;False;5;SAMPLER2D;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CustomExpressionNode;381;-972.7109,-899.439;Float;False;float3 InnerStructure = float3(0, 0, 0)@$float2 UV2 = UV@$float offset = 1@$for (float d = 0@ d < _marchDistance@ d += _marchDistance / _numSteps)${$	UV2 -= (_viewDir*d)/_numSteps *  tex2D (_MainTex, UV).g@$	float4 Ldensity = tex2D(_MainTex, UV2).r@$	InnerStructure += saturate(Ldensity[0])*tex2D(_InnerRamp, float2(1/_numSteps * offset, 0.5))@$	offset ++@$}$return InnerStructure@;3;False;6;True;UV;FLOAT2;0,0;In;;Float;True;_marchDistance;FLOAT;0;In;;Float;True;_numSteps;FLOAT;0;In;;Float;True;_MainTex;SAMPLER2D;;In;;Float;True;_viewDir;FLOAT3;0,0,0;In;;Float;True;_InnerRamp;SAMPLER2D;;In;;Float;My Custom Expression;True;False;0;6;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;SAMPLER2D;;False;4;FLOAT3;0,0,0;False;5;SAMPLER2D;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;378;-1217.013,140.5125;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;383;-1173.841,-2777.695;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PowerNode;379;-935.2896,1286.953;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;380;-1080.63,427.817;Float;False;Property;_HighIceDepthPower;HighIceDepthPower;44;0;Create;True;0;0;False;0;2.41;7.57;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;375;-1745.627,1341.851;Float;False;Property;_IceDepthColor;IceDepthColor;34;0;Create;True;0;0;False;0;0,0,0,0;0.4720986,0.5140231,0.9716981,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;376;-888.673,2303.752;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;377;-1767.883,595.6341;Float;False;Property;_IceCracksColor;IceCracksColor;32;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;389;-667.8361,-1915.513;Float;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;384;-1121.586,876.0585;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CustomExpressionNode;386;-782.0808,-2865.212;Float;False;float3 InnerStructure = float3(0, 0, 0)@$float2 UV2 = UV@$float offset = 1@$for (float d = 0@ d < _marchDistance@ d += _marchDistance / _numSteps)${$	UV2 -= (_viewDir*d)/_numSteps *  tex2D (_MainTex, UV).g@$	float4 Ldensity = tex2D(_MainTex, UV2).r@$	InnerStructure += saturate(Ldensity[0])*tex2D(_InnerRamp, float2(1/_numSteps * offset, 0.5))@$	offset ++@$}$return InnerStructure@;3;False;6;True;UV;FLOAT2;0,0;In;;Float;True;_marchDistance;FLOAT;0;In;;Float;True;_numSteps;FLOAT;0;In;;Float;True;_MainTex;SAMPLER2D;;In;;Float;True;_viewDir;FLOAT3;0,0,0;In;;Float;True;_InnerRamp;SAMPLER2D;;In;;Float;My Custom Expression;True;False;0;6;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;SAMPLER2D;;False;4;FLOAT3;0,0,0;False;5;SAMPLER2D;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;388;-621.2195,-898.713;Float;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.PowerNode;385;-831.3909,337.6692;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;387;-772.2036,1242.352;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;392;-1074.969,1892.858;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;393;-725.587,2259.152;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;390;-1097.223,1090.588;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;391;-1050.607,2107.388;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;395;-248.7091,-1822.901;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;403;-202.0929,-806.1015;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;398;-542.9038,2188.161;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;402;-589.5204,1171.361;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;396;-439.815,-2864.796;Float;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.LerpOp;397;-860.6786,1966.086;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;394;-907.295,949.2861;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;399;-993.3246,141.3041;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;400;-668.305,293.0691;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;401;-1017.687,-73.2256;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;413;-485.6216,222.0779;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;407;71.91106,-2468.644;Float;False;2;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;406;136.9131,-1625.744;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;412;-658.5707,1899.766;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;415;-803.3963,0.002609253;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;414;-507.6585,1916.529;Float;False;Property;_LowerIceDepthDark;LowerIceDepthDark;60;0;Create;True;0;0;False;0;0;1.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;405;-695.6807,-2317.062;Float;False;Property;_IceCracksColor2;IceCracksColor2;31;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;408;-554.2751,899.7297;Float;False;Property;_LowIceDepthDark;LowIceDepthDark;48;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;404;-367.3032,2127.161;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;411;-413.9199,1110.362;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;409;-705.1873,882.9664;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;417;-673.4245,-1570.846;Float;False;Property;_IceDepthColor2;IceDepthColor2;33;0;Create;True;0;0;False;0;0,0,0,0;0.4720986,0.5140231,0.9716981,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;416;183.5298,-608.9457;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;410;-144.8107,-2772.184;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;431;-450.3766,-49.5544;Float;False;Property;_HighIceDepthDark;HighIceDepthDark;43;0;Create;True;0;0;False;0;0.24;0.24;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;420;-2.766556,-1019.84;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;421;346.6156,-653.5457;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;422;-49.38326,-2036.638;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;426;240.8121,-2575.027;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;429;299.9995,-1670.345;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;430;-213.9837,2073.946;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;424;21.59575,-805.3095;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;425;-25.02058,-1822.109;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;419;-310.0215,161.078;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;418;-328.0742,833.7298;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;423;-281.4576,1850.529;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;428;-601.2888,-66.31801;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;427;-260.6002,1057.146;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;443;54.51561,-2985.922;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;438;403.8983,-2619.627;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;437;529.3003,-724.5367;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;439;78.87791,-2771.393;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;440;211.5239,-946.612;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;442;164.9078,-1963.411;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;432;-52.99684,1659.457;Float;False;Property;_LowerIceDarkness;LowerIceDarkness;61;0;Create;True;0;0;False;0;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;434;-2.340958,1951.366;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;433;-21.73994,736.9255;Float;False;Property;_LowIceDarkness;LowIceDarkness;53;0;Create;True;0;0;False;0;0.4;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;435;-156.7016,107.862;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;436;482.6833,-1741.336;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;444;-48.95753,934.5662;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;441;-224.1754,-115.5542;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;452;658.2833,-1802.335;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;453;367.0155,-2029.731;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;451;413.6323,-1012.931;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;447;586.5823,-2690.619;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;450;20.82335,-17.1545;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;445;704.9003,-785.5367;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;448;212.9548,848.2333;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;449;268.8068,-2912.694;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;446;218.4378,1755.231;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;457;663.6445,1708.573;Float;False;Property;_FresnelScale;FresnelScale;36;0;Create;True;0;0;False;0;0;1.58;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;455;744.1293,-2078.967;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;456;664.6445,1803.573;Float;False;Property;_FresnelPower;FresnelPower;35;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;458;645.9923,829.9177;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;462;790.7454,-1062.169;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;459;291.8552,-2819.851;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;461;762.1813,-2751.619;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;454;811.6023,-1855.551;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;460;858.2194,-838.7518;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;468;668.9683,-2869.087;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;463;915.5013,-2804.834;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;465;1069.862,-961.332;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;469;938.4565,1584.244;Float;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;467;904.5065,1678.997;Float;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;464;1023.246,-1978.131;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;466;907.5275,1447.684;Float;False;Property;_DepthFade;DepthFade;38;0;Create;True;0;0;False;0;0;0.23;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;473;1290.641,-1157.467;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;470;1093.026,-2929.851;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;471;1243.431,1586.902;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;474;1153.638,1429.784;Float;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;472;1285.158,-2064.464;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;315;1429.945,1791.646;Float;False;Property;_DetailUVScale;DetailUVScale;18;0;Create;True;0;0;False;0;1;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;481;-1982.412,-2193.257;Float;False;SecondUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;477;-1607.251,-192.7155;Float;False;FirstUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;480;1444.653,1430.883;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;478;938.6733,-86.15547;Float;False;Property;_AlbedoFresnelColor;AlbedoFresnelColor;37;0;Create;True;0;0;False;0;1,1,1,0;0.1308391,0.1401414,0.3235294,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;479;1446.935,1587.675;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;313;1416.849,1909.135;Float;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;476;1723.009,-2085.187;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;487;1607.714,344.9196;Float;False;Property;_DarnessAreasPower;DarnessAreasPower;40;0;Create;True;0;0;False;0;4;4.56;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;486;1546.535,46.72258;Float;True;Property;_Noise;Noise;3;0;Create;True;0;0;False;0;004603b76f5639d47b5bc5e454e8e77d;004603b76f5639d47b5bc5e454e8e77d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;483;1646.669,1495.265;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;511;1897.602,1446.043;Float;False;Global;IcePower;IcePower;40;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;485;1609.091,634.1328;Float;False;481;SecondUV;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;488;1491.009,-106.7617;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;484;1619.68,838.7606;Float;False;477;FirstUV;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;482;1305.133,454.1245;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;314;1655.069,1849.755;Float;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;489;1618.192,239.4179;Float;False;Property;_CracksAreasPower;CracksAreasPower;39;0;Create;True;0;0;False;0;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;493;1925.029,817.2972;Float;True;Property;_Normal;Normal;2;0;Create;True;0;0;False;0;None;3c7946a014646b7459f4690ea68481bd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;490;1934.192,178.418;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;495;1933.799,328.0293;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;312;1901.338,1927.74;Float;False;Property;_DetailNormalPower;DetailNormalPower;17;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;496;1923.481,612.4682;Float;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;None;None;True;0;True;bump;Auto;True;Instance;493;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;309;1883.404,1230.802;Float;True;Property;_AlbedoDetailMain;AlbedoDetailMain;11;0;Create;True;0;0;False;0;5eef539c92cfc364ab5c858f82867fcd;5eef539c92cfc364ab5c858f82867fcd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;296;1879.998,1021.8;Float;True;Property;_AlbedoMain;AlbedoMain;5;0;Create;True;0;0;False;0;db74b3e92e664ee4dbf53df49e200c7a;db74b3e92e664ee4dbf53df49e200c7a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;494;1935.625,-106.6559;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;512;2239.03,1373.787;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;7;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;492;1912.72,446.1125;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;491;-1170.573,-184.4458;Float;False;Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;516;2573.252,1755.386;Float;False;Property;_SpecularColor;SpecularColor;8;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;499;2328.421,713.0936;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;501;2343.089,964.3276;Float;False;491;Smoothness;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;299;2572.651,1942.014;Float;True;Property;_SpecularSmAMain;SpecularSm(A)Main;7;0;Create;True;0;0;False;0;4ac4df7211863e44d890cc38f7b4e248;4ac4df7211863e44d890cc38f7b4e248;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;297;2190.431,1611.998;Float;True;Property;_NormalMain;NormalMain;6;0;Create;True;0;0;False;0;74bac2e4615663646b8ca2a5afe06fc2;74bac2e4615663646b8ca2a5afe06fc2;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;308;2281.913,1069.704;Float;False;Detail Albedo;12;;1;29e5a290b15a7884983e27c8f1afaa8c;0;3;12;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;9;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;310;2195.012,1821.708;Float;True;Property;_NormalDetail;NormalDetail;16;0;Create;True;0;0;False;0;509531440c72f634ea209e36f00130ec;509531440c72f634ea209e36f00130ec;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;509;2480.982,1349.858;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;518;2642.715,2151.131;Float;False;Property;_Smoothness;Smoothness;9;0;Create;True;0;0;False;0;0;0.78;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;498;2233.007,133.1515;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;320;2283.802,1186.012;Float;False;Property;_AlbedoColor;AlbedoColor;4;0;Create;True;0;0;False;0;0,0,0,0;0.8970588,0.4749135,0.4749135,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;500;2366.826,849.5699;Float;False;Property;_Specular;Specular;41;0;Create;True;0;0;False;0;0.5;0.43;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;497;2236.458,327.1578;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;505;2594.672,831.3353;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;510;2717.393,1251.209;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;517;3081.236,1716.935;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;502;2622.613,691.3268;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;319;2654.151,1069.224;Float;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;508;3203.097,1464.786;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;515;2873.822,1681.839;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;506;2614.671,466.333;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;513;3399.866,1779.303;Float;False;Constant;_Translucency;Translucency;47;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;311;2559.612,1616.208;Float;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;504;2592.32,968.5554;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;298;3040.155,1915.524;Float;True;Property;_AoMain;AoMain;10;0;Create;True;0;0;False;0;5a76f7f3d709b9d4693b01e0be1d6a6d;5a76f7f3d709b9d4693b01e0be1d6a6d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;300;2998.027,670.6746;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;519;3611.322,1625.499;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;304;3100.012,874.5226;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;305;3352.79,1261.214;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;316;3225.557,1067.325;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;306;3468.738,1444.274;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3867.549,795.2479;Float;False;True;6;Float;ASEMaterialInspector;0;0;StandardSpecular;Ice/Ice_Mask;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Translucent;0.5;True;True;0;False;Opaque;;Transparent;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;25.8;10;25;False;0.5;True;0;5;False;-1;1;False;-1;8;5;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;24;-1;19;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;326;2;322;0
WireConnection;325;2;322;0
WireConnection;334;0;323;0
WireConnection;334;1;325;0
WireConnection;330;0;324;0
WireConnection;330;1;326;0
WireConnection;345;0;322;0
WireConnection;343;0;330;0
WireConnection;343;1;328;0
WireConnection;343;2;329;0
WireConnection;343;3;327;0
WireConnection;348;0;325;0
WireConnection;348;1;332;0
WireConnection;346;0;322;0
WireConnection;336;0;322;0
WireConnection;340;0;334;0
WireConnection;340;1;333;0
WireConnection;340;2;331;0
WireConnection;340;3;335;0
WireConnection;349;0;348;0
WireConnection;355;0;340;0
WireConnection;355;1;341;0
WireConnection;355;2;347;0
WireConnection;355;3;345;0
WireConnection;355;4;339;0
WireConnection;355;5;344;0
WireConnection;351;0;344;0
WireConnection;352;0;322;0
WireConnection;350;2;346;0
WireConnection;353;0;343;0
WireConnection;353;1;338;0
WireConnection;353;2;337;0
WireConnection;353;3;336;0
WireConnection;353;4;342;0
WireConnection;353;5;344;0
WireConnection;363;0;350;0
WireConnection;363;1;357;0
WireConnection;363;2;356;0
WireConnection;363;3;352;0
WireConnection;363;4;354;0
WireConnection;363;5;351;0
WireConnection;364;0;353;0
WireConnection;360;0;348;0
WireConnection;360;1;323;0
WireConnection;359;0;324;0
WireConnection;359;1;349;0
WireConnection;362;0;355;0
WireConnection;365;0;359;0
WireConnection;365;1;328;0
WireConnection;365;2;329;0
WireConnection;365;3;361;0
WireConnection;367;0;364;0
WireConnection;368;0;362;0
WireConnection;372;0;363;0
WireConnection;366;0;360;0
WireConnection;366;1;333;0
WireConnection;366;2;331;0
WireConnection;366;3;358;0
WireConnection;374;0;348;0
WireConnection;382;0;366;0
WireConnection;382;1;341;0
WireConnection;382;2;347;0
WireConnection;382;3;322;0
WireConnection;382;4;373;0
WireConnection;382;5;344;0
WireConnection;381;0;365;0
WireConnection;381;1;338;0
WireConnection;381;2;337;0
WireConnection;381;3;322;0
WireConnection;381;4;371;0
WireConnection;381;5;344;0
WireConnection;378;0;372;0
WireConnection;379;0;368;0
WireConnection;379;1;370;0
WireConnection;376;0;367;0
WireConnection;376;1;369;0
WireConnection;389;0;382;0
WireConnection;384;0;377;0
WireConnection;384;1;362;0
WireConnection;386;0;374;0
WireConnection;386;1;357;0
WireConnection;386;2;356;0
WireConnection;386;3;322;0
WireConnection;386;4;383;0
WireConnection;386;5;344;0
WireConnection;388;0;381;0
WireConnection;385;0;378;0
WireConnection;385;1;380;0
WireConnection;387;0;379;0
WireConnection;392;0;377;0
WireConnection;392;1;364;0
WireConnection;393;0;376;0
WireConnection;390;0;368;0
WireConnection;390;1;375;0
WireConnection;391;0;367;0
WireConnection;391;1;375;0
WireConnection;395;0;389;0
WireConnection;403;0;388;0
WireConnection;398;0;393;0
WireConnection;402;0;387;0
WireConnection;396;0;386;0
WireConnection;397;0;391;0
WireConnection;397;1;392;0
WireConnection;397;2;364;0
WireConnection;394;0;390;0
WireConnection;394;1;384;0
WireConnection;394;2;362;0
WireConnection;399;0;378;0
WireConnection;399;1;375;0
WireConnection;400;0;385;0
WireConnection;401;0;377;0
WireConnection;401;1;372;0
WireConnection;413;0;400;0
WireConnection;407;1;380;0
WireConnection;406;0;395;0
WireConnection;406;1;370;0
WireConnection;412;0;397;0
WireConnection;415;0;399;0
WireConnection;415;1;401;0
WireConnection;415;2;372;0
WireConnection;404;0;364;0
WireConnection;404;1;398;0
WireConnection;411;0;362;0
WireConnection;411;1;402;0
WireConnection;409;0;394;0
WireConnection;416;0;403;0
WireConnection;416;1;369;0
WireConnection;410;0;396;0
WireConnection;420;0;405;0
WireConnection;420;1;388;0
WireConnection;421;0;416;0
WireConnection;422;0;405;0
WireConnection;422;1;389;0
WireConnection;426;0;410;0
WireConnection;426;1;407;0
WireConnection;429;0;406;0
WireConnection;430;0;404;0
WireConnection;424;0;403;0
WireConnection;424;1;417;0
WireConnection;425;0;395;0
WireConnection;425;1;417;0
WireConnection;419;0;372;0
WireConnection;419;1;413;0
WireConnection;418;0;409;0
WireConnection;418;1;408;0
WireConnection;423;0;412;0
WireConnection;423;1;414;0
WireConnection;428;0;415;0
WireConnection;427;0;411;0
WireConnection;443;0;405;0
WireConnection;443;1;396;0
WireConnection;438;0;426;0
WireConnection;437;0;421;0
WireConnection;439;0;410;0
WireConnection;439;1;417;0
WireConnection;440;0;424;0
WireConnection;440;1;420;0
WireConnection;440;2;388;0
WireConnection;442;0;425;0
WireConnection;442;1;422;0
WireConnection;442;2;389;0
WireConnection;434;0;423;0
WireConnection;434;1;397;0
WireConnection;434;2;430;0
WireConnection;435;0;419;0
WireConnection;436;0;429;0
WireConnection;444;0;418;0
WireConnection;444;1;394;0
WireConnection;444;2;427;0
WireConnection;441;0;428;0
WireConnection;441;1;431;0
WireConnection;452;0;389;0
WireConnection;452;1;436;0
WireConnection;453;0;442;0
WireConnection;451;0;440;0
WireConnection;447;0;438;0
WireConnection;450;0;441;0
WireConnection;450;1;415;0
WireConnection;450;2;435;0
WireConnection;445;0;388;0
WireConnection;445;1;437;0
WireConnection;448;0;433;0
WireConnection;448;1;444;0
WireConnection;449;0;439;0
WireConnection;449;1;443;0
WireConnection;449;2;396;0
WireConnection;446;0;432;0
WireConnection;446;1;434;0
WireConnection;455;0;453;0
WireConnection;455;1;408;0
WireConnection;458;0;450;0
WireConnection;458;1;448;0
WireConnection;458;2;446;0
WireConnection;462;0;451;0
WireConnection;462;1;414;0
WireConnection;459;0;449;0
WireConnection;461;0;396;0
WireConnection;461;1;447;0
WireConnection;454;0;452;0
WireConnection;460;0;445;0
WireConnection;468;0;459;0
WireConnection;468;1;431;0
WireConnection;463;0;461;0
WireConnection;465;0;462;0
WireConnection;465;1;440;0
WireConnection;465;2;460;0
WireConnection;469;0;458;0
WireConnection;467;2;457;0
WireConnection;467;3;456;0
WireConnection;464;0;455;0
WireConnection;464;1;442;0
WireConnection;464;2;454;0
WireConnection;473;0;432;0
WireConnection;473;1;465;0
WireConnection;470;0;468;0
WireConnection;470;1;449;0
WireConnection;470;2;463;0
WireConnection;471;0;469;0
WireConnection;471;1;467;0
WireConnection;474;0;466;0
WireConnection;472;0;433;0
WireConnection;472;1;464;0
WireConnection;481;0;348;0
WireConnection;477;0;350;0
WireConnection;480;0;474;0
WireConnection;479;0;471;0
WireConnection;476;0;470;0
WireConnection;476;1;472;0
WireConnection;476;2;473;0
WireConnection;483;0;480;0
WireConnection;483;1;479;0
WireConnection;488;0;476;0
WireConnection;488;1;478;0
WireConnection;482;0;478;0
WireConnection;482;1;458;0
WireConnection;314;0;315;0
WireConnection;314;1;313;0
WireConnection;493;1;484;0
WireConnection;490;0;486;2
WireConnection;490;1;489;0
WireConnection;495;0;486;1
WireConnection;495;1;487;0
WireConnection;496;1;485;0
WireConnection;309;1;314;0
WireConnection;494;0;488;0
WireConnection;494;1;476;0
WireConnection;494;2;483;0
WireConnection;512;0;511;0
WireConnection;492;0;482;0
WireConnection;492;1;458;0
WireConnection;492;2;483;0
WireConnection;491;0;372;0
WireConnection;499;0;496;0
WireConnection;499;1;493;0
WireConnection;499;2;490;0
WireConnection;308;12;296;0
WireConnection;308;11;309;0
WireConnection;308;9;486;3
WireConnection;310;1;314;0
WireConnection;310;5;312;0
WireConnection;509;0;486;3
WireConnection;509;1;512;0
WireConnection;498;0;494;0
WireConnection;498;1;492;0
WireConnection;498;2;490;0
WireConnection;497;0;495;0
WireConnection;505;0;497;0
WireConnection;505;1;500;0
WireConnection;510;0;509;0
WireConnection;517;0;299;4
WireConnection;517;1;518;0
WireConnection;502;1;499;0
WireConnection;502;2;497;0
WireConnection;319;0;308;0
WireConnection;319;1;320;0
WireConnection;508;0;497;0
WireConnection;508;1;483;0
WireConnection;515;0;516;0
WireConnection;515;1;299;0
WireConnection;506;1;498;0
WireConnection;506;2;497;0
WireConnection;311;0;297;0
WireConnection;311;1;310;0
WireConnection;504;0;501;0
WireConnection;300;0;319;0
WireConnection;300;1;506;0
WireConnection;300;2;510;0
WireConnection;519;1;513;0
WireConnection;519;2;510;0
WireConnection;304;0;311;0
WireConnection;304;1;502;0
WireConnection;304;2;510;0
WireConnection;305;0;517;0
WireConnection;305;1;504;0
WireConnection;305;2;510;0
WireConnection;316;0;515;0
WireConnection;316;1;505;0
WireConnection;316;2;510;0
WireConnection;306;0;298;1
WireConnection;306;1;508;0
WireConnection;306;2;510;0
WireConnection;0;0;300;0
WireConnection;0;1;304;0
WireConnection;0;3;316;0
WireConnection;0;4;305;0
WireConnection;0;5;306;0
WireConnection;0;7;519;0
ASEEND*/
//CHKSM=D83CB629880B1F4F7947EF42F3CB4320FFC38D5B