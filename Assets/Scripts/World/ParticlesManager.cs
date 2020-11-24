using System.Collections;
using UnityEngine;

public class ParticlesManager : MonoBehaviour
{
    #region Information
    #region Snow
    [Header("Snow")]
    public Transform smoke;
    #endregion
    #endregion

    public void SnowParticles(Vector3 position)
    {
        for (int i = 0; i < smoke.childCount; i++)
        {
            if (!smoke.GetChild(i).gameObject.activeSelf)
            {
                ParticleSystem smokeParticle =  smoke.GetChild(i).gameObject.GetComponent<ParticleSystem>();

                smokeParticle.gameObject.SetActive(true);

                smokeParticle.gameObject.transform.position = position;

                smokeParticle.Play();

                StartCoroutine(StopParticle(smokeParticle.gameObject, 4f));

                break;
            }
        }
    }

    IEnumerator StopParticle(GameObject particle, float time)
    {
        yield return new WaitForSeconds(time);

        particle.SetActive(false);
    }
    
}