using System.Collections;
using UnityEngine;

public class LandingManager : MonoBehaviour
{
    #region Information
    [Header("Pass images")]
    [SerializeField]
    RectTransform imgFinal;
    [SerializeField]
    RectTransform imgInitial;
    [SerializeField]
    RectTransform mdlImage;
    [SerializeField]
    AnimationCurve curve;
    #endregion

    #region InitialPosition
    bool start;
    Vector2 imgInitialInitialPositiom, imgFinalInitialPosition, mdlImgInitialPosition;
    #endregion 

    void Awake()
    {
        imgInitialInitialPositiom = imgInitial.localPosition;

        imgFinalInitialPosition = imgFinal.localPosition;

        mdlImgInitialPosition = mdlImage.localPosition;

        start = true;
    }

    public void Restar()
    {
        if (start)
        {
            imgInitial.localPosition = imgInitialInitialPositiom;

            imgFinal.localPosition = imgFinalInitialPosition;

            mdlImage.localPosition = mdlImgInitialPosition;
        }
    }

    public void UserTouch()
    {
        StartCoroutine(ActiveNextImageCoroutine());
    }

    public void UserTouchBack()
    {
         StartCoroutine(ActivePreviousImage());
    }

    IEnumerator ActiveNextImageCoroutine()
    {
        Vector2 iniPosi = Vector3.zero;
        Vector2 finalPosi = imgInitial.localPosition + new Vector3(0f, 3000f, 0f);

        float t = Time.time;

        while (Time.time<=t+1f)
        {
            imgInitial.localPosition = iniPosi + ((finalPosi - iniPosi) * curve.Evaluate(Time.time - t));
            yield return null;
        }

        imgInitial.anchoredPosition = finalPosi;

        iniPosi = new Vector3(0f,-3000,0f);
        finalPosi = Vector3.zero;

        Vector2 iniImgFinal = new Vector3(0f, -3000, 0f);

        t = Time.time;

        while (Time.time<=t+1f)
        {
            mdlImage.localPosition = iniPosi + ((finalPosi - iniPosi) * curve.Evaluate(Time.time - t));
            imgFinal.localPosition = iniImgFinal + ((finalPosi - iniImgFinal) * curve.Evaluate(Time.time - t));
            yield return null;
        }

        mdlImage.localPosition = Vector3.zero;
        imgFinal.localPosition = Vector3.zero;

        StartCoroutine(WaitToApearText());
    }

    IEnumerator ActivePreviousImage()
    {
        imgFinal.gameObject.SetActive(true);

        Vector2 iniPosi = Vector3.zero;
        Vector2 finalPosi = imgFinal.localPosition + new Vector3(0f, -3000f, 0f);

        float t = Time.time;

        while (Time.time <= t + 1f)
        {
            imgFinal.localPosition = iniPosi + ((finalPosi - iniPosi) * curve.Evaluate(Time.time - t));
            yield return null;
        }

        imgFinal.anchoredPosition = finalPosi;


        iniPosi = new Vector3(0f, 3000f, 0f);

        finalPosi = Vector3.zero;

        t = Time.time;

        while (Time.time <= t + 1f)
        {
            imgInitial.localPosition = iniPosi + ((finalPosi - iniPosi) * curve.Evaluate(Time.time - t));

            yield return null;
        }

        imgInitial.localPosition = Vector3.zero;
    }

    IEnumerator WaitToApearText()
    {
        yield return new WaitForSeconds(0.5f);
        mdlImage.gameObject.SetActive(false);
        imgFinal.gameObject.SetActive(true);
    }
}
