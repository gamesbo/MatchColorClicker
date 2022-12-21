using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class Tutorial : MonoBehaviour
{
    public GameObject Text1,Text2,Text3;
    public GameObject player;
    public static bool tutorialbool1,tutorialbool2,tutorialbool3;
    void Start()
    {
        tutorialbool1 = false;
        tutorialbool2 = false;
        tutorialbool3 = false;
    }

    // Update is called once per frame
    void Update()
    {
        if(tutorialbool1)
        {
            StartCoroutine(delay1());
            tutorialbool1 = false;
        }
        else if(tutorialbool2)
        {
            StartCoroutine(delay2());
            tutorialbool2 = false;

        }
        else if(tutorialbool3)
        {
            StartCoroutine(delay3());
            tutorialbool3 = false;
        }
    }
    IEnumerator delay1()
    {
        player.GetComponentInChildren<Animator>().enabled = false;
        //PlayerController.canMove = false;
        Text1.SetActive(true);
        yield return new WaitForSeconds(2);
        //PlayerController.canMove = true;
        Text1.SetActive(false);
        player.GetComponentInChildren<Animator>().enabled = true;

    }
    IEnumerator delay2()
    {
        player.GetComponentInChildren<Animator>().enabled = false;

        Text2.SetActive(true);
        //PlayerController.canMove = false;

        yield return new WaitForSeconds(2);
        //PlayerController.canMove = true;
        Text2.SetActive(false);
        player.GetComponentInChildren<Animator>().enabled = true;

    }
    IEnumerator delay3()
    {
        player.GetComponentInChildren<Animator>().enabled = false;

        Text3.SetActive(true);
        //PlayerController.canMove = false;
        yield return new WaitForSeconds(2);
        //PlayerController.canMove = true;
        Text3.SetActive(false);
        player.GetComponentInChildren<Animator>().enabled = true;

    }
}
