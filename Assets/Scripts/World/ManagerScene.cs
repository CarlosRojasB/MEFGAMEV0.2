using UnityEngine.SceneManagement;

public class ManagerScene : TSingleton<ManagerScene>
{
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
}
