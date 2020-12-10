using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class BegginController : MonoBehaviour
{
    #region Information
    [Header("Información counter")]
    [SerializeField]
    RectTransform PanelCounter;
    [SerializeField]
    TextMeshProUGUI CounterGraphics;

    float TimerToGame = 3;
    bool timerRunning=false;

    public bool TimerRunning { get => timerRunning; set => timerRunning = value; }

    #endregion

    private void Start()
    {
        timerRunning = true;
    }
    
    private void Update()
    {
        if (timerRunning)
        {
            TimerToGame -= Time.deltaTime;
            CounterGraphics.text = TimerToGame.ToString("F0");
            if (TimerToGame <= 0f)
            {                
                PanelCounter.gameObject.SetActive(false);
                timerRunning = false;
            }
        }
     

    }
}
