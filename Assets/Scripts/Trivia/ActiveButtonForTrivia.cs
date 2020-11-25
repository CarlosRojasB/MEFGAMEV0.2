using UnityEngine;
using System.Collections;

public class ActiveButtonForTrivia : MonoBehaviour
{
    #region Information   
    [Header("Collision objects", order = 0)]
    [SerializeField] Camera mycamera;
    [SerializeField] LayerMask TriviaLayer, NinphasLayer, _FondoLayer, HumminButter;

    Ray ray;
    RaycastHit hit;
    bool posibleActive = true;

    [Space(order = 1)]

    [Header("Trivia objects", order = 2)]
    [SerializeField] Transform btnForTrivia;
    [SerializeField] GameObject Trivia;

    [Header("Nhymphas objects", order = 3)]
    [SerializeField]
    AudioSource audSourceNhymps;
    [SerializeField]
    AnimationCurve curveNhymphs;
    bool ActiveSound = false;
    


    [Header("Fondo Objects", order = 4)]
    [SerializeField]
    RectTransform imgFondo;
    [SerializeField]
    AudioSource audSourceFondo;
    bool Activesoundfondo = false;


    [Header("HumminButter", order = 5)]
    [SerializeField]
    RectTransform FadeWhite;
    [SerializeField]
    AnimationCurve curveFade;

    [SerializeField]
    ParticleSystem parSysLeaf1;
    [SerializeField]
    ParticleSystem parSysLeaf2;
    [SerializeField]
    ParticleSystem smokeTwister;

    ParticleSystem.MainModule mainLeaf1;
    ParticleSystem.MainModule mainLeaf2;
    ParticleSystem.MainModule mainsmokeTwister;

    ParticleSystemShapeType shapeTypeleaf1;
    [SerializeField]
    AnimationCurve curveApearPartycles;

    
    bool IsActiveFade=false;

    #endregion

    private void Start()
    {
        mycamera = Camera.main;


        parSysLeaf1.GetComponent<ParticleSystem>();


        mainLeaf1 = parSysLeaf1.main;
        mainLeaf2 = parSysLeaf2.main;
        mainsmokeTwister = smokeTwister.main;

    }

    private void Update()
    {
        //Raycast hit from the center of the camera
        Vector3 CameraCenter = mycamera.ScreenToWorldPoint(new Vector3(Screen.width / 2, Screen.height / 2, mycamera.nearClipPlane));

        ray = new Ray(CameraCenter, transform.forward);

        //Active Tree
        if (posibleActive)
        {
            if (Physics.Raycast(ray, out hit, float.MaxValue, TriviaLayer)) btnForTrivia.gameObject.SetActive(true);
            else btnForTrivia.gameObject.SetActive(false);
        }

        //Active Nhymphas sound
        if (Physics.Raycast(ray, out hit, float.MaxValue, NinphasLayer)) ActiveSound = true;
        else ActiveSound = false;

        ActiveAudioNhymphas();

        //Active Fondo
        if (Physics.Raycast(ray, out hit, float.MaxValue, _FondoLayer))
        {
            Activesoundfondo = true;
            imgFondo.gameObject.SetActive(true);

        }
        else Activesoundfondo = false;

        ActiveFondoSound();



        //ActiveHumminButter
        if (Physics.Raycast(ray, out hit, float.MaxValue, HumminButter)) 
        {
           // StartCoroutine(CallFadeInCoroutine());
            print("Entro a Hummin");
        }

    }


    public void GoToTrivia()
    {
        posibleActive = false;
        Trivia.SetActive(true);
        btnForTrivia.gameObject.SetActive(false);

    }

    void ActiveAudioNhymphas()
    {
        if (ActiveSound && !audSourceNhymps.isPlaying) audSourceNhymps.Play();
        else if (!ActiveSound && audSourceNhymps.isPlaying) audSourceNhymps.Stop();
    }
    void ActiveFondoSound()
    {
        if (Activesoundfondo && !audSourceFondo.isPlaying) audSourceFondo.Play();
        else if (!Activesoundfondo && audSourceFondo.isPlaying)
        {
            imgFondo.gameObject.SetActive(false);
            audSourceFondo.Stop();

        }
      
    }

    void CurveAnimationForHummin()
    {        
        parSysLeaf1.Play();
        parSysLeaf2.Play();
        smokeTwister.Play();     
       
        
    }

    /*IEnumerator CrecerHojasCoroutine(ParticleSystem _ParticleSystem,float initialLengthShape,float finalLengthShape,float timeToIncreace)
    {
        shapeTypeleaf1
        
        _ParticleSystem.Play();
        float tmpinitial = initialLengthShape;
        float tmpfinal = finalLengthShape;


        float t = Time.time;
        while (Time.time <= t + timeToIncreace)
        {
           
        }


    }*/
    IEnumerator CallFadeInCoroutine()
    {
        if (!IsActiveFade)
        {
            FadeWhite.gameObject.SetActive(true);

            Vector3 initialSize = Vector3.zero;
            Vector3 finalSize = new Vector3(70f, 70f, 70f);

            float t = Time.time;
            while (Time.time <= t + 0.1f)
            {
                FadeWhite.localScale = initialSize - ((finalSize + initialSize) * curveFade.Evaluate(Time.time - t));
                yield return null;
            }
            FadeWhite.localScale = finalSize;

            StartCoroutine(CallfadeOutCoroutine());
            IsActiveFade = true;
        }
    }
    IEnumerator CallfadeOutCoroutine()
    {
        FadeWhite.gameObject.SetActive(true);

        Vector3 initialSize = new Vector3(70f, 70f, 70f);
        Vector3 finalSize = Vector3.zero;

        float t = Time.time;
        while (Time.time <= t + 0.1f)
        {
            FadeWhite.localScale = initialSize - ((finalSize + initialSize) * curveFade.Evaluate(Time.time - t));
            yield return null;
        }
        FadeWhite.localScale = finalSize;
        IsActiveFade = false;
    }
}