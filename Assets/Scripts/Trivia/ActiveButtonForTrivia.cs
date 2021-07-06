using UnityEngine;
using System.Collections;
using UnityEngine.Video;

public class ActiveButtonForTrivia : MonoBehaviour
{
    #region Information

    bool posibleScan;
    #region InitialVideo
    [SerializeField] RectTransform initialVideoWelcome;
    [SerializeField] VideoPlayer videoInitial;
    #endregion

    #region Collision Objects
    [Header("Collision objects", order = 0)]
    [SerializeField] Camera mycamera;
    [SerializeField] LayerMask TriviaLayer, NinphasLayer, _FondoLayer, HumminButter, Letras,ToGameMask,ElDrack;

    Ray ray;
    RaycastHit hit;
    bool posibleActive = true;
    #endregion
    [Space(order = 1)]
    #region Trivia
    [Header("Trivia objects", order = 2)]
    [SerializeField] Transform btnForTrivia;
    [SerializeField] GameObject Trivia;

    #endregion

    #region Nhymphas
    [Header("Nhymphas objects", order = 3)]
    [SerializeField]
    AudioSource audSourceNhymps;
    [SerializeField]
    AnimationCurve curveNhymphs;
    [SerializeField]
    RectTransform NhymphasScrollView;
    [SerializeField] VideoPlayer videoPlayerNhymphas;
    bool ActiveSound = false;

    
    #endregion

    #region FondoObjects
    [Header("Fondo Objects", order = 4)]
    [SerializeField]
    RectTransform imgFondo;
    [SerializeField]
    AudioSource audSourceFondo;
    bool Activesoundfondo = false;
    [SerializeField] VideoPlayer videoPlayerFondo;
    #region ComponentsFondo
    [SerializeField]
    LandingManager lndManager;
    VideoPlayer _videoPlayerFondo;
    #endregion

    #endregion

    #region HumminButter
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
    [SerializeField]
    AnimationCurve curveApearPartycles;

    [SerializeField]
    GameObject HumminBird, HumminHumanoid;

    [SerializeField]
    AudioSource FXHummin;


    float CounterFadeHumminButter;
    float CounterFadeHumminBird;
    bool IsActiveFade = false;
    bool IsActiveEffecToIncreace = false;
    bool possibleChangeBird=false;

    bool firstChange = false;

    #endregion

    #region LetrasWelcome
    [Header("letrasWelcome", order = 6)]
    [SerializeField] GameObject PanelLetras;
    [SerializeField]
    GameObject letrasObj;
    [SerializeField]
    GameObject videoPlayer;
    [SerializeField]
    AnimationCurve curveToApearLetters;
    [SerializeField]
    RectTransform lettersInitial, lettersStaticImage;
    [SerializeField]
    AudioSource audLettras;

    bool activeLetersCanvas=false;

    bool IsActiveSound = false;
    bool IsActiveLetter = false;
    bool IsActive3DLetters = false;
    VideoPlayer _videoPlayer;
    float CounterLettras;
    float counterToLoop;

    #endregion

    #region BaseElDrack
    [Header("Base Eldrack")]
    [SerializeField]
    GameObject baseElDrack;
    [SerializeField]
    Transform ParentEldrack, ParentHumminButter;

    bool BaseEnElDrack = true;
    bool BaseEnHummin = true;
    #endregion
    #region Events
    System.Action closePanel;
    #endregion
    
    
    #endregion

    private void Start()
    {
        _videoPlayer = videoPlayer.GetComponent<VideoPlayer>();

        _videoPlayerFondo = videoPlayerFondo.GetComponent<VideoPlayer>();

        _videoPlayerFondo.playOnAwake = false;

        mycamera = Camera.main;
        
        videoInitial.Play();

        StartCoroutine(CheckFinalInitialVideo());

    }

    IEnumerator CheckFinalInitialVideo()
    {
        while (videoInitial.isPlaying)
        {
            yield return null;
        }

        posibleScan = true;
    }
    private void Update()
    {
        if (!videoInitial.isPlaying)
        {
            initialVideoWelcome.gameObject.SetActive(false);
        }
        if (!initialVideoWelcome.gameObject.activeSelf )
        {
            videoInitial.Stop();
        }
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
        if (Physics.Raycast(ray, out hit, float.MaxValue, NinphasLayer) && posibleScan)
        {
            if (!NhymphasScrollView.gameObject.activeSelf)
            {
                ActiveSound = true;

                NhymphasScrollView.gameObject.SetActive(true);

                posibleScan = false;
                print( " posible Scan nhymphas fuera: "+posibleScan);

                closePanel = () => 
                {
                    ActiveSound = false;

                    posibleScan = true;

                    print( " posible Scan nhymphas dentro: "+posibleScan);
                };
            }
        }

        ActiveAudioNhymphas(posibleScan);

        //Active Fondo
        if (Physics.Raycast(ray, out hit, float.MaxValue, _FondoLayer) && posibleScan)
        {
            if (!imgFondo.gameObject.activeSelf)
            {
                Activesoundfondo = true;

                imgFondo.gameObject.SetActive(true);

                posibleScan = false;
                
                print( " posible Scan fondo fuera: "+posibleScan);

                closePanel = () =>
                {
                    Activesoundfondo = false;

                    posibleScan = true;
                    
                    print( " posible Scan fondo dentro: "+posibleScan);

                    lndManager.Restar();
                };
            }
        }

        ActiveFondoSound(posibleScan);

        //ActiveHumminButter
        if (Physics.Raycast(ray, out hit, float.MaxValue, HumminButter))
        {           
            CounterFadeHumminButter += Time.deltaTime;
            IsActiveFade = true;
            IsActiveEffecToIncreace = true;
            managerEffectsHumminButter();

            if (possibleChangeBird )
            {               
                firstChange = false;
                CounterFadeHumminBird += Time.deltaTime;  
                if(CounterFadeHumminBird>=8f)
                    StartCoroutine(CallFadeInCoroutine());
                ActiveModelbird();
            }              
                
        }
        else
        {          
            FadeWhite.gameObject.SetActive(false);

            CounterFadeHumminButter = 0f;

            IsActiveFade = false;

            IsActiveEffecToIncreace = false;
        }
       
        if (CounterFadeHumminButter >= 8f&&!firstChange)
        {

            StartCoroutine(CallFadeInCoroutine());
            ActiveHumanoidModel();
            
            firstChange = true;
        }       

        //Active videoLetters
        if (Physics.Raycast(ray, out hit, float.MaxValue, Letras) && posibleScan)
        {

            if (!PanelLetras.gameObject.activeSelf)
            {
                activeLetersCanvas = true;

                PanelLetras.gameObject.SetActive(true);

                posibleScan = false;
                
                print( " posible Scan letters fuera: "+posibleScan);

                closePanel = () =>
                {
                    activeLetersCanvas = false;

                    posibleScan = true;
                    
                    print( " posible Scan fondo dentro: "+posibleScan);

                };
            }

        }       
        
        ActiveLetters(posibleScan);

        //ToGame
        if(Physics.Raycast(ray,out hit,float.MaxValue, ToGameMask))
        {
            Singleton<ManagerScene>.instance.GoToTravelToAlphaCetiGame();
        }
            
    }

    public void ClosePanel(RectTransform panel)
    {
        panel.gameObject.SetActive(false);

        closePanel?.Invoke();

        if (panel.name == "InitialVideo")
        {
            posibleScan = true;
        }
    }

    /// <summary>
    /// Trivia Logic
    /// </summary>
    public void GoToTrivia()
    {
        posibleActive = false;
        Trivia.SetActive(true);
        btnForTrivia.gameObject.SetActive(false);

    }

    /// <summary>
    /// NhymphasLogic 
    /// </summary>
    void ActiveAudioNhymphas(bool _posibleScan)
    {
        if (ActiveSound && !audSourceNhymps.isPlaying)
        {
            videoPlayerNhymphas.Play();
            audSourceNhymps.Play();
        }
        else if (!ActiveSound && audSourceNhymps.isPlaying)
        {
            NhymphasScrollView.gameObject.SetActive(false);
            videoPlayerNhymphas.Stop();
            audSourceNhymps.Stop();
        }
    }

    /// <summary>
    /// sound backGround logic && videoplayer
    /// </summary>
    void ActiveFondoSound(bool _posibleScan)
    {
        if (Activesoundfondo /*&& !_videoPlayerFondo.isPlaying*/ && !audSourceFondo.isPlaying)
        {
            audSourceFondo.Play();
            _videoPlayerFondo.Play();
        }
        else if (!Activesoundfondo && audSourceFondo.isPlaying)
        {
           
            audSourceFondo.Stop();
            imgFondo.gameObject.SetActive(false);
            _videoPlayerFondo.Stop();
        }

    }

    /// <summary>
    /// Welcom images and letters3D
    /// </summary>
    void ActiveLetters(bool _posibleScan)
    {
        if (activeLetersCanvas)
        {
            _videoPlayer.Play();
            audLettras.Play();
        }
        else if(!activeLetersCanvas)
        {
            audLettras.Stop();
            PanelLetras.SetActive(false);
            _videoPlayer.Stop();
        }
    }
    IEnumerator CallLetters3D()
    {
        letrasObj.SetActive(true);

        Vector3 initialPosition = new Vector3(0f, 0f, 0f);
        Vector3 finalPosition = new Vector3(0f, 0.438f, 0f);

        float t = Time.time;
        while (Time.time <= t + 3f)
        {
            letrasObj.transform.localPosition = initialPosition + ((finalPosition + initialPosition) * curveToApearLetters.Evaluate((Time.time - t) / 3f));
            yield return null;
        }
        letrasObj.transform.localPosition = finalPosition;
        IsActive3DLetters = true;
    }

    /// <summary>
    /// Humminbutter logic
    /// </summary> 
    void managerEffectsHumminButter()
    {

        StartCoroutine(CrecerHojasCoroutine(parSysLeaf1, 0.1f, 27.52f, 5f));
        StartCoroutine(CrecerHojasCoroutine(parSysLeaf2, 0.1f, 20.63f, 5f));
        StartCoroutine(CrecerHojasCoroutine(smokeTwister, 0.1f, 23.05f, 5f));
    }
    IEnumerator CrecerHojasCoroutine(ParticleSystem _ParticleSystem, float initialLengthShape, float finalLengthShape, float timeToIncreace)
    {
        FXHummin.Play();
        var shapeParticles = _ParticleSystem.shape;
        if (IsActiveEffecToIncreace && !_ParticleSystem.isPlaying)
        {
            _ParticleSystem.Play();

           
       
            float t = Time.time;
            while (Time.time <= t + timeToIncreace)
            {
                shapeParticles.length = initialLengthShape + ((finalLengthShape + initialLengthShape) * curveApearPartycles.Evaluate((Time.time - timeToIncreace) / timeToIncreace));
                yield return null;
            }
            shapeParticles.length = finalLengthShape;
        }
        else if (!IsActiveEffecToIncreace && _ParticleSystem.isPlaying)
        {
            print("Entro Al else");
            shapeParticles.length = 0.1f;
            _ParticleSystem.Stop();
        }
        FXHummin.Play();
    }
    IEnumerator CallFadeInCoroutine()
    {
       
        if (IsActiveFade && !firstChange)
        {
           
            FadeWhite.gameObject.SetActive(true);

            Vector3 initialSize = Vector3.zero;
            Vector3 finalSize = new Vector3(70f, 70f, 70f);

            float t = Time.time;
            while (Time.time <= t + 0.1f)
            {
                FadeWhite.localScale = initialSize - ((finalSize + initialSize) * curveFade.Evaluate((Time.time - t) / 0.1f));
                yield return null;
            }
            FadeWhite.localScale = finalSize;

            StartCoroutine(CallfadeOutCoroutine());
        }        
    }
    IEnumerator CallfadeOutCoroutine()
    {

        Vector3 initialSize = new Vector3(70f, 70f, 70f);
        Vector3 finalSize = Vector3.zero;

        float t = Time.time;
        while (Time.time <= t + 0.1f)
        {
            FadeWhite.localScale = initialSize - ((finalSize + initialSize) * curveFade.Evaluate((Time.time - t) / 0.1f));
            FadeWhite.gameObject.SetActive(false);
            yield return null;
        }
        FadeWhite.localScale = finalSize;

    }

    void ActiveHumanoidModel()
    {
        if (IsActiveFade && !firstChange)
        {
            HumminBird.SetActive(false);
            HumminHumanoid.SetActive(true);
            firstChange = true;

            possibleChangeBird = true;
        }       
    }

    void ActiveModelbird()
    {

        if (CounterFadeHumminBird >= 8f && possibleChangeBird &&IsActiveFade)
        {
            IsActiveFade = true;


            HumminBird.SetActive(true);
            HumminHumanoid.SetActive(false);

            CounterFadeHumminButter = 0;
            CounterFadeHumminBird = 0f;
            possibleChangeBird = false;
           
           
        }
       
    }
    

}