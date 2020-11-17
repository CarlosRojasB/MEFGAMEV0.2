using UnityEngine;

public class ActiveButtonForTrivia : MonoBehaviour
{
    #region Information   
    [Header("Collision objects", order = 0)]
    [SerializeField] Camera mycamera;
    [SerializeField] LayerMask TriviaLayer, NinphasLayer, _FondoLayer;

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
    bool ActiveSound=false;



    [Header("Fonndo Objects", order = 4)]
    [SerializeField]
    RectTransform imgFondo;
    [SerializeField]
    AudioSource audSourceFondo;
    bool Activesoundfondo=false;

    #endregion

    private void Start()
    {
        mycamera = Camera.main;
    }

    private void Update()
    {
        //Raycast hit from the center of the camera
        Vector3 CameraCenter = mycamera.ScreenToWorldPoint(new Vector3(Screen.width / 2, Screen.height / 2, mycamera.nearClipPlane));


        //Active Tree
        if (posibleActive)
        {
            if (Physics.Raycast(CameraCenter, transform.forward, out hit, TriviaLayer)) btnForTrivia.gameObject.SetActive(true);
            else btnForTrivia.gameObject.SetActive(false);
        }

        //Active Nhymphas sound
        if (Physics.Raycast(CameraCenter, transform.forward, out hit, NinphasLayer))
        {
            ActiveSound = true;
          
        }
        else ActiveSound = false;

        //Active Fondo
        if (Physics.Raycast(CameraCenter, transform.forward, out hit, _FondoLayer))
        {
            print("Entrto");
            Activesoundfondo = true;
            imgFondo.gameObject.SetActive(true);

        }
        else Activesoundfondo = false;

        //Function to call Audios
        ActiveAudioNhymphas();
        ActiveFondoSound();


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
        else if (!ActiveSound && audSourceNhymps.isPlaying)
        {

            audSourceNhymps.Stop();
        }
    }
    void ActiveFondoSound()
    {
        if (Activesoundfondo && !audSourceFondo.isPlaying) audSourceFondo.Play();
        else if (!Activesoundfondo && audSourceFondo.isPlaying) audSourceFondo.Stop();
    }
   
}