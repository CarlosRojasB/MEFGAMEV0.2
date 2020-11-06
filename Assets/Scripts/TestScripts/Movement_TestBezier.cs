using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using PathCreation;

public class Movement_TestBezier : MonoBehaviour
{
   
    [Header("Variables movimiento")]
    [SerializeField]
    float movementSpeed=5;
    [SerializeField]
    PathCreator pathCreator;

    float distanceTraveled;

    private void FixedUpdate()
    {
        distanceTraveled += movementSpeed * Time.deltaTime;
        transform.position = pathCreator.path.GetPointAtDistance(distanceTraveled);
        transform.rotation = pathCreator.path.GetRotationAtDistance(distanceTraveled);
    }
}
