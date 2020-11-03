using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//[RequireComponent(typeof(Rigidbody))]
public class MovementZWorld : MonoBehaviour
{
    [SerializeField] private EditorPath PathFollow;

    [SerializeField] private int CurrentWayPointID=0;
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

    private void Start()
    {
       // PathFollow = GameObject.Find(pathName).GetComponent<EditorPath>();
        
        last_position = transform.position;
    }
    private void Update()
    {
        float _distance = Vector3.Distance(PathFollow1.path_objs[CurrentWayPointID1].position,transform.position);
        transform.position = Vector3.MoveTowards(transform.position, PathFollow1.path_objs[CurrentWayPointID1].position,Time.deltaTime * Speed);

        var rotation = Quaternion.LookRotation(PathFollow1.path_objs[CurrentWayPointID1].position - transform.position);
        transform.rotation = Quaternion.Slerp(transform.rotation, rotation, Time.deltaTime * rotationSpeed);

        if (_distance <= reachDistance)
        {
            CurrentWayPointID1++;
        }
        if(CurrentWayPointID1>= PathFollow1.path_objs.Count)
        {
            CurrentWayPointID1 = 0;
        }

    }


}
