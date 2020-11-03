using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.SceneManagement;

public class UIController :MonoBehaviour
{



    //Atributes for GameScene
    TextMeshProUGUI txtDistance;
    DistanceScore dtcScore;
    private float millesize = 1000;

    //Atributes for loseScene
    TextMeshProUGUI txtFinalDistance;


    private void Start()
    {
        txtDistance = GameObject.Find("txtDistanceScore").GetComponent<TextMeshProUGUI>();
        dtcScore = GameObject.Find("PlayerCollisionator").GetComponent<DistanceScore>();

    }
    private void Update()
    {      
        
       ActualizarScoreDistance();      
       
    }

    public void ActualizarScoreDistance()
    {

        txtDistance.text = "Distance" + dtcScore.Distance.ToString("F1") + "Ft";

        if (dtcScore.Distance >= millesize)
        {
            txtDistance.text = "Distance" + (dtcScore.Distance / millesize).ToString("F1") + "mille";
        }

        /* txtDistance.text = "Distance" + DistanceScore.Instance.Distance.ToString("F1") + "Ft";

         if (dtcScore.Distance >= millesize)
         {
             txtDistance.text = "Distance" + (DistanceScore.Instance.Distance / millesize).ToString("F1") + "mille";
         }*/


    }






}
