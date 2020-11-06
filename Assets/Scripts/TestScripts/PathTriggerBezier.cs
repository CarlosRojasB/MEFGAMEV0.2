using PathCreation;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PathTriggerBezier : MonoBehaviour
{
    //Variables serializadas
    [Header("Variables del path", order = 0)]
    [SerializeField]
    string namePath;

    //Variables privadas
    MovementZWorldBezier movementZWorldBezier;
    private void Awake()
    {
        movementZWorldBezier = gameObject.transform.parent.parent.gameObject.GetComponent<MovementZWorldBezier>();
    }
    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Path")
        {
            namePath = other.name;
            movementZWorldBezier.PathCreator = other.GetComponent<PathCreator>();
            movementZWorldBezier.Distance = 0;
            movementZWorldBezier.PathTofollowBezzier = namePath;
        }
     
    }

}
