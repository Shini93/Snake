#ifdef GL_ES

precision highp float;

#endif

uniform vec2 resolution;
uniform int numberFood;
uniform int pointX[50];
uniform int pointY[50];
uniform int size;
uniform float Red[50];
uniform float Green[50];
uniform float Blue[50];
uniform int Glow[50];
vec4 f = vec4(1.,1.,1.,1.); // f will be used to store the color of the current fragment
float shine = 1.0;
void main(void)

{   
	float maxres = 1.0;
	maxres = pow((resolution.x*resolution.x)+(resolution.y*resolution.y),0.5);
	vec3 color = vec3(0.,0.,0.);
	int count = 0;
	float max_d = 0;
	float d =0;
	bool yes = false;
	for(int i=0;i<numberFood-1;i++){	
		if(yes == true){
			break;
		}
		float x = pointX[i]-gl_FragCoord.x;
		float y = -(resolution.y-pointY[i])+gl_FragCoord.y;

		d = sqrt(x*x+y*y);


		max_d = max_d+1/pow(d,0.9); 
		//color.x = color.x+Red[i]/(numberFood*d/maxres);
		//color.y = color.y+Green[i]/(numberFood*d/maxres);
		//color.z = color.z+Blue[i]/(numberFood*d/maxres);
		if(d<5*size){
			int s = 2;
			float w = 0.2;
			color.x = color.x+((Red[i]+w)/(s*d*d));
			color.y = color.y+((Green[i]+w)/(s*d*d));
			color.z = color.z+((Blue[i]+w)/(s*d*d));
		}
	}
	float white = (color.x+color.y+color.z)/3;

	f = vec4(color.x, color.y, color.z,white);  // This is the code you see in the tutorial   
	gl_FragColor = f;

}