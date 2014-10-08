#include <regex.h>
#include <iostream>
#include <fstream>
#include <string>
#include <cstring>
#include <sstream>
#include <map>
#include <math.h>

using namespace std;

void createMetalCapMap (map<pair<int,string>, float*>&);
struct RC {
	float res;
	float cap;
};

/////////////////////////////////////////////////////////////////////////////
//
// This function calculates the interconnect resistance(Ohm/micron) and 
// capacitance(fF/micron) for the PTM models. Structure 2 model of the 
// interconnect is reproduced in this function. techNum is one of 
// (180,135,130,90,65,45,32,22), intcLevel is one of (g or G, l or L, i or I) for global,
// local and intermediate levels of interconnect respecitvely. metal is 
// "cu" or "al". Optional argument in the form of a vector [w s t h k] can be used to specify custom width(w), 
// spacing(s), thickness(t), height(h) or dielectric constant(k) to override 
// the defaults. If not all parameters are to be overridden, it should be zero. 
 
// Examples:
// 1. InterconnectCap(90,'l','cu')
// gives the R and C  values for the local copper interconnect in 90 nm, 
// with the default values of the dimensions.
// 2. InterconnectCap(135,'G','al',[0 0 0.25 0.3 0])
// gives the R and C values for the global aluminium interconnect in 135 nm. 
// with the default values of w,s and k and with t = 0.25 micron and h = 0.3 micron
//
//////////////////////////////////////////////////////////////////////////////
RC InterconnectRC(int techNum, string intcLevel, string metal, float* inputParam) 
{
	// Creat map
	map<pair<int, string>, float*> metalCap;
	createMetalCapMap(metalCap);
	
	// Get param of for input tech/intLevel/metal
	float* param = metalCap[make_pair(techNum, intcLevel)];

	// Overwrite tech parameters
	for(int i=0; i < 5; ++i) {
		if(inputParam[i]) {
			param[i] = inputParam[i];
		}
	}
	float w, s, t, h, k;
	w = param[0];
	s = param[1];
	t = param[2];
	h = param[3];
	k = param[4];

	cout << "\
	w =" << param[0] << " \
	s =" << param[1] << " \
	t =" << param[2] << " \
	h =" << param[3] << " \
	k =" << param[4] << endl;; 

	
	float rho; 
	if (metal == "cu") {
		rho = 2.2e-2;
	} else {
		rho = 3.3e-2;
	}
	// Calculate R and C using the equations in the PTM website for the specified parameters
	RC interconnectRC;
	float R_intc = rho/(w*t);
	const float e0 = 8.85e-18;
	float C_g = k*e0*((w/h) + 2.04*(pow((s/(s + 0.54*h)),1.77))*(pow(t/(t + 4.53*h),0.07)));
	float C_c = k*e0*((1.14*(t/s)*exp(-4*s/(s + 8.01*h))) + 2.37*(pow(w/(w + 0.31*s),0.28))*(pow(h/(h + 8.96*s),0.76))*(exp(-2*s/(s + 6*h))));
	float C_intc = 2*(C_g + C_c);
	interconnectRC.res = R_intc;
	interconnectRC.cap = C_intc;
	return interconnectRC;
}

void createMetalCapMap (map<pair<int,string>, float*>& metalCap)
{
	// Default values of w,s,t,h and k for various 
	// techs and levels from PTM website

	// Define Parameters
	float param180l[] =   {0.28,	0.28,  	0.45,  	0.65,  	3.5}; 
	float param180i[] =   {0.35,	0.35, 	0.65, 	0.65, 	3.5}; 
	float param180g[] =   {0.80,	0.80, 	1.25, 	0.65, 	3.5};

	float param135l[] = {0.20,	0.20,  	0.45,  	0.45,  	3.2};  
	float param135i[] = {0.28,	0.28, 	0.45, 	0.45, 	3.2}; 
	float param135g[] = {0.60,	0.60, 	1.20, 	0.45, 	3.2};

	float param90l[] = {0.15,	0.15,  	0.30,  	0.30,  	2.8}; 
	float param90i[] = {0.20,	0.20, 	0.45, 	0.30, 	2.8}; 
	float param90g[] = {0.50,	0.50, 	1.20, 	0.30, 	2.8};	

	float param65l[] = {0.10,	0.10,  	0.20,  	0.20,  	2.2}; 
 	float param65i[] = {0.14,	0.14, 	0.35, 	0.20, 	2.2}; 
	float param65g[] = {0.45,	0.45, 	1.20, 	0.20, 	2.2};

	float param45l[] = {0.07, 0.07, 0.18, 0.18, 2.2}; 
	float param45i[] = {0.1,  0.1,  0.31, 0.18, 2.2}; 
       	float param45g[] = {0.32, 0.32, 1.08, 0.18, 2.2};

	float param32l[] = {0.05, 0.05, 0.16, 0.16, 2.2};
	float param32i[] = {0.07, 0.07, 0.28, 0.16, 2.2};
	float param32g[] = {0.22, 0.22, 1.0, 0.16, 2.2};

	float param22l[] = {0.04, 0.04, 0.15, 0.15, 2.2};
	float param22i[] = {0.05, 0.05, 0.25, 0.15, 2.2};
	float param22g[] = {0.15, 0.15, 0.9, 0.9, 2.2};

	// Add Parameters to the map
	metalCap[make_pair(180,"l")] = param180l;
	metalCap[make_pair(180,"i")] = param180i;
	metalCap[make_pair(180,"g")] = param180g;

	metalCap[make_pair(135,"l")] = param135l;
	metalCap[make_pair(130,"l")] = param135l;
	metalCap[make_pair(135,"i")] = param135i;
	metalCap[make_pair(130,"i")] = param135i;
	metalCap[make_pair(135,"g")] = param135g;
	metalCap[make_pair(130,"g")] = param135g;

	metalCap[make_pair(90,"l")] = param90l;
	metalCap[make_pair(90,"i")] = param90i;
	metalCap[make_pair(90,"g")] = param90g;

	metalCap[make_pair(65,"l")] = param65l;
	metalCap[make_pair(65,"i")] = param65i;
	metalCap[make_pair(65,"g")] = param65g;

	metalCap[make_pair(45,"l")] = param45l;
	metalCap[make_pair(45,"i")] = param45i;
	metalCap[make_pair(45,"g")] = param45g;

	metalCap[make_pair(32,"l")] = param32l;
	metalCap[make_pair(28,"l")] = param32l;
	metalCap[make_pair(32,"i")] = param32i;
	metalCap[make_pair(28,"i")] = param32i;
	metalCap[make_pair(32,"g")] = param32g;
	metalCap[make_pair(28,"g")] = param32g;

	metalCap[make_pair(22,"l")] = param22l;
	metalCap[make_pair(22,"i")] = param22i;
	metalCap[make_pair(22,"g")] = param22g;
}

// int main() {
// 	RC temp1, temp2, temp3;
// 	float param[] = {0, 0, 0, 0};
// 	temp1 = InterconnectRC(180, "l", "cu", param);
// 	temp2 = InterconnectRC(180, "i", "cu", param);
// 	temp3 = InterconnectRC(180, "g", "cu", param);
// 	cout << temp1.res << " " << temp1.cap << endl;
// 	cout << temp2.res << " " << temp2.cap << endl;
// 	cout << temp3.res << " " << temp3.cap << endl;
// }
// 





