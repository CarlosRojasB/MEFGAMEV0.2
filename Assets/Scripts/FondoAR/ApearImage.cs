using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ApearImage : MonoBehaviour
{
    [SerializeField] RectTransform ImageToAppear;
    [SerializeField] AnimationCurve curve;

    private void OnEnable()
    {
        StartCoroutine(ActiveImage());
    }

    public IEnumerator ActiveImage()
    {
        ImageToAppear.gameObject.SetActive(true);

        Vector2 initialPosition = new Vector3(0f,-3000f,0f);
        Vector2 finalPosition = Vector3.zero;

        float t = Time.time;

        while (Time.time <= t + 1f)
        {
            ImageToAppear.localPosition = initialPosition - ((finalPosition + initialPosition) * curve.Evaluate(Time.time - t));

            yield return null;
        }

        ImageToAppear.anchoredPosition = finalPosition;
        
    }
}
