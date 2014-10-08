#include <iostream>
#include <cstring>
#include <fstream>
#include <sstream>
#include <string>
#include <map>

using namespace std;

void AddTechParam(map<pair<int,string>,float*>& mp, pair<int,string>& pr, float param[]) 
{
	mp[pr] = param;
}

int main()
{
	//map<pair<int, string>, float*> metalCap;
        //float farray[1] = {51}; 
	//float xoxo = 10.5;
	//pair<int,string> ted(10,"Hi");
	//float x[2]={1,2};
	//metalCap[ted] = farray;
	//metalCap[make_pair(10,"Hi")] = farray;
		
	//float* fptr = metalCap[ted];
	//cout << "float array = " << fptr[0] << endl;
	

	// Creat map
	map<pair<int, string>, float*> metalCap;

	// Add 180nm tech parameters
	AddTechParam(metalCap, make_pair(180,"l"), {0.28	0.28  	0.45  	0.65  	3.5});


	//map<int, int> xxx;
	//xxx[10]=21;

	float[][] fptr = {{1,2,3}{}}
}
