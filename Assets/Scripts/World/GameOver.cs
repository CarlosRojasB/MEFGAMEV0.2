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
        distanceText.text = Math.Round(TravelToAlphaCetiGameUIController.distance / 1000f, 1) + " Milles";
    }

    public void GoToAr()
    {
        Singleton<ManagerScene>.instance.GoToAr();
    }
}