using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rectangle {
 	private double x;
 	private double y;
 	private double width;
 	private double height;
	private double angle;
	
	public Rectangle(double x, double y, double width, double height, double angle)
 	{
  		this.x = x;
  		this.y = y;
  		this.width = width;
  		this.height = height;
		this.angle = angle; 
 	}
	public double Left
 	{
  		get{ return this.x; }
 	}
 	public double Right
 	{
  		get{ return this.x + Mathf.Abs((float) ((Mathf.Cos((float) (angle*Mathf.PI/180.0f))) * this.width)); }
 	}
 	public double Top
 	{
  		get { return this.y + Mathf.Abs((float) ((Mathf.Sin((float) (90.0f - angle*Mathf.PI/180.0f))) * this.height)); }
 	}
 	public double Bottom
 	{
  		get{ return this.y; }
 	}
	public double Angle
	{
		get{ return this.angle; }
	} 

	// AABB collision Detection code
 	public bool Overlaps(Rectangle otherRectangle)
 	{
  		bool colision = (this.Left < otherRectangle.Right && 
   				this.Right > otherRectangle.Left && 
   				this.Bottom < otherRectangle.Top && 
   				this.Top > otherRectangle.Bottom);

		Debug.Log("Colision: " + colision);

		if(colision == true){
			Debug.Log("Left: " + this.Left);
			Debug.Log("Right: " + this.Right);
			Debug.Log("Top: " + this.Top);
			Debug.Log("Bottom: " + this.Bottom);
			Debug.Log("Angle: " + this.Angle); 	
		}
		return colision;
 	}
}

public class BoundingBox : MonoBehaviour {

	public GameObject[] cars;
	public const double widhtParkingLot = 124.0;
	public const double heightParkingLot = 80.0;
	public Rectangle[] rectangles = new Rectangle[6];
	Vector2 cordinatesRectangle2;

	public Vector2 Rotate(float angle, Vector2 cordinates)
	{
		Vector2 newCordinates;

		newCordinates.x = cordinates.x*Mathf.Cos(angle*Mathf.PI/180.0f) - cordinates.y*Mathf.Sin(angle*Mathf.PI/180.0f);
		newCordinates.y = cordinates.y*Mathf.Cos(angle*Mathf.PI/180.0f) + cordinates.x*Mathf.Sin(angle*Mathf.PI/180.0f);

		return newCordinates;
	}
	
	// Use this for initialization
	void Start () {
		cars[0] = GameObject.FindGameObjectWithTag("Car_1");
		cars[1] = GameObject.FindGameObjectWithTag("Car_2");
		cars[2] = GameObject.FindGameObjectWithTag("Car_3");
		cars[3] = GameObject.FindGameObjectWithTag("Car_4");
		cars[4] = GameObject.FindGameObjectWithTag("Car_5");
		cars[5] = GameObject.FindGameObjectWithTag("Car_6");

		Debug.Log("Angle: " + cars[0].transform.eulerAngles.y);
		Debug.Log("Angle: " + cars[1].transform.eulerAngles.y);
		Debug.Log("Angle: " + cars[2].transform.eulerAngles.y);
		Debug.Log("Angle: " + cars[3].transform.eulerAngles.y);
		Debug.Log("Angle: " + cars[4].transform.eulerAngles.y);
		Debug.Log("Angle: " + cars[5].transform.eulerAngles.y);								  
	}
	
	// Update is called once per frame
	void Update () {
		rectangles[0] = new Rectangle(cars[0].transform.position.x - widhtParkingLot*0.5, cars[0].transform.position.z - heightParkingLot*0.5, 
							          widhtParkingLot, heightParkingLot, cars[0].transform.eulerAngles.y);
		rectangles[1] = new Rectangle(cars[1].transform.position.x - widhtParkingLot*0.5, cars[1].transform.position.z - heightParkingLot*0.5, 
							          widhtParkingLot, heightParkingLot, cars[1].transform.eulerAngles.y);
		rectangles[3] = new Rectangle(cars[3].transform.position.x - widhtParkingLot*0.5, cars[3].transform.position.z - heightParkingLot*0.5, 
							          widhtParkingLot, heightParkingLot, cars[3].transform.eulerAngles.y);
		rectangles[4] = new Rectangle(cars[4].transform.position.x - widhtParkingLot*0.5, cars[4].transform.position.z - heightParkingLot*0.5, 
							          widhtParkingLot, heightParkingLot, cars[4].transform.eulerAngles.y);
		rectangles[5] = new Rectangle(cars[5].transform.position.x - widhtParkingLot*0.5, cars[5].transform.position.z - heightParkingLot*0.5, 
							          widhtParkingLot, heightParkingLot, cars[5].transform.eulerAngles.y);

		cordinatesRectangle2.x = (float) (cars[2].transform.position.x - widhtParkingLot*0.5); 
		cordinatesRectangle2.y = (float) (cars[2].transform.position.z - heightParkingLot*0.5);   //Y do vetor equivale à coordenada Z do carro

		cordinatesRectangle2 = Rotate(cars[2].transform.eulerAngles.y, cordinatesRectangle2);

		rectangles[2] = new Rectangle(cordinatesRectangle2.x, cordinatesRectangle2.y, widhtParkingLot, heightParkingLot, cars[2].transform.eulerAngles.y);

		if(rectangles[2].Overlaps(rectangles[0]) || rectangles[2].Overlaps(rectangles[1]) || rectangles[2].Overlaps(rectangles[3]) || 
		   rectangles[2].Overlaps(rectangles[4]) || rectangles[2].Overlaps(rectangles[5])){
			
			cars[2].transform.position = new Vector3(871.0f, 301.0f, -132.0f);
			cars[2].transform.rotation = new Quaternion(0.0f, 0.0f, 0.0f, 0.0f);
		}
	}
}
