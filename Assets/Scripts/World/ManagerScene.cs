using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ManagerScene : GeneralSingleton<ManagerScene>
{
    public void GoToLose()
    {     
        SceneManager.LoadScene("Lose", LoadSceneMode.Single);    
     
    }

    public void GoTOGame()
    {     
      SceneManager.LoadScene("Game Menu", LoadSceneMode.Single);     
    }


    public void GoToAcelerometer()
    {
        SceneManager.LoadScene("Accelerometer Game", LoadSceneMode.Single);
    }
    public void GoToTouchScene()
    {
        SceneManager.LoadScene("Touch Game", LoadSceneMode.Single);
    }
}
