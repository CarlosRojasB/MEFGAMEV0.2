using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UiZoomImage : MonoBehaviour
{
    Camera mainCamera;
    float touchesPrevPosDifference, touchesCurPosDifference, zoomModifier;
    Vector2 firstTouchPrevPos, secondTouchPrevPos, mediumPoint;

    [SerializeField]
    float zoomModifierSpeed=0.1f;
    [SerializeField]
    RectTransform imgHadas;
    [SerializeField]
    ScrollRect ScroolRect;
    private void Start()
    {
        ScroolRect.GetComponent<ScrollRect>();      
    }

    private void Update()
    {



        if (Input.touchCount == 2)
        {
            ScroolRect.enabled = false;
            Touch firstTouch = Input.GetTouch(0);
            Touch seconTouch = Input.GetTouch(1);

            firstTouchPrevPos = firstTouch.position - firstTouch.deltaPosition;
            secondTouchPrevPos = seconTouch.position - seconTouch.deltaPosition;

            touchesPrevPosDifference = (firstTouchPrevPos - secondTouchPrevPos).magnitude;
            touchesCurPosDifference = (firstTouch.position - seconTouch.position).magnitude;

            mediumPoint=new Vector2((firstTouch.position.x+seconTouch.position.x)/2,(firstTouch.position.y+seconTouch.position.y)/2);
            zoomModifier = (firstTouch.deltaPosition - seconTouch.deltaPosition).magnitude * zoomModifier;

            if (touchesPrevPosDifference > touchesCurPosDifference)
            {

                imgHadas.localScale = new Vector2(imgHadas.localScale.x - zoomModifierSpeed, imgHadas.localScale.y - zoomModifierSpeed);
                if (imgHadas.localScale.x <= 1f)
                    imgHadas.localScale = Vector3.one;               

            }

            if (touchesPrevPosDifference < touchesCurPosDifference)
            {
                imgHadas.localScale = new Vector2(imgHadas.localScale.x + zoomModifierSpeed, imgHadas.localScale.y + zoomModifierSpeed);
                if (imgHadas.localScale.x >= 2f)
                    imgHadas.localScale = new Vector3(2f, 2f, 2f);                
            }         
        }
        else 
        {
            ScroolRect.enabled = true;
        }
      /*  Touch firstTouch1=Input.GetTouch(0); ; 
        if (Input.touchCount == 1)
            print(firstTouch1.position);*/
    }
}