using Cinemachine;
using PathCreation;
using UnityEngine;

public class MovementCharacter : MonoBehaviour
{
    #pragma warning disable CS0649

    #region Information
    float xDirection;
    float width;
    [Header("Movimiento")]
    [SerializeField] float speed = 1f;
    float Δspeed = 50f;
    [SerializeField] AnimationCurve curveMovement;
    [SerializeField]
    bool ActiveAcelerometer;
    private Quaternion calibrationQuaternion;
    public float MoveSpeed { get => speed; set => speed = value; }
    float distance = 0;
    #endregion

    [Space]

    #region Components
    Rigidbody rbPlayer;
    [Header("Components")]
    [SerializeField] CinemachineVirtualCamera virtualCamera;
    CinemachineFramingTransposer framingTransposer;
    [SerializeField] Transform chunks;
    PathCreator pathCreator;
    #endregion

    private void Awake()
    {
        width = Screen.width;
    }

    private void Start()
    {
        CalibrateAccelerometer();
       
        rbPlayer = GetComponent<Rigidbody>();
        framingTransposer = virtualCamera.GetCinemachineComponent<CinemachineFramingTransposer>();

        pathCreator = chunks.GetChild(0).GetChild(0).gameObject.GetComponent<PathCreator>();

        transform.position = pathCreator.path.GetPointAtDistance(0, endOfPathInstruction: EndOfPathInstruction.Loop);
    }

    private void FixedUpdate()
    {
        MoveSpeed += Time.deltaTime * (Δspeed / 100f);

        if (MoveSpeed >= 75f)
            MoveSpeed = 75f;

        if (Application.platform == RuntimePlatform.WindowsEditor)
        {
            xDirection = Input.GetAxisRaw("Horizontal") * MoveSpeed;
        }

        if (Application.platform == RuntimePlatform.Android)
        {
            if (ActiveAcelerometer == true) movementWithAcelerometer();
            else MovementTocuh();
        }
    }
    void MovementTocuh()
    {
        // Forward Movement
        Vector3 initialPosition = pathCreator.path.GetPointAtDistance(distance, endOfPathInstruction: EndOfPathInstruction.Loop);

        if (distance + (speed * Time.deltaTime) >= pathCreator.path.length)
        {
            pathCreator = chunks.GetChild(pathCreator.gameObject.transform.parent.GetSiblingIndex() + 1).GetChild(0).gameObject.GetComponent<PathCreator>();

            distance = 0;
        }
        else
            distance += speed * Time.deltaTime;

        Vector3 finalPosition = pathCreator.path.GetPointAtDistance(distance, endOfPathInstruction: EndOfPathInstruction.Loop);

        rbPlayer.velocity = (finalPosition - initialPosition).normalized * MoveSpeed;

        // Rotacion
        transform.forward = (finalPosition - initialPosition).normalized;

        if (Input.touches.Length > 0)
        {
            Touch touch = Input.GetTouch(0);

            // Movimiento
            if (touch.position.x <= (width / 2f) - (0.1f * width))
            {
                if (transform.position.x > 0f)
                    rbPlayer.velocity += -transform.right * MoveSpeed;
                else if (transform.position.x <= 0f)
                    rbPlayer.velocity += (-transform.right * MoveSpeed) * curveMovement.Evaluate(1f - (Mathf.Abs(transform.position.x) / 18f));
            }
            else if (touch.position.x >= (width / 2f) + (0.1f * width))
            {
                if (transform.position.x < 0f)
                    rbPlayer.velocity += transform.right * MoveSpeed;
                else if (transform.position.x >= 0f)
                    rbPlayer.velocity += (transform.right * MoveSpeed) * curveMovement.Evaluate(1f - (Mathf.Abs(transform.position.x) / 18f));
            }

            // Rotacion de la camara
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
        rbPlayer.velocity = movement * speed;
    }
}