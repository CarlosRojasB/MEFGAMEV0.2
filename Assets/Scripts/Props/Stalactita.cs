using System.Collections;
using UnityEngine;

public class Stalactita : MonoBehaviour
{
    #pragma warning disable CS0649

    #region Information
    [Header("Information")]
    [SerializeField]
    AnimationCurve velocityChangeCurve;
    float gravityScale = 2f;
    Coroutine waitToShotCoroutine;
    bool shot;
    #endregion
    [Space]
    #region Components
    [Header("Components")]
    [SerializeField]
    Rigidbody rbStalactita;
    Vector3 localMiddlePosition;
    [SerializeField]
    Rigidbody anotherRbStalactita;
    Vector3 anotherLocalMiddlePosition;
    Vector3 localMiddleAngle;
    [HideInInspector]
    public ParticlesManager particlesManager;
    #endregion

    private void Awake()
    {
        localMiddlePosition = rbStalactita.gameObject.transform.localPosition;

        if (anotherRbStalactita != null)
        {
            anotherLocalMiddlePosition = anotherRbStalactita.gameObject.transform.localPosition;
            localMiddleAngle = anotherRbStalactita.gameObject.transform.localEulerAngles;
        }
    }

    private void OnEnable()
    {
        if (waitToShotCoroutine != null)
        {
            StopCoroutine(waitToShotCoroutine);

            waitToShotCoroutine = null;
        }

        shot = false;

        waitToShotCoroutine = StartCoroutine(WaitToShot());
    }

    private void OnDisable()
    {
        if (waitToShotCoroutine != null)
        {
            StopCoroutine(waitToShotCoroutine);

            waitToShotCoroutine = null;
        }

        rbStalactita.velocity = Vector3.zero;

        rbStalactita.transform.localPosition = localMiddlePosition;

        if (anotherRbStalactita != null)
        {
            anotherRbStalactita.useGravity = false;

            anotherRbStalactita.velocity = Vector3.zero;

            anotherRbStalactita.transform.localPosition = anotherLocalMiddlePosition;

            anotherRbStalactita.transform.localEulerAngles = localMiddleAngle;
        }
    }

    IEnumerator WaitToShot()
    {
        if (Stalactites.instance != null)
        {
            while (Vector3.Distance(Stalactites.instance.player.position, transform.position) >= 41f)
            {
                if (Vector3.Distance(Stalactites.instance.player.position, transform.position) <= 80f)
                {
                    if (!shot)
                    {
                        shot = true;

                        particlesManager.SnowParticles(transform.position);
                    }

                }

                yield return null;
            }

            Shot();

            StartCoroutine(WaitToRealese(3f));
        }
    }

    void Shot()
    {
        if (Stalactites.instance != null)
        {
            MovementCharacter movementCharacter = Stalactites.instance.player.gameObject.GetComponent<MovementCharacter>();

            gravityScale = ((46f / 75f) * (movementCharacter.Pspeed - 25f)) + 2f;

            StalactitaGenerator.level = ((int)movementCharacter.Pspeed) / 10;

            rbStalactita.velocity = Vector3.zero;

            if (anotherRbStalactita != null)
            {
                anotherRbStalactita.useGravity = true;

                anotherRbStalactita.AddRelativeForce((transform.position - Stalactites.instance.player.gameObject.transform.position).normalized * 35f, ForceMode.Impulse);

                anotherRbStalactita.AddRelativeTorque(new Vector3(Random.Range(-50f, 50f), Random.Range(-50f, 50f), Random.Range(-50f, 50f)), ForceMode.Impulse);
            }

            StartCoroutine(GetVelocity(-9.81f * gravityScale * Vector3.up));
        }
    }

    IEnumerator GetVelocity(Vector3 finalVelocity)
    {
        float t = Time.time;

        while (Time.time <= t + 0.75f)
        {
            rbStalactita.velocity = finalVelocity * velocityChangeCurve.Evaluate((Time.time - t) / 0.75f);

            yield return null;
        }

        rbStalactita.velocity = finalVelocity;
    }

    IEnumerator WaitToRealese(float timeToDisapear)
    {
        yield return new WaitForSeconds(timeToDisapear);

        Realese();
    }

    void Realese()
    {
        gameObject.SetActive(false);
    }
}