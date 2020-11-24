using UnityEngine;
using TMPro;
using System;
using System.Collections;

public class TravelToAlphaCetiGameUIController : MonoBehaviour
{
#pragma warning disable CS0649

    #region Score
    public static float score;
    double lastScore;
    [Header("Score", order = 0)]
    [SerializeField] TextMeshProUGUI distanceTxt;
    [SerializeField] AnimationCurve @in;
    [SerializeField] AnimationCurve @out;
    #endregion
    [Space(order = 1)]
    #region Components
    [Header("Components", order = 2)]
    [SerializeField] MovementCharacter movementCharacter;
    Coroutine scoreCoroutine;
    #endregion

    private void Awake()
    {
        distanceTxt.text = "Distance: 0 Ft";

        movementCharacter.OnMove += UpdateDistance;
    }

    public void UpdateDistance(float distance)
    {
        score = score + distance;

        double round = Math.Round(score / 1000f, 1);

        if (round != 0 && round != lastScore && round % 1 == 0)
        {
            distanceTxt.text = Math.Round(score / 1000f, 1).ToString() + " Mille";

            scoreCoroutine = StartCoroutine(ShowCoroutine());
        }
        else
        {
            if(scoreCoroutine == null)
                distanceTxt.text = Math.Round(score / 1000f, 1).ToString() + " Mille";
        }

        lastScore = round;
    }

    IEnumerator ShowCoroutine()
    {
        RectTransform distance = distanceTxt.gameObject.GetComponent<RectTransform>();

        Vector2 initialSize = distance.sizeDelta;

        Vector2 finalSize = distance.sizeDelta + new Vector2(200f, 200f);

        Vector2 initialAnchoredPosition = distance.anchoredPosition;

        Vector2 finalAnchoredPosition = new Vector2(-finalSize.x - 35f, -35f);

        float initialFontSize = 162f;

        float finalFontSize = 200f;

        Color initialColor = distanceTxt.color;

        Color finalColor = Color.yellow;

        float t = Time.time;

        while (Time.time <= t + 0.5f)
        {
            distance.sizeDelta = initialSize + ((finalSize - initialSize) * @in.Evaluate((Time.time - t) / 0.5f));

            distance.anchoredPosition = initialAnchoredPosition + ((finalAnchoredPosition - initialAnchoredPosition) * @in.Evaluate((Time.time - t) / 0.5f));

            distanceTxt.fontSize = initialFontSize + ((finalFontSize - initialFontSize) * @in.Evaluate((Time.time - t) / 0.5f));

            distanceTxt.color = initialColor + ((finalColor - initialColor) * @in.Evaluate((Time.time - t) / 0.5f));

            yield return null;
        }

        distance.sizeDelta = finalSize;

        distance.anchoredPosition = finalAnchoredPosition;

        distanceTxt.fontSize = finalFontSize;

        distanceTxt.color = finalColor;

        t = Time.time;

        while (Time.time <= t + 1f)
        {
            distance.sizeDelta = finalSize + ((initialSize - finalSize) * @out.Evaluate((Time.time - t) / 0.5f));

            distance.anchoredPosition = finalAnchoredPosition + ((initialAnchoredPosition - finalAnchoredPosition) * @out.Evaluate((Time.time - t) / 0.5f));

            distanceTxt.fontSize = finalFontSize + ((initialFontSize - finalFontSize) * @out.Evaluate((Time.time - t) / 0.5f));

            distanceTxt.color = finalColor + ((initialColor - finalColor) * @in.Evaluate((Time.time - t) / 0.5f));

            yield return null;
        }

        distance.sizeDelta = initialSize;

        distance.anchoredPosition = initialAnchoredPosition;

        distanceTxt.fontSize = initialFontSize;

        distanceTxt.color = initialColor;

        scoreCoroutine = null;
    }
}