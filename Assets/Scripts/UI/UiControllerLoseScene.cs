using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class UiControllerLoseScene : MonoBehaviour
{
    TextMeshProUGUI txtFinalDistance;
    private void Start()
    {
        txtFinalDistance = GameObject.Find("FinalScore").GetComponent<TextMeshProUGUI>();
        txtFinalDistance.text = DistanceScore.distance.ToString("F1")+"Ft";
        if (DistanceScore.distance >= 1000)
        {
            txtFinalDistance.text = (DistanceScore.distance / 1000).ToString("F1") + "mille";
        }

      
        
    }



}
