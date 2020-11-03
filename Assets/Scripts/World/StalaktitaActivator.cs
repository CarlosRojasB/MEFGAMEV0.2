using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StalaktitaActivator : MonoBehaviour
{
    StalackticaGenerator slkGnerator;
    bool activar=false;
    private void Awake()
    {
        slkGnerator = GetComponent<StalackticaGenerator>();
    }
    private void OnTriggerEnter(Collider other)
    {      

        if (other.gameObject.tag == "Player")
        {

            
            activar = true;
            slkGnerator.ActivatorStalacktitas(activar);
        }
    }
}
