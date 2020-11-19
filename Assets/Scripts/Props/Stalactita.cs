using System.Collections;
using UnityEngine;

public class Stalactita : MonoBehaviour
{
    #pragma warning disable CS0649

    #region Information
    public float shotSpeed = 1000;
    #endregion

    #region Components
    [SerializeField]
    Rigidbody rbStalactita;
    #endregion

    private void OnDisable()
    {
        rbStalactita.velocity = Vector3.zero;

        rbStalactita.transform.localPosition = Vector3.zero;
    }

    void shot()
    {
        rbStalactita.velocity = new Vector3(0, -shotSpeed * Time.deltaTime, 0);
    }

    IEnumerator waitToShot(float timeToShot)
    {
        yield return new WaitForSeconds(timeToShot);
        shot();
        StartCoroutine(WaitToRealese(timeToShot + 2f));
    }

    IEnumerator WaitToRealese(float _TimeToDisapear)
    {
        yield return new WaitForSeconds(_TimeToDisapear);
        Realese();
    }

    void Realese()
    {
        gameObject.SetActive(false);
    }
}