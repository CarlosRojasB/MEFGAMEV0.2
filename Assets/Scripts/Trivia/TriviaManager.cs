using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TriviaManager : MonoBehaviour
{
    #region Information
    [Header("Movement UI information",order =0)]
    [SerializeField]
    RectTransform trivia;
    [SerializeField]
    AnimationCurve curve;
    #endregion

   public void UserResponse()
   {
        StartCoroutine(ActiveHistory());
   }
  
   IEnumerator ActiveHistory()
   {
        trivia.gameObject.SetActive(true);

        Vector2 initialPosition = Vector3.zero;
        Vector2 finalPosition = new Vector3(0f, 15f, 0f);

        float t = Time.time;
        while (Time.time <= t + 1f)
        {
            trivia.anchoredPosition = initialPosition + ((finalPosition - initialPosition) * curve.Evaluate(Time.time - t));
            yield return null;
        }
        trivia.anchoredPosition = finalPosition;
   }



}
