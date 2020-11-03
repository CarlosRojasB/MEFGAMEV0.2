using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Stalactita : MonoBehaviour
{
    private bool shootACtive;
    [SerializeField]
    private float timeToShot,velBala;
   
    
    private Rigidbody RbStalactita;


    
    private void Awake()
    {
        RbStalactita = gameObject.GetComponentInChildren<Rigidbody>();
       // RbStalactita.AddForce(new Vector3(0, 0, 0), ForceMode.Impulse);
      //  RbStalactita.useGravity = false;
    }
    
    private void OnEnable()
    {
        StartCoroutine(waitToShot(timeToShot));
    }
    private void OnDisable()
    {
        RbStalactita.transform.position = gameObject.transform.position;
        RbStalactita.velocity = Vector3.zero;
    }
    void shot()
   {

        RbStalactita.velocity = new Vector3(0, -velBala*Time.deltaTime, 0);

       // RbStalactita.AddForce(-Vector3.up, ForceMode.Impulse);
        //RbStalactita.useGravity = true;      
   }
  IEnumerator waitToShot(float _timeToShot)
  {
        yield return new WaitForSeconds(_timeToShot);
        shot();
        StartCoroutine(WaitToRealese(_timeToShot + 2f));
  }

    IEnumerator WaitToRealese(float _TimeToDisapear)
    {
        yield return new WaitForSeconds(_TimeToDisapear);
        Realese();
    }

    void Realese()
    {
        //RbStalactita.AddForce(new Vector3(0, 0, 0), ForceMode.Impulse);
       // RbStalactita.useGravity = false;
       
        gameObject.SetActive(false);
    }




}
