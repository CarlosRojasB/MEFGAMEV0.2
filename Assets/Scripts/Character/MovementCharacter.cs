using Cinemachine;
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
    [SerializeField]
    bool ActiveAcelerometer;

    [Space]
    #region Components
    [Header("Components")]
    [SerializeField]
    CinemachineVirtualCamera virtualCamera;
    CinemachineFramingTransposer framingTransposer;

    public float MoveSpeed { get => _moveSpeed; set => _moveSpeed = value; }
    #endregion



    private void Awake()
    {
        width = Screen.width;
    }

    private void Start()
    {
        framingTransposer = virtualCamera.GetCinemachineComponent<CinemachineFramingTransposer>();
        rbPlayer = GetComponent<Rigidbody>();
    }

    private void FixedUpdate()
    {
        if (Application.platform == RuntimePlatform.WindowsEditor)
        {
            _dirx = Input.GetAxisRaw("Horizontal") * MoveSpeed;

            rbPlayer.velocity = (transform.right * _dirx);
        }
        if (Application.platform == RuntimePlatform.Android)
        {
            if (ActiveAcelerometer == true) movementWithAcelerometer();
            else MovementTocuh();

        }
        framingTransposer.m_DeadZoneWidth = (curveMovement.Evaluate((Mathf.Abs(transform.localPosition.x) /17.5f)))*0.32f;
     
    }
    void MovementTocuh()
    {

            if (Input.touches.Length > 0)
            {
                Touch touch = Input.GetTouch(0);

                // Movimiento
                if (touch.position.x <= (width / 2) - (0.1f * width))
                {
                    if (transform.localPosition.x > 0)
                        rbPlayer.velocity = -transform.right * MoveSpeed;
                    else if (transform.localPosition.x <= 0)
                        rbPlayer.velocity = (-transform.right * MoveSpeed) * curveMovement.Evaluate(1 - (Mathf.Abs(transform.localPosition.x) / 18));

                }
                else if (touch.position.x >= (width / 2) + (0.1f * width))
                {
                    if (transform.localPosition.x < 0)
                        rbPlayer.velocity = transform.right * MoveSpeed;
                    else if (transform.localPosition.x >= 0)
                        rbPlayer.velocity = (transform.right * MoveSpeed) * curveMovement.Evaluate(1 - (Mathf.Abs(transform.localPosition.x) / 18));

                }

                //Rotacion
                if (touch.position.x <= (width / 2) - (0.1f * width))
                {
                    virtualCamera.m_Lens.Dutch -= 0.1f;

                    if (virtualCamera.m_Lens.Dutch < -12.5f)
                        virtualCamera.m_Lens.Dutch = -12.5f;
                }
                else if (touch.position.x >= (width / 2) + (0.1f * width))
                {
                    virtualCamera.m_Lens.Dutch += 0.1f;

                    if (virtualCamera.m_Lens.Dutch > 12.5f)
                        virtualCamera.m_Lens.Dutch = 12.5f;
                }






            }
            else
                rbPlayer.velocity = Vector3.zero;

        
    }

    void movementWithAcelerometer()
    {
        _dirx = Input.acceleration.x * MoveSpeed;      

       // rbPlayer.velocity = (transform.right * _dirx);
        rbPlayer.velocity = (transform.right * _dirx) * curveMovement.Evaluate(1 - (Mathf.Abs(transform.localPosition.x) / 18));
    }


    

   
}