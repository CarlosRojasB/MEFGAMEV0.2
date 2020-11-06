
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using PathCreation;

public class MovementZWorldBezier : MonoBehaviour
{
    //Variables serializables
    [Header("Variables movimiento", order = 0)]
    [SerializeField]
    float movementSpeed = 5;
    [SerializeField]
    PathCreator pathCreator;
    [SerializeField]
    string pathTofollowBezzier;

    //Variables privadas
    float distance;

    //Variables encapsuladas
    public PathCreator PathCreator { get => pathCreator; set => pathCreator = value;}
    public string PathTofollowBezzier { get => pathTofollowBezzier; set => pathTofollowBezzier = value; }
    public float Distance { get => distance; set => distance = value; }

    private void Update()
    {
        Distance += movementSpeed * Time.deltaTime;


        transform.position = pathCreator.path.GetPointAtDistance(Distance,endOfPathInstruction:EndOfPathInstruction.Loop);
        transform.rotation = pathCreator.path.GetRotationAtDistance(Distance, endOfPathInstruction: EndOfPathInstruction.Loop);




        //transform.position = pathCreator.path.GetPointAtTime(distance);

    }


}
