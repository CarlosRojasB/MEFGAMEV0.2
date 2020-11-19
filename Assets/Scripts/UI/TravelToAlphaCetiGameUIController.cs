using UnityEngine;
using TMPro;
using System;

public class TravelToAlphaCetiGameUIController : MonoBehaviour
{
#pragma warning disable CS0649

    #region Score
    public static float score;
    [Header("Score", order = 0)]
    [SerializeField] TextMeshProUGUI distanceTxt;
    #endregion
    [Space(order = 1)]
    #region Components
    [Header("Components", order = 2)]
    [SerializeField] MovementCharacter movementCharacter;
    #endregion

    private void Awake()
    {
        distanceTxt.text = "Distance: 0 Ft";

        movementCharacter.OnMove += UpdateDistance;
    }

    public void UpdateDistance(float distance)
    {
        score = score + distance;

        distanceTxt.text = "Distance: " + Math.Round(score / 1000f, 1).ToString() + " Mille";
    }
}