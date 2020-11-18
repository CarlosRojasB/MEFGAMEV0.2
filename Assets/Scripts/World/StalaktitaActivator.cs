using UnityEngine;

public class StalaktitaActivator : MonoBehaviour
{
    StalactitaGenerator slkGnerator;
    bool activar=false;
    private void Awake()
    {
        slkGnerator = GetComponent<StalactitaGenerator>();
    }
    private void OnTriggerEnter(Collider other)
    {      
        if (other.gameObject.tag == "Player")
        {

        }
    }
}
