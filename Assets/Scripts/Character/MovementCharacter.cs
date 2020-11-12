using Cinemachine;
using PathCreation;
using UnityEngine;

public class MovementCharacter : MonoBehaviour
{
#pragma warning disable CS0649

    #region Information
    [Header("Movimiento")]
    [SerializeField] float speed = 1f;
    [SerializeField] float horizontalLimit = 15f;
    float Δspeed = 0.5f;
    [SerializeField] AnimationCurve horizontalSpeedCurve;
    float distance = 0;
    [SerializeField] Transform chunks;
    PathCreator pathCreator;
    Transform model;
    [SerializeField] bool ActiveAcelerometer;
    private Quaternion calibrationQuaternion;
    #endregion

    [Space]

    #region Components
    new Transform transform;
    Rigidbody rbPlayer;
    [Header("Components")]
    [SerializeField] CinemachineVirtualCamera virtualCamera;
    CinemachineFramingTransposer framingTransposer;
    #endregion

    private void Start()
    {
        CalibrateAccelerometer();

        transform = GetComponent<Transform>();

        model = transform.GetChild(0).GetComponent<Transform>();

        rbPlayer = GetComponent<Rigidbody>();

        framingTransposer = virtualCamera.GetCinemachineComponent<CinemachineFramingTransposer>();

        pathCreator = chunks.GetChild(0).GetChild(0).gameObject.GetComponent<PathCreator>();

        transform.position = pathCreator.path.GetPointAtDistance(0, endOfPathInstruction: EndOfPathInstruction.Loop);
    }

    private void FixedUpdate()
    {
        speed += Time.deltaTime * Δspeed;

        if (speed >= 100f)
            speed = 100f;

        ForwardMovement();

        HorizontalMove();
    }

    void ForwardMovement()
    {
        Vector3 initialPosition = pathCreator.path.GetPointAtDistance(distance, endOfPathInstruction: EndOfPathInstruction.Loop);

        if (distance + (speed * Time.deltaTime) >= pathCreator.path.length)
        {
            pathCreator = chunks.GetChild(pathCreator.gameObject.transform.parent.GetSiblingIndex() + 1).GetChild(0).gameObject.GetComponent<PathCreator>();

            distance = 0;
        }
        else
            distance += speed * Time.deltaTime;

        Vector3 finalPosition = pathCreator.path.GetPointAtDistance(distance, endOfPathInstruction: EndOfPathInstruction.Loop);

        rbPlayer.velocity = (finalPosition - initialPosition).normalized * speed;

        // Rotacion
        transform.forward = (finalPosition - initialPosition).normalized;
    }
    void HorizontalMove()
    {
        if (Input.touches.Length > 0)
        {
            Touch touch = Input.GetTouch(0);

            // Movimiento
            if (touch.position.x <= (Screen.width / 2f) - (0.1f * Screen.width))
            {
                if (model.localPosition.x >= 0)
                    model.localPosition += -Vector3.right * speed * Time.deltaTime;
                else
                    model.localPosition += (-Vector3.right * speed * Time.deltaTime) * (1f - horizontalSpeedCurve.Evaluate(Mathf.Abs(model.localPosition.x) / horizontalLimit));
            }
            else if (touch.position.x >= (Screen.width / 2f) + (0.1f * Screen.width))
            {
                if (model.localPosition.x <= 0)
                    model.localPosition += Vector3.right * speed * Time.deltaTime;
                else
                    model.localPosition += (Vector3.right * speed * Time.deltaTime) * (1f - horizontalSpeedCurve.Evaluate(Mathf.Abs(model.localPosition.x) / horizontalLimit));
            }

            // Rotacion de la camara
            /*
             * Puntos (x) (y)
                    1 -horizontalLimit -12.5
                    2  horizontalLimit  12.5

                y - b = b2 - b1 / a2 - a1 (x - a)
                y - 12.5 = (25/2*hl)(x-hl)
                y = (25/2*horizontalLimit)(x-horizontalLimit) + 12.5
             */
            virtualCamera.m_Lens.Dutch = ((25f / (horizontalLimit * 2f)) * (model.localPosition.x - horizontalLimit)) + 12.5f;

            //Rotacion
            model.localEulerAngles = new Vector3(0f, 0f, virtualCamera.m_Lens.Dutch);
        }
    }
    void CalibrateAccelerometer()
    {
        Vector3 accelerationSnapShot = Input.acceleration;
        Quaternion rotateQuaternion = Quaternion.FromToRotation(new Vector3(0.0f, 0.0f, -1.0f), accelerationSnapShot);
        calibrationQuaternion = Quaternion.Inverse(rotateQuaternion);
    }

    void AcelerometerMovement()
    {
        Vector3 accelerationRaw = Input.acceleration;
        if (accelerationRaw.sqrMagnitude > 1) accelerationRaw.Normalize();
        Vector3 acceleration = FixedAccelerometer(accelerationRaw);
        Vector3 movement = (new Vector3(acceleration.x, transform.localPosition.y, 0f) * horizontalSpeedCurve.Evaluate(1 - (Mathf.Abs(transform.localPosition.x) / 18)));
        rbPlayer.velocity = movement * speed;
    }

    Vector3 FixedAccelerometer(Vector3 acceleration)
    {
        Vector3 fixedAcceleration = calibrationQuaternion * acceleration;
        return fixedAcceleration;
    }
}