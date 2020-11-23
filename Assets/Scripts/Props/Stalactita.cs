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
    #endregion
    [Space]
    #region Components
    [Header("Components")]
    [SerializeField]
    Rigidbody rbStalactita;
    #endregion

    private void OnEnable()
    {
        if (waitToShotCoroutine != null)
        {
            StopCoroutine(waitToShotCoroutine);

            waitToShotCoroutine = null;
        }

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

        rbStalactita.transform.localPosition = Vector3.zero;
    }

    IEnumerator WaitToShot()
    {
        if (Singleton<Stalactites>.instance != null)
        {
            while (Vector3.Distance(Singleton<Stalactites>.instance.player.position, transform.position) >= 40f)
                yield return null;

            shot();

            StartCoroutine(WaitToRealese(3f));
        }
    }

    void shot()
    {
        if (Singleton<Stalactites>.instance != null)
        {
            MovementCharacter movementCharacter = Singleton<Stalactites>.instance.player.gameObject.GetComponent<MovementCharacter>();

            gravityScale = ((45f / 75f) * (movementCharacter.Pspeed - 25f)) + 2f;

            rbStalactita.velocity = Vector3.zero;

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