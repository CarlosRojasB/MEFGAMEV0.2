using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MovementCharacter : MonoBehaviour
{
    Rigidbody rbPlayer;
    float _dirx;
    [SerializeField] float _moveSpeed=20f;
    [SerializeField] float _moveSpeedGeneral;

   

    private void Start()
    {
        rbPlayer = GetComponent<Rigidbody>();
    }



    private void FixedUpdate()
    {
        if (Application.platform == RuntimePlatform.WindowsEditor)
        {
            _dirx = Input.GetAxisRaw("Horizontal") * _moveSpeed;

             //rbPlayer.velocity = new Vector2(_dirx, 0f);

            //float xVel = transform.InverseTransformDirection(rbPlayer.velocity).x;

             rbPlayer.velocity = (transform.right* _dirx);

            //transform.localPosition = new  Vector3 (transform.localPosition.x*_dirx,0f,0f);



        }
        else if (Application.platform == RuntimePlatform.Android)
        {
            _dirx = Input.acceleration.x * _moveSpeed;
            rbPlayer.velocity = (transform.right * _dirx);
        }


     //   rbPlayer.velocity = new Vector3(0, 0, _moveSpeedGeneral);

    }




}
