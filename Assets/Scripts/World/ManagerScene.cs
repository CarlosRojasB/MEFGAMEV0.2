using UnityEngine;
using UnityEngine.SceneManagement;
using System.Collections;


public class ManagerScene : MonoBehaviour
{
    private void Awake()
    {
        new Singleton<ManagerScene>(this);
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
        SceneManager.LoadScene("ElDrakAR", LoadSceneMode.Single);
    }
    IEnumerator WaitToDesapearWelcome()
    {
        yield return new WaitForSeconds(22f);
        GoToAr();

    }
}
