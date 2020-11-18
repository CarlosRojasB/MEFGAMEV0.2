using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IceControl : MonoBehaviour {

    public float delay = 5;

    float icePower;

    float timer;

	void Start () {
        Shader.SetGlobalFloat("IcePower", 0);
    }
	
	void Update () {
        if (timer < delay)
        {
            timer += Time.deltaTime;
        }
        else
        {
            if (icePower < 1)
            {
                icePower += Time.deltaTime / 14;
                Shader.SetGlobalFloat("IcePower", icePower);
            }
        }
	}

    void OnDestroy(){
        Shader.SetGlobalFloat("IcePower", 0);
    }

}
