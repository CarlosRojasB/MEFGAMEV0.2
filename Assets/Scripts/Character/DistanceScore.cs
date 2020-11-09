using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DistanceScore : MonoBehaviour
{
    Vector3 posInicial;
    public static float distance;
    private float Counter = 0;
    MovementZWorldBezier mvChara;

    public float Distance { get => distance; set => distance = value; }

    private void Awake()
    {
        mvChara = gameObject.GetComponentInParent<MovementZWorldBezier>();
        //posInicial = GameObject.Find("PlayerCollisionator").GetComponent<Transform>();
        posInicial = new Vector3(gameObject.transform.position.x, gameObject.transform.position.y, gameObject.transform.position.z);
    }
    private void FixedUpdate()
    {
        Counter += Time.deltaTime;
        //distance = Counter * mvChara.Speed;
        // distance = (posInicial - transform.position).magnitude;       
    }
}
