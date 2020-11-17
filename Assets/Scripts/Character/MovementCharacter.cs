using Cinemachine;
using PathCreation;
using UnityEngine;

public class MovementCharacter : MonoBehaviour
{
    #pragma warning disable CS0649

    #region Information
    [Header("Movimiento")]
    [Range(0, 150f)]
    [SerializeField] float speed = 25f;
    float speedscale = 1f;
    [SerializeField] float horizontalLimit = 15f;
    [SerializeField] AnimationCurve horizontalSpeedCurve;
    float distance = 0;
    Vector3 finalPosition;
    Vector3 initialPosition;
    [SerializeField] Transform chunks;
    PathCreator pathCreator;
    Vector3 lowPassValue;
    #endregion

    #region Events
    public event System.Action<float> OnMove;
    #endregion

    [Space]

    #region Components
    new Transform transform;
    [Header("Components")]
    [SerializeField] Transform model;
    Transform camera;
    Rigidbody rbPlayer;
    #endregion

    private void Start()
    {
        transform = GetComponent<Transform>();

        rbPlayer = GetComponent<Rigidbody>();

        camera = model.GetChild(0).gameObject.transform;

        pathCreator = chunks.GetChild(0).GetChild(0).gameObject.GetComponent<PathCreator>();

        transform.position = pathCreator.path.GetPointAtDistance(0);

        initialPosition = transform.position;

        lowPassValue = Input.acceleration;
    }

    private void FixedUpdate()
    {
        if (speed < 150f)
            speed += Time.fixedDeltaTime;
        else if (speed >= 150f)
            speed = 105f;

        ForwardMovement();

        HorizontalMove();
    }

    void ForwardMovement()
    {
        if (finalPosition != Vector3.zero)
            initialPosition = finalPosition;

        float nextDistance = distance + (((speed + Time.fixedDeltaTime) * speedscale) * Time.deltaTime);

        OnMove?.Invoke(nextDistance - distance);

        if (nextDistance >= pathCreator.path.length)
        {
            distance = nextDistance - pathCreator.path.length;

            pathCreator = chunks.GetChild(pathCreator.gameObject.transform.parent.GetSiblingIndex() + 1).GetChild(0).gameObject.GetComponent<PathCreator>();
        }
        else
            distance += ((speed * speedscale)* Time.fixedDeltaTime);

        finalPosition = pathCreator.path.GetPointAtDistance(distance);

        rbPlayer.MovePosition(finalPosition);

        // Rotacion
        transform.forward = (finalPosition - initialPosition).normalized;
    }

    void HorizontalMove()
    {
        #if UNITY_EDITOR
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

                //Rotacion
                camera.localEulerAngles = new Vector3(0f, -(((25f / (horizontalLimit * 2f)) * (model.localPosition.x - horizontalLimit)) + 12.5f), ((25f / (horizontalLimit * 2f)) * (model.localPosition.x - horizontalLimit)) + 12.5f);
            }
        }
        #else
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
            camera.localEulerAngles = new Vector3(0f, -(((25f / (horizontalLimit * 2f)) * (model.localPosition.x - horizontalLimit)) + 12.5f), ((25f / (horizontalLimit * 2f)) * (model.localPosition.x - horizontalLimit)) + 12.5f);
        }
        #endif
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
            Gizmos.color = Color.red;
            Gizmos.DrawSphere(initialPosition, 0.5f);

            Gizmos.color = Color.white;
            Gizmos.DrawSphere(model.position + (model.right * horizontalLimit), 0.5f);
            Gizmos.DrawLine(model.position - (model.right * horizontalLimit), model.position + (model.right * horizontalLimit));
            Gizmos.DrawSphere(model.position - (model.right * horizontalLimit), 0.5f);
        }
    }
#endif
}