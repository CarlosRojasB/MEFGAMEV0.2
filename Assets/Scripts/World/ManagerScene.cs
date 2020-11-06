using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ManagerScene : GeneralSingleton<ManagerScene>
{
   

    public void GoToLose()
    {     
        SceneManager.LoadScene("LoseSceneGame", LoadSceneMode.Single);    
     
    }

    public void GoTOGame()
    {     
      SceneManager.LoadScene("MenuTestForChooseControl", LoadSceneMode.Single);     
    }


    public void GoToAcelerometer()
    {
        SceneManager.LoadScene("GameAcelerometer", LoadSceneMode.Single);
    }
    public void GoToTouchScene()
    {
        SceneManager.LoadScene("GameTocuhScreen", LoadSceneMode.Single);
    }



}
