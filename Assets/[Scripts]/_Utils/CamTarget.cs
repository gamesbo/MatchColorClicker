using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CamTarget : MonoBehaviour
{
    void Start()
    {
        
    }
    void Update()
    {
        transform.position = new Vector3(0, 0, PlayerController.instance.transform.position.z);
    }
}
