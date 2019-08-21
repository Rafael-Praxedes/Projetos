using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Circle
{
	private double x;
	private double z;
	private double radius;

	public Circle(double x, double z, double radius){
		this.x = x;
		this.z = z;
		this.radius = radius;
	}
	public double X
 	{
  		get{ return this.x; }
 	}
	public double Z
 	{
  		get{ return this.z; }
 	}
	public double Radius
 	{
  		get{ return this.radius; }
 	}
	public bool ColisionDetect(Circle otherCircle){
		return (this.x + this.radius) < (this.radius + otherCircle.Radius) || (this.z + this.radius) < (this.radius + otherCircle.Radius);
	}
}

public class CircleBoundry : MonoBehaviour {

	public GameObject[] cars;
	public Circle[] circles = new Circle[6];
	public const double widhtParkingLot = 124.0;
	public Vector3 initPositionsCar3;
	public Vector3 initRotationCar3;

	// Use this for initialization
	void Start () {
		cars[0] = GameObject.FindGameObjectWithTag("Car_1");
		cars[1] = GameObject.FindGameObjectWithTag("Car_2");
		cars[2] = GameObject.FindGameObjectWithTag("Car_3");
		cars[3] = GameObject.FindGameObjectWithTag("Car_4");
		cars[4] = GameObject.FindGameObjectWithTag("Car_5");
		cars[5] = GameObject.FindGameObjectWithTag("Car_6");

		initPositionsCar3 = new Vector3(cars[2].transform.position.x, cars[2].transform.position.y, cars[2].transform.position.z);
		initRotationCar3 = new Vector3(cars[2].transform.eulerAngles.x, cars[2].transform.eulerAngles.y, cars[2].transform.eulerAngles.z);

		circles[0] = new Circle((double) cars[0].transform.position.x, (double) cars[0].transform.position.z, widhtParkingLot*0.5);
		circles[1] = new Circle((double) cars[1].transform.position.x, (double) cars[1].transform.position.z, widhtParkingLot*0.5);
		circles[3] = new Circle((double) cars[3].transform.position.x, (double) cars[3].transform.position.z, widhtParkingLot*0.5);
		circles[4] = new Circle((double) cars[4].transform.position.x, (double) cars[4].transform.position.z, widhtParkingLot*0.5);
		circles[5] = new Circle((double) cars[5].transform.position.x, (double) cars[5].transform.position.z, widhtParkingLot*0.5);
	}
	
	// Update is called once per frame
	void Update () {

		circles[2] = new Circle((double) cars[2].transform.position.x, (double) cars[2].transform.position.z, widhtParkingLot*0.5);

		Debug.Log("x: " + circles[2].X);
		Debug.Log("z: " + circles[2].Z);
		Debug.Log("Radius: " + circles[2].Radius);

		if(circles[2].ColisionDetect(circles[0]) || circles[2].ColisionDetect(circles[1]) || circles[2].ColisionDetect(circles[3]) ||
		   circles[2].ColisionDetect(circles[4]) || circles[2].ColisionDetect(circles[5])){
			   	Debug.Log("Colision!");
				cars[2].transform.position = initPositionsCar3;
				cars[2].transform.eulerAngles = initRotationCar3;
		}
	}
}
