using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

public class PathTrigger : MonoBehaviour
{
    public string _namePath;
    MovementZWorld _mvmZWorld;


    private void Awake()
    {
        _mvmZWorld=gameObject.GetComponentInParent<MovementZWorld>();
        //GameObject.Find("").GetComponent<EditorPath>()
    }
    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Path")
        {

             
            _namePath = other.name;
           

            if (_namePath != null)
            {
                _mvmZWorld.CurrentWayPointID1 = 0;
                _mvmZWorld.PathFollow1 = GameObject.Find(_namePath).GetComponent<EditorPath>();
                _mvmZWorld.PathName = _namePath;


            }
          //  _mvmZWorld.pathName = _namePath;

        }
    }

   
}
