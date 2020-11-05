using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MovementCharacter : MonoBehaviour
{

    Rigidbody rbPlayer;
    float _dirx;
    float width;
    [Header("Movimiento con giroscopio")]
    [SerializeField] float _moveSpeed = 20f;
    [SerializeField] float _moveSpeedGeneral;
    [Header("Movimiento con touch")]
    [SerializeField] float _moveSpeedTouh;
    [SerializeField]
    AnimationCurve curveMovement;



    private void Awake()
    {
        width = Screen.width;
    }

    private void Start()
    {
        rbPlayer = GetComponent<Rigidbody>();
    }



    private void FixedUpdate()
    {
        if (Application.platform == RuntimePlatform.WindowsEditor)
        {
            _dirx = Input.GetAxisRaw("Horizontal") * _moveSpeed;


            rbPlayer.velocity = (transform.right * _dirx);

           



        }
        if (Application.platform == RuntimePlatform.Android)
        {
            // movementWithAcelerometer();

            if (Input.touches.Length > 0)
            {
                Touch touch = Input.GetTouch(0);
                if (touch.position.x < (width / 2) - (0.1f * width))
                {

                    Vector3 velocity = rbPlayer.velocity;
                    velocity.y = 0;
                    velocity.x = 0;
                    rbPlayer.velocity = velocity;
                    rbPlayer.velocity = Vector3.zero;

                    if (touch.position.x < (width / 2) - (0.1f * width))
                    {
                        rbPlayer.velocity = (-transform.right * _moveSpeed) * curveMovement.Evaluate(1 - (Mathf.Abs(transform.localPosition.x) / 20));
                    }
                    else if(touch.position.x > (width / 2) + (0.1f * width))
                    {
                        rbPlayer.velocity = (-transform.right * _moveSpeed);
                    }
                    

             



                }
                else if (touch.position.x > (width / 2) + (0.1f * width))
                {
                    Vector3 velocity = rbPlayer.velocity;
                    velocity.y = 0;
                    velocity.x = 0;
                    rbPlayer.velocity = velocity;
                    rbPlayer.velocity = Vector3.zero;
                    if(touch.position.x > (width / 2) - (0.1f * width))
                    {
                       rbPlayer.velocity = (transform.right * _moveSpeed) * curveMovement.Evaluate(1 - (Mathf.Abs(transform.localPosition.x) / 20));
                    }

                    else if (touch.position.x < (width / 2) - (0.1f * width))
                    {
                        rbPlayer.velocity = (transform.right * _moveSpeed);

                    }
                        




                }


                if (touch.phase == TouchPhase.Ended)
                {
                    rbPlayer.velocity = Vector3.zero;
                }
            }
          

        }

        else
        {
            rbPlayer.velocity = Vector3.zero;

        }


    }



    void movementWithAcelerometer()
    {
        _dirx = Input.acceleration.x * _moveSpeed;
        rbPlayer.velocity = (transform.right * _dirx);
    }
  



}
