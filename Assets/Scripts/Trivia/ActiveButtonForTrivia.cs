using UnityEngine;

public class ActiveButtonForTrivia : MonoBehaviour
{
    #region Information   
    [Header("Collision objects", order = 0)]
    [SerializeField] Camera mycamera;
    [SerializeField] LayerMask TriviaLayer, NinphasLayer, _FondoLayer;

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
    ParticleSystem parSysHumminButter;

    #endregion

    private void Start()
    {
        mycamera = Camera.main;
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
        /*if(Physics.Raycast(ray,out hit,float.MaxValue,TriviaLayer))*/

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



}