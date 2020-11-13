using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ActiveButtonForTrivia : MonoBehaviour
{
    #region Information
    [SerializeField] Transform btnForTrivia;
    [SerializeField] Camera mycamera;
    [SerializeField] GameObject Trivia;
    #endregion

    private void Start()
    {
        mycamera = Camera.main;
       
    }

    private void Update()
    {
        RaycastHit hit;
        Vector3 CameraCenter = mycamera.ScreenToWorldPoint(new Vector3(Screen.width / 2, Screen.height / 2, mycamera.nearClipPlane));
        if (Physics.Raycast(CameraCenter, transform.forward, out hit))
        {
            btnForTrivia.gameObject.SetActive(true);
        }
        else
        {
            btnForTrivia.gameObject.SetActive(false);
        }
    }


    public void GoToTrivia()
    {
        Trivia.SetActive(true);
    }



}
