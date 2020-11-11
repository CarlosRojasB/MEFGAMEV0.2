using Cinemachine;
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

    private Quaternion calibrationQuaternion;
    public float MoveSpeed { get => _moveSpeed; set => _moveSpeed = value; }
    #endregion



    private void Awake()
    {
        width = Screen.width;
    }

    private void Start()
    {
        CalibrateAccelerometer();
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
    }
    void MovementTocuh()
    {
        if (Input.touches.Length > 0)
        {
            Touch touch = Input.GetTouch(0);

            // Movimiento
            if (touch.position.x <= (width / 2f) - (0.1f * width))
            {
                if (transform.localPosition.x > 0f)
                    rbPlayer.velocity = -transform.right * MoveSpeed;
                else if (transform.localPosition.x <= 0f)
                    rbPlayer.velocity = (-transform.right * MoveSpeed) * curveMovement.Evaluate(1f - (Mathf.Abs(transform.localPosition.x) / 18f));
            }
            else if (touch.position.x >= (width / 2f) + (0.1f * width))
            {
                if (transform.localPosition.x < 0f)
                    rbPlayer.velocity = transform.right * MoveSpeed;
                else if (transform.localPosition.x >= 0f)
                    rbPlayer.velocity = (transform.right * MoveSpeed) * curveMovement.Evaluate(1f - (Mathf.Abs(transform.localPosition.x) / 18f));

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

            virtualCamera.m_Lens.FieldOfView = curveMovement.Evaluate(1f - (Mathf.Abs(transform.localPosition.x) / 40.5f)) * 40f;
        }
        else
            rbPlayer.velocity = Vector3.zero;
    }
    void CalibrateAccelerometer()
    {
        Vector3 accelerationSnapShot = Input.acceleration;
        Quaternion rotateQuaternion = Quaternion.FromToRotation(new Vector3(0.0f, 0.0f, -1.0f), accelerationSnapShot);
        calibrationQuaternion = Quaternion.Inverse(rotateQuaternion);

    }
    Vector3 FixedAccelerometer(Vector3 acceleration)
    {
        Vector3 fixedAcceleration = calibrationQuaternion * acceleration;
        return fixedAcceleration;
    }

    void movementWithAcelerometer()
    {
        /*_dirx = Input.acceleration.x * MoveSpeed;
        rbPlayer.velocity = new Vector2(_dirx, transform.position.y) * curveMovement.Evaluate(1 - (Mathf.Abs(transform.localPosition.x) / 18));*/

        Vector3 accelerationRaw = Input.acceleration;
        if (accelerationRaw.sqrMagnitude > 1) accelerationRaw.Normalize();
        Vector3 acceleration = FixedAccelerometer(accelerationRaw);
        Vector3 movement = (new Vector3(acceleration.x, transform.localPosition.y, 0f) * curveMovement.Evaluate(1 - (Mathf.Abs(transform.localPosition.x) / 18)));
        rbPlayer.velocity = movement * _moveSpeed;

    }



}