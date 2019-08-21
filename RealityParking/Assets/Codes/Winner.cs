using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Winner : MonoBehaviour {

	Collider carCollider; 
	public GameObject[] parkingLots;
	public Collider[] parkingLotsCollider;
	AudioSource[] audios;
	bool play = true;

	// Use this for initialization
	void Start () {

		audios = GetComponents<AudioSource>();
		carCollider = GetComponent<Collider>();
		
		parkingLots[0] = GameObject.FindGameObjectWithTag("ParkingLot1");
		parkingLots[1] = GameObject.FindGameObjectWithTag("ParkingLot2");
		parkingLots[2] = GameObject.FindGameObjectWithTag("ParkingLot3");
		parkingLots[3] = GameObject.FindGameObjectWithTag("ParkingLot4");
		parkingLots[4] = GameObject.FindGameObjectWithTag("ParkingLot5");
		parkingLots[5] = GameObject.FindGameObjectWithTag("ParkingLot6");
		parkingLots[6] = GameObject.FindGameObjectWithTag("ParkingLot7");
		parkingLots[7] = GameObject.FindGameObjectWithTag("ParkingLot8");
		parkingLots[8] = GameObject.FindGameObjectWithTag("ParkingLot9");

		parkingLotsCollider[0] = parkingLots[0].GetComponent<Collider>();
		parkingLotsCollider[1] = parkingLots[1].GetComponent<Collider>();
		parkingLotsCollider[2] = parkingLots[2].GetComponent<Collider>();
		parkingLotsCollider[3] = parkingLots[3].GetComponent<Collider>();
		parkingLotsCollider[4] = parkingLots[4].GetComponent<Collider>();
		parkingLotsCollider[5] = parkingLots[5].GetComponent<Collider>();
		parkingLotsCollider[6] = parkingLots[6].GetComponent<Collider>();
		parkingLotsCollider[7] = parkingLots[7].GetComponent<Collider>();
		parkingLotsCollider[8] = parkingLots[8].GetComponent<Collider>();

		play = true;	
	}
	bool OnParkingLot(Collider carCollider, Collider parkingLotCollider)
	{
		if((carCollider.bounds.min.x > parkingLotCollider.bounds.min.x && carCollider.bounds.min.x < parkingLotCollider.bounds.max.x) &&
		   (carCollider.bounds.max.y > parkingLotCollider.bounds.min.y && carCollider.bounds.max.y < parkingLotCollider.bounds.max.y) &&
		   (carCollider.bounds.max.x > parkingLotCollider.bounds.min.x && carCollider.bounds.max.x < parkingLotCollider.bounds.max.x) &&
		   (carCollider.bounds.max.y > parkingLotCollider.bounds.min.y && carCollider.bounds.max.y < parkingLotCollider.bounds.max.y)){
		   
			   return true;
		}
		return false;
	}
	
	// Update is called once per frame
	void Update () {
		
		if(OnParkingLot(carCollider, parkingLotsCollider[0]) || OnParkingLot(carCollider, parkingLotsCollider[1]) ||
		   OnParkingLot(carCollider, parkingLotsCollider[2]) || OnParkingLot(carCollider, parkingLotsCollider[3]) ||
		   OnParkingLot(carCollider, parkingLotsCollider[4]) || OnParkingLot(carCollider, parkingLotsCollider[5]) ||
		   OnParkingLot(carCollider, parkingLotsCollider[6]) || OnParkingLot(carCollider, parkingLotsCollider[7]) ||
		   OnParkingLot(carCollider, parkingLotsCollider[8])){
			
			if(play){
				audios[0].Stop();
				audios[1].Stop();
				audios[2].PlayScheduled(2);
				play = false;
			}
			GameManager.instance.Win();
		}
	}
}
