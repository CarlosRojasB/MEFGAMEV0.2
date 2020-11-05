
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//[RequireComponent(typeof(Rigidbody))]
public class MovementZWorld : MonoBehaviour
{
    [Header("Original movement and rotation")]

    [SerializeField] private EditorPath PathFollow;

    [SerializeField] private int 
        CurrentWayPointID=0;
    [SerializeField] private float speed;

    private float reachDistance = 1.0f;
    [SerializeField] float rotationSpeed=5.0f;
    [SerializeField]private string pathName;

    Vector3 last_position;
    Vector3 current_position;
   
    public string PathName { get => pathName; set => pathName = value; }
    public EditorPath PathFollow1 { get => PathFollow; set => PathFollow = value; }
    public int CurrentWayPointID1 { get => CurrentWayPointID; set => CurrentWayPointID = value; }
    public float Speed { get => speed; set => speed = value; }

    [Header("TestOtherRotation")]

    
    [SerializeField]
    float rotationSpeedSoft;

    Quaternion rotation;
    Quaternion newRot;

    private void Start()
    {
       // PathFollow = GameObject.Find(pathName).GetComponent<EditorPath>();
      
        last_position = transform.position;

        //Modificacion rotacion suave
        //rotation = Quaternion.Euler(new Vector3(0, PathFollow1.path_objs[CurrentWayPointID1].eulerAngles.y, 0f));


    }
    private void Update()
    {
        float _distance = Vector3.Distance(PathFollow1.path_objs[CurrentWayPointID1].position,transform.position);

        transform.position = Vector3.MoveTowards(transform.position, PathFollow1.path_objs[CurrentWayPointID1].position,Time.deltaTime * Speed);


        //Use esta reotaticon con las variables originales

        var rotation = Quaternion.LookRotation(PathFollow1.path_objs[CurrentWayPointID1].position - transform.position);
        transform.rotation = Quaternion.Slerp(transform.rotation, rotation, Time.deltaTime * rotationSpeed);

        //Modificacion rotacion suave
        /* newRot = Quaternion.Euler(new Vector3(0f, -PathFollow1.path_objs[CurrentWayPointID1].eulerAngles.y-transform.rotation.y, 0f));
         rotation = Quaternion.Lerp(rotation, newRot, rotationSpeedSoft * Time.deltaTime);
         transform.rotation = rotation;
 */



        if (_distance <= reachDistance)
        {
            if (CurrentWayPointID1 < PathFollow1.path_objs.Count - 1)
            {
                // CurrentWayPointID1 = 0;
                CurrentWayPointID1++;
            }
        }
       

    }


}
