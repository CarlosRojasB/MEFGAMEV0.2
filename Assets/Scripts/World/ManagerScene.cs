using UnityEngine;
using UnityEngine.SceneManagement;
using System.Collections;
using UnityEngine.Video;



public class ManagerScene : MonoBehaviour
{
    #region Information
    Singleton<ManagerScene> sceneManager;

   /* [SerializeField] GameObject PanelLoading;
    [SerializeField] Animator animatorLoading;
    [SerializeField] VideoPlayer videoWelcome;
    [SerializeField] VideoPlayer videoLoading;
    [SerializeField] RectTransform rawImageWelcome;
    [SerializeField] GameObject[] points;
    
    bool isPlaying = false;*/
    #endregion

    private void Awake()
    {
        sceneManager = new Singleton<ManagerScene>(this);
    }
    private void Start()
    {
        //StartCoroutine(WaitToDesapearWelcome());
    }

    public void GoToGameMenu()
    {
        SceneManager.LoadScene("Game Menu", LoadSceneMode.Single);
    }
    
    public void GoToTravelToAlphaCetiGame()
    {
        SceneManager.LoadScene("Travel To Alpha Ceti Game", LoadSceneMode.Single);

    }

    public void GoToLose()
    {
        SceneManager.LoadScene("Lose", LoadSceneMode.Single);
    }

    public void GoToAr()
    {
        SceneManager.LoadScene("ElDrakAR", LoadSceneMode.Single);

       /* StartCoroutine(LoadAsync());
        DontDestroyOnLoad(videoLoading);*/

    }
    /*IEnumerator LoadAsync()
    {
        AsyncOperation asyncLoad = SceneManager.LoadSceneAsync("ElDrakAR");

        StartCoroutine(ActivePoints());

        if (PanelLoading != null && videoWelcome != null && rawImageWelcome != null)
        {
            videoWelcome.Stop();

            rawImageWelcome.gameObject.SetActive(false);

            PanelLoading.gameObject.SetActive(true);
        }
        while (!asyncLoad.isDone)
        {
           if(*//*animatorLoading != null &&*//* !isPlaying && videoLoading!=null)
           {
                isPlaying = true;

                //SceneManager.LoadScene("TransitionScene", LoadSceneMode.Additive);

                //animatorLoading.SetTrigger("ToLoading");

                videoLoading.Play();
           }

            yield return null;

        }
    }*/
   /* IEnumerator ActivePoints()
    {
       
            if(points[1] != null)
            {
                for (int i = 0; i < points.Length; i++)
                {
                    yield return new WaitForSeconds(0.5f);

                    points[i].gameObject.SetActive(true);
                }

                points[0].gameObject.SetActive(false);

                points[1].gameObject.SetActive(false);

                points[2].gameObject.SetActive(false);
            }
               
    }*/
    
    public void GoToNhymphas()
    {
        SceneManager.LoadScene("PanelHadas",LoadSceneMode.Single);
    }
    IEnumerator WaitToDesapearWelcome()
    {
        yield return new WaitForSeconds(18f);
        GoToAr();

    }
}
