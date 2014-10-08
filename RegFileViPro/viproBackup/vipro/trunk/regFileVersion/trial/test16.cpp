#include <iostream>
#include <cstring>
#include <fstream>
#include <sstream>
#include <string>
#include <map>
#include <regex.h>

#include <vector>

using namespace std;

int main()
{
	vector<float> hList;
	hList.push_back(1021);
	hList.push_back(1020);
	
	float x = 2040 * 0.5;
	vector<float>::iterator it = find(hList.begin(), hList.end(), x);
	if(it == hList.end())
		cout << "Cant Find it" << endl;
	else 
		cout << "Value Found " << endl;
}


