using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityStandardAssets.CrossPlatformInput;
public class WheelsRotate : MonoBehaviour {

	public float rotateSpeed = 10.0f;
	
	void FixedUpdate(){
		
		float move = CrossPlatformInputManager.GetAxis("Vertical");

		if(move > 0 || move < 0){
			transform.Rotate(Vector3.left * -rotateSpeed);
		}
	}
}
