using UnityEngine;
using UnityEngine.SceneManagement;
using System.Collections;


public class ManagerScene : MonoBehaviour
{
    #region Information
    Singleton<ManagerScene> sceneManager;

    [SerializeField] GameObject PanelLoading;
    [SerializeField] Animator animatorLoading;
    bool isPlaying = false;
    #endregion

    private void Awake()
    {
        sceneManager = new Singleton<ManagerScene>(this);
    }
    private void Start()
    {
        StartCoroutine(WaitToDesapearWelcome());
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
        //SceneManager.LoadScene("ElDrakAR", LoadSceneMode.Single);

        StartCoroutine(LoadAsync());
    }
    IEnumerator LoadAsync()
    {
        AsyncOperation asyncLoad = SceneManager.LoadSceneAsync("ElDrakAR");
        if (PanelLoading != null )
        {
            PanelLoading.gameObject.SetActive(true);
        }        
        while (!asyncLoad.isDone)
        {
           if(animatorLoading != null && !isPlaying)
           {
                isPlaying = true;
                print("Reproducir");
                animatorLoading.SetTrigger("ToLoading");
           }
            yield return null;
        }
    }
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
