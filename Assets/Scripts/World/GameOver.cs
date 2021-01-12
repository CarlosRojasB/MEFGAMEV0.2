using System;
using TMPro;
using UnityEngine;

public class GameOver : MonoBehaviour
{
    #region Components
    [SerializeField] TextMeshProUGUI distanceText;
    #endregion

    void Awake()
    {
        distanceText.text = Math.Round(TravelToAlphaCetiGameUIController.distance / 1000f, 1).ToString("F1");
    }

    public void GoToGame()
    {
        Singleton<ManagerScene>.instance.GoToTravelToAlphaCetiGame();
    }
}