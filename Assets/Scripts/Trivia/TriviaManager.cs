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
    [SerializeField]
    GameObject btnActiveTrivia;

    [SerializeField]
    RectTransform InicioBtn;
    [SerializeField]
    RectTransform ImagenEnfocada;
    

    #endregion

    

    public void UserResponse()
   {
        StartCoroutine(ActiveHistory());       
        btnActiveTrivia.SetActive(false);
   }
    public void UserPassImage()
    {
        StartCoroutine(ActiveTrivia());
    }
   IEnumerator ActiveHistory()
   {
        
        trivia.gameObject.SetActive(true);

        Vector2 initialPosition = trivia.localPosition;

        Vector2 finalPosition = trivia.localPosition + new Vector3(0f, 3000f, 0f);

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


    public void closeBtn()
    {
        gameObject.SetActive(false);
    }

    IEnumerator ActiveTrivia()
    {
        InicioBtn.gameObject.SetActive(true);
        

        Vector2 initialPosition = InicioBtn.localPosition;

        Vector2 finalPosition = InicioBtn.localPosition + new Vector3(0f, 3000f, 0f);

        float t = Time.time;

        while (Time.time <= t + 1f)
        {
            InicioBtn.localPosition = initialPosition + ((finalPosition - initialPosition) * curve.Evaluate(Time.time - t));

            yield return null;
        }

        InicioBtn.anchoredPosition = finalPosition;

        initialPosition = ImagenEnfocada.localPosition;

        finalPosition = Vector3.zero;       

        t = Time.time;

        while (Time.time <= t + 1f)
        {
            ImagenEnfocada.localPosition = initialPosition + ((finalPosition - initialPosition) * curve.Evaluate(Time.time - t));
            yield return null;
        }

        ImagenEnfocada.localPosition = Vector3.zero;
        trivia.localPosition = Vector3.zero;

        StartCoroutine(ChangeBaseFortrivia());
    }

    IEnumerator ChangeBaseFortrivia()
    {
        yield return new WaitForSeconds(1f);
        ImagenEnfocada.gameObject.SetActive(false);
    }
}