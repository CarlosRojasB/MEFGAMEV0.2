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
    [SerializeField]
    RectTransform PieceToRotate;
    [SerializeField]
    AnimationCurve curve;

    float TimerToGame = 3;
    bool timerRunning=false;

    public bool TimerRunning { get => timerRunning; set => timerRunning = value; }

    #endregion

    private void Start()
    {
        timerRunning = true;
        StartCoroutine(RotateObject());
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

    IEnumerator RotateObject()
    {
        Vector3 initialrotation = Vector3.zero;
        Vector3 finalroation = new Vector3(0f, 0f, 30f);

        float t = Time.time;

        while (Time.time <= 0.3f + t)
        {
            PieceToRotate.localEulerAngles = initialrotation + ((finalroation - initialrotation) * curve.Evaluate((Time.time - t) / 0.3f));
            yield return null;
        }
        PieceToRotate.localEulerAngles = finalroation;
        StartCoroutine(ReturnRotation());
    }
    IEnumerator ReturnRotation()
    {
        Vector3 initialrotation = new Vector3(0f, 0f, 30f);
        Vector3 finalroation = new Vector3(0f, 0f, -30f);

        float t = Time.time;

        while (Time.time <= 0.6f + t)
        {
            PieceToRotate.localEulerAngles = initialrotation + ((finalroation - initialrotation) * curve.Evaluate((Time.time - t) / 0.6f));
            yield return null;
        }
        PieceToRotate.localEulerAngles = finalroation;


        initialrotation = new Vector3(0f, 0f, -30f);
        finalroation = Vector3.zero;
        t = Time.time;

        while (Time.time <= 0.3f + t)
        {
            PieceToRotate.localEulerAngles = initialrotation + ((finalroation - initialrotation) * curve.Evaluate((Time.time - t) / 0.3f));
            yield return null;
        }
        PieceToRotate.localEulerAngles = finalroation;
    }
}
