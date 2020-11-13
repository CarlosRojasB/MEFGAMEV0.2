using System.Collections;
using UnityEngine;

public class TriviaManager : MonoBehaviour
{
    #region Information
    [Header("Movement UI information", order = 0)]
    [SerializeField]
    RectTransform trivia;
    [SerializeField]
    RectTransform history;
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

        Vector2 initialPosition = trivia.localPosition;

        Vector2 finalPosition = trivia.localPosition + new Vector3(0f, 2360f, 0f);

        float t = Time.time;

        while (Time.time <= t + 1f)
        {
            trivia.localPosition = initialPosition + ((finalPosition - initialPosition) * curve.Evaluate(Time.time - t));

            yield return null;
        }

        trivia.anchoredPosition = finalPosition;

        initialPosition = history.localPosition;

        finalPosition = Vector3.zero;

        t = Time.time;

        while (Time.time <= t + 1f)
        {
            history.localPosition = initialPosition + ((finalPosition - initialPosition) * curve.Evaluate(Time.time - t));

            yield return null;
        }

        history.localPosition = Vector3.zero;
    }
}