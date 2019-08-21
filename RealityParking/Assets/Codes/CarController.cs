using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityStandardAssets.CrossPlatformInput;

public class CarController : MonoBehaviour {

	public float speed = 10.0f; 			//Car speed movement
	public float maxSpeed = 50.0f;
	public float rotationSpeed = 100.0f;	//Left-Right car speed movement
	public int[] gearRatio;
	AudioSource audioSource;
	
	// Use this for initialization
	void Start () {
		audioSource = GetComponent<AudioSource>();
	}
	void EngineSound(float currentSpeed)
	{
		float gearMin = 0.0f;
		float gearMax = 0.0f;

		float enginePicth;
		int position = 0;

		for(int i = 0; i < gearRatio.Length; i++){
			if(gearRatio[i] > currentSpeed){
				position = 0;
				break;
			}
			position = i;
		}

		if(position == 0){
			gearMin = 0.0f;
			gearMax = gearRatio[position];
		}
		else{
			gearMin = gearRatio[position-1];
			gearMax = gearRatio[position];
		}
		
		enginePicth = (currentSpeed - gearMin) / (gearMax - gearMin) + 0.1f;
		audioSource.pitch = enginePicth;
	}	

	// Update is called once per frame
	void Update () {
		//Get Joystick Control
		//float translation = CrossPlatformInputManager.GetAxis("Vertical") * speed;
		//float rotation = CrossPlatformInputManager.GetAxis("Horizontal") * rotationSpeed;

		//translation += Time.deltaTime;
		//rotation += Time.deltaTime;

		float translation = CrossPlatformInputManager.GetAxis("Vertical");
		float rotation = CrossPlatformInputManager.GetAxis("Horizontal"); 

		//Debug.Log("x: " + transform.position.x + " y: " + transform.position.y + " z: " + transform.position.z);
		
		if(translation != 0 || rotation != 0){
			translation = translation*speed + Time.deltaTime;
			transform.Translate(0, 0, translation);

			if(speed < maxSpeed) { speed++; }

			rotation = rotation*rotationSpeed + Time.deltaTime;
			transform.Rotate(0, rotation, 0);
		}
		else{
			speed = 10;
		}

		/*if(carCollider.bounds.Contains(parkingLotCollider.bounds.center)){
			Debug.Log("Contem!");
			Debug.Log("Size bb car: " + carCollider.bounds.size);
			Debug.Log("Size bb parking lot: " + parkingLotCollider.bounds.size);
		}*/

		/*if(carCollider.bounds.Contains(parkingLotCollider.bounds.center)){
			Debug.Log("Contem!");
		}*/

		/*if(carCollider.bounds.Intersects(parkingLotCollider.bounds)){
			Debug.Log("Intersecao!");
		}*/

		//Debug.Log("Car - Min: " + carCollider.bounds.min + " Max: " + carCollider.bounds.max + " Center: " + carCollider.bounds.center);
		//Debug.Log("PL - Min: " + parkingLotCollider.bounds.min + " Max: " + parkingLotCollider.bounds.max + " Center: " + parkingLotCollider.bounds.center);

		EngineSound(speed);
	}
}
