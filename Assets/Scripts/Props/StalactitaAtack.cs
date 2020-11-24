using UnityEngine;

public class StalactitaAtack : MonoBehaviour
{
    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.transform.parent.tag == "Player")
            other.gameObject.transform.parent.gameObject.GetComponent<PlayerLife>().Death(); 
    }
}