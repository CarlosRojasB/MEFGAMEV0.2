
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
    private float counter;
    MovementCharacter mvcharacter;

    //Variables encapsuladas
    public PathCreator PathCreator { get => pathCreator; set => pathCreator = value;}
    public string PathTofollowBezzier { get => pathTofollowBezzier; set => pathTofollowBezzier = value; }
    public float Distance { get => distance; set => distance = value; }


    private void Start()
    {
       mvcharacter=gameObject.transform.GetChild(0).GetChild(0).GetComponent<MovementCharacter>();
    }
    private void Update()
    {
        Distance += movementSpeed * Time.deltaTime;


        transform.position = pathCreator.path.GetPointAtDistance(Distance,endOfPathInstruction:EndOfPathInstruction.Loop);
        transform.rotation = pathCreator.path.GetRotationAtDistance(Distance, endOfPathInstruction: EndOfPathInstruction.Loop);


        PlusVelocityInTime();

        //transform.position = pathCreator.path.GetPointAtTime(distance);

    }
    void PlusVelocityInTime()
    {
        counter += Time.deltaTime;
        if (counter >= 10)
        {
            print("Entro");
            Time.timeScale += 0.1f;
            //movementSpeed += 0.03f;
            counter = 0;
        }
    }

}
