using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StalactitaAtack : MonoBehaviour
{
    PlayerLife _plLife;
    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {


            _plLife = other.GetComponent<PlayerLife>();
            _plLife.PlLifes--;
            ManagerScene.Instance.GoToLose();
            

        }
    }

}
