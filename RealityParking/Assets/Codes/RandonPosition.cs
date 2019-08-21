using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RandonPosition : MonoBehaviour {

	public Vector3[] positions;
	public Vector3[] rotations;

	// Use this for initialization
	void Start () {
		int randomNumberPosition = Random.Range(0, positions.Length);
		transform.position = positions[randomNumberPosition];	

		int randomNumberRotation = Random.Range(0, rotations.Length);
		transform.Rotate(rotations[randomNumberRotation].x, rotations[randomNumberRotation].y, rotations[randomNumberRotation].z);
	}
}
