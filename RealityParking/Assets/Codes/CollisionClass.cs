using System.Collections;
using System.Collections.Generic;
using UnityEngine;
public class CollisionClass : MonoBehaviour {

	AudioSource[] audioCollision;
	GameObject[] wheels;
	float idForce;

	// Use this for initialization
	void Start () {
		audioCollision = GetComponents<AudioSource>();
		wheels = GameObject.FindGameObjectsWithTag("Car3_Wheels");
	}
	// Update is called once per frame
	void Update () {
		
	}
	IEnumerator OnCollisionEnter(Collision col){

		if(col.gameObject.tag == "Car_1" || col.gameObject.tag == "Car_2" || col.gameObject.tag == "Car_4" || 
		   col.gameObject.tag == "Car_5" || col.gameObject.tag == "Car_6"){

			audioCollision[0].Stop();
			audioCollision[1].Play();

			Destroy(GameObject.FindGameObjectWithTag("Car3_Body"));
			Destroy(GameObject.FindGameObjectWithTag("Car3_Shadow"));
			yield return new WaitForSeconds(0.5f);
			Destroy(GameObject.FindGameObjectWithTag("Car3_Wheels"));

			yield return new WaitForSeconds(1);

			Application.LoadLevel(Application.loadedLevel);
		}
	}
}
