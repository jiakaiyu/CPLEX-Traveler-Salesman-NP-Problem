/*********************************************
 * OPL 12.9.0.0 Model
 * Author: JK
 * Creation Date: Apr 6, 2020 at 3:10:17 PM
 *********************************************/

 //problems size
 int n=...;
 range cities=1..n;
 
 //generate random data
 
 tuple location {
 	float x;
 	float y; 
 }
 
 tuple edge {
 	int i;
 	int j; 
 }
 
 setof(edge) edges = {<i,j> | i,j in cities : i!=j};
 float c[edges];
 location cityLocation[cities];
 
 execute {
 	function getDistance(city1,city2){
 		return Opl.sqrt(Opl.pow(city1.x-city2.x, 2)+Opl.pow(city1.y-city2.y, 2)); 	
 	} 
 
 	for (var i in cities) {
 		cityLocation[i].x=Opl.rand(100); 
 		cityLocation[i].y=Opl.rand(100);	
 	} 
 	
 	for (var e in edges) {
 		c[e] = getDistance(cityLocation[e.i], cityLocation[e.j]);
 	}
 }
 
 // decision variable
 dvar boolean x[edges];
 dvar float+ u[2..n];
 
 //expression
 dexpr float TotalDistance = sum(e in edges) c[e]*x[e];
 
 minimize TotalDistance;
 
 subject to {
 	forall (j in cities)
 	  flow_in:
 	  sum(i in cities: i!=j) x[<i,j>] == 1;
 	  
 	forall (i in cities)
 	  flow_out:
 	  sum(j in cities: j!=i) x[<i,j>] ==1;
 	
 	forall (i in cities: i>1, j in cities: j>1 && j!=i)
 	   subtour:
 	   u[i]-u[j]+(n-1)*x[<i,j>]<=n-2;
 }