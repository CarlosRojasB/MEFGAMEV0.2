using Cinemachine;
using PathCreation;
using UnityEngine;

public class MovementCharacter : MonoBehaviour
{
#pragma warning disable CS0649

    #region Information
    [Header("Movimiento")]
    [Range(0, 125f)]
    [SerializeField] float speed = 1f;
    [SerializeField] Transform model;
    [SerializeField] float horizontalLimit = 15f;
    float Δspeed = 0.5f;
    [SerializeField] AnimationCurve horizontalSpeedCurve;
    float distance = 0;
    [SerializeField] Transform chunks;
    PathCreator pathCreator;
    Vector3 lowPassValue;
    [SerializeField] bool ActiveAcelerometer;
    private Quaternion calibrationQuaternion;
    #endregion

    [Space]

    #region Components
    new Transform transform;
    Rigidbody rbPlayer;
    #endregion

    private void Start()
    {
        transform = GetComponent<Transform>();

        rbPlayer = GetComponent<Rigidbody>();

        pathCreator = chunks.GetChild(0).GetChild(0).gameObject.GetComponent<PathCreator>();

        transform.position = pathCreator.path.GetPointAtDistance(0, endOfPathInstruction: EndOfPathInstruction.Loop);

        lowPassValue = Input.acceleration;
    }

    private void FixedUpdate()
    {
        speed += Time.fixedDeltaTime * Δspeed;

        if (speed >= 125f)
            speed = 125f;

        ForwardMovement();

        HorizontalMove();
    }

    void ForwardMovement()
    {
        Vector3 initialPosition = pathCreator.path.GetPointAtDistance(distance, endOfPathInstruction: EndOfPathInstruction.Loop);

        if (distance + (speed * Time.fixedDeltaTime) >= pathCreator.path.length)
        {
            pathCreator = chunks.GetChild(pathCreator.gameObject.transform.parent.GetSiblingIndex() + 1).GetChild(0).gameObject.GetComponent<PathCreator>();

            distance = 0;
        }
        else
            distance += speed * Time.fixedDeltaTime;

        Vector3 finalPosition = pathCreator.path.GetPointAtDistance(distance, endOfPathInstruction: EndOfPathInstruction.Loop);

        rbPlayer.velocity = (finalPosition - initialPosition).normalized * speed;

        // Rotacion
        transform.forward = (finalPosition - initialPosition).normalized;
    }
    void HorizontalMove()
    {
        if (Application.platform == RuntimePlatform.WindowsEditor)
        {
            if (Input.touches.Length > 0)
            {
                Touch touch = Input.GetTouch(0);

                // Movimiento
                if (touch.position.x <= (Screen.width / 2f) - (0.1f * Screen.width))
                {
                    if (model.localPosition.x >= 0)
                        model.localPosition += -Vector3.right * speed * Time.fixedDeltaTime;
                    else
                        model.localPosition += (-Vector3.right * speed * Time.fixedDeltaTime) * (1f - horizontalSpeedCurve.Evaluate(Mathf.Abs(model.localPosition.x) / horizontalLimit));
                }
                else if (touch.position.x >= (Screen.width / 2f) + (0.1f * Screen.width))
                {
                    if (model.localPosition.x <= 0)
                        model.localPosition += Vector3.right * speed * Time.fixedDeltaTime;
                    else
                        model.localPosition += (Vector3.right * speed * Time.fixedDeltaTime) * (1f - horizontalSpeedCurve.Evaluate(Mathf.Abs(model.localPosition.x) / horizontalLimit));
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

                //Rotacion
                model.localEulerAngles = new Vector3(0f, 0f, ((25f / (horizontalLimit * 2f)) * (model.localPosition.x - horizontalLimit)) + 12.5f);
            }
        }
        else if(Application.platform == RuntimePlatform.Android || Application.platform == RuntimePlatform.IPhonePlayer)
        {
            Vector3 filteredAccelValue = filterAccelValue(true);

            // Movimiento
            if (filteredAccelValue.x <= 0)
            {
                if (model.localPosition.x >= 0)
                    model.localPosition += -Vector3.right * speed * Time.fixedDeltaTime;
                else
                    model.localPosition += (-Vector3.right * speed * Time.fixedDeltaTime) * (1f - horizontalSpeedCurve.Evaluate(Mathf.Abs(model.localPosition.x) / horizontalLimit));
            }
            else if (filteredAccelValue.x > 0)
            {
                if (model.localPosition.x <= 0)
                    model.localPosition += Vector3.right * speed * Time.fixedDeltaTime;
                else
                    model.localPosition += (Vector3.right * speed * Time.fixedDeltaTime) * (1f - horizontalSpeedCurve.Evaluate(Mathf.Abs(model.localPosition.x) / horizontalLimit));
            }

            //Rotacion
            model.localEulerAngles = new Vector3(0f, 0f, ((25f / (horizontalLimit * 2f)) * (model.localPosition.x - horizontalLimit)) + 12.5f);
        }
    }

    Vector3 filterAccelValue(bool smooth)
    {
        if (smooth)
            lowPassValue = Vector3.Lerp(lowPassValue, Input.acceleration, 1f / 30f);
        else
            lowPassValue = Input.acceleration;

        return lowPassValue;
    }

#if UNITY_EDITOR
    private void OnDrawGizmos()
    {
        if (model != null)
        {
            Gizmos.DrawSphere(model.position + (model.right * horizontalLimit), 0.5f);
            Gizmos.DrawLine(model.position - (model.right * horizontalLimit), model.position + (model.right * horizontalLimit));
            Gizmos.DrawSphere(model.position - (model.right * horizontalLimit), 0.5f);
        }
    }
    #endif
}