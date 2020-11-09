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

    bool initialPath = true;
    private void Awake()
    {
        movementZWorldBezier = gameObject.transform.parent.parent.gameObject.GetComponent<MovementZWorldBezier>();
    }
    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Path")
        {
            if (initialPath)
            {
                initialPath = false;

                namePath = other.name;
                movementZWorldBezier.PathTofollowBezzier = namePath;
                movementZWorldBezier.PathCreator = other.GetComponent<PathCreator>();
                movementZWorldBezier.Distance = 0;
            }
            else
            {
                movementZWorldBezier.OnEndPath = () =>
                {
                    namePath = other.name;
                    movementZWorldBezier.PathTofollowBezzier = namePath;
                    PathCreator otherPath = other.GetComponent<PathCreator>();
                    movementZWorldBezier.PathCreator = other.GetComponent<PathCreator>();
                    //movementZWorldBezier.Distance = movementZWorldBezier.PathCreator.path.GetClosestDistanceAlongPath(transform.position); 
                    movementZWorldBezier.Distance = 0;
                };
            }
        }
    }
}
