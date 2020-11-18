Description
   Ice Shader is a shader that will help you in creating your game. Also there are particle systems, lighting, script and models to display the shader environment.
   The models were taken from a free assets Viking Village and 3D Game Kit by UNITY TECHNOLOGIES, Rock and Boulders 2 by MANUFACTURA 4K from unity asset store for demonstration purpose.
   The shader was created using Amplify Shader Editor(1.6.4).
   To control ice use "Shader.SetGlobalFloat("IcePower", FLOAT)" where FLOAT is a number from 0 to 1 (off and on respectively).


Shader Property
   * MainText - special texture for ice, use from folder "Assets\Textures\ice_a.tga". It's albedo
   * Ramp - special texture for ice, use from folder "Assets\Textures\ramp.tga". It's crack pattern
   * Normal - special texture for ice, use from folder "Assets\Textures\n.tga"
   * Noise - special texture for ice, use from folder "Assets\Texture\noises.tgas". The channels for mapping textures

   * AlbedoMain - albedo texture of your object
   * AlbedoColor - albedo multiplier color
   * NormalMain - normal texture of your object
   * SpecularSm(A)Main - specular texture of your object. In alfa channel - smoothness 
   * SpecularColor - specular multiplayer color
   * Smoothness - smoothness of an object
   * AoMain - ao texture of your object
   * AlbedoDetailMain - detail albedo texture of your object
   * NormalDetail - detail normal texture of your object
   * DetailNormalPower - detail normal power
   * DetailUVScale - detail albedo and normal tiling

   * IceCracksColor - big cracks color
   * IceCracksColor2 - small cracks color
   * IceDepthColor - big ice depth color
   * IceDepthColor2 - small ice depth color
   * FresnelPower - fresnel power
   * FresnelScale - fresnel multiplier
   * AlbedoFresnelColor - fresnel color
   * DepthFade - depth fade for dark silhouette of objects behind ice
   * CracksAreasPower - mask difference between small and big cracks
   * DarknessAreasPower - dark areas power
   * Specular - specular of ice

   * HighNumSteps - number of drawing layers of high cracks
   * HighIceDepthDark - darkness of depth areas of high cracks
   * HighIceDepthPower - depth areas power of high cracks
   * HighIceMarchDistance - high cracks march distance
   * LowNumSteps - number of drawing layers of low cracks
   * LowIceDepthDark - darkness of depth areas of low cracks
   * LowIceDepthPower - depth areas power of low cracks
   * LowIceMarchDistance - low cracks march distance
   * LowiceScale - low ice parallax mapping scale
   * LowIceHeigh - low ice parallax mapping heigh
   * LowIceTiling - low ice cracks tiling
   * LowerNumSteps - number of drawing layers of lower cracks
   * LowerIceDepthDark - darkness of depth areas of lower cracks
   * LowerIceDepthPower - depth areas power of lower cracks
   * LowerIceMarchDistance - low cracks march distance
   * LowericeScale - lower ice parallax mapping scale
   * LowerIceHeigh - lower ice parallax mapping heigh
   * LowerIceTiling - lower ice cracks tiling


Supported Platforms
   All platforms 


Unity Versions 
   2017.4.34f1 and higher


Versions of ice shader
   * Ice
   * Ice_Mask
   * Ice_Mask_Metallic
   * Ice_Mask_NoLowerLvl
   * Ice_Mask_NoTranslucency
   * Ice_Metallic
   * Ice_NoDepthFade
   * Ice_NoLowerLvl
   * Ice_NoTranslucency
   * Ice_Mask_NoFresnel_NoDepthFade
   * Ice_Mask_NoFresnel_NoDepthFade_NoLowerLvl
   * Ice_Mask_NoFresnel_NoDepthFade_NoLowerLvl_NoLowLvl
   * Ice_Mask_NoFresnel_NoDepthFade_NoTranslucency
   * Ice_Mask_NoFresnel_NoDepthFade_NoTranslucency_NoLowerLvl
   * Ice_Mask_NoFresnel_NoDepthFade_NoTranslucency_NoLowerLvl_NoLowLvl
   * Ice_Mask_NoLowerLvl_NoLowLvl
   * Ice_Mask_NoTranslucency_NoLowerLvl
   * Ice_Mask_NoTranslucency_NoLowerLvl_NoLowLvl
   * Ice_NoFresnel_NoDepthFade
   * Ice_NoFresnel_NoDepthFade_NoLowerLvl
   * Ice_NoFresnel_NoDepthFade_NoLowerLvl_NoLowLvl
   * Ice_NoFresnel_NoDepthFade_NoTranslucency
   * Ice_NoFresnel_NoDepthFade_NoTranslucency_NoLowerLvl
   * Ice_NoFresnel_NoDepthFade_NoTranslucency_NoLowerLvl_NoLowLvl
   * Ice_NoLowLvl_NoLowerLvl
   * Ice_NoTranslucency_NoLoweLvl
   * Ice_NoTranslucency_NoLoweLvl_NoLowLvl


Feedback (suggestions, questions, reports or errors)
   SomeOneWhoCaresFeedBack@gmail.com


My social networks
   https://www.artstation.com/vrdsgsegs
   https://twitter.com/iOneWhoCares
   