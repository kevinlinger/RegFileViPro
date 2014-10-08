#include <iostream>
#include <cstring>
#include <fstream>
#include <sstream>
#include <string>
#include <map>
#include <regex.h>

using namespace std;

int main()
{
	char tmp[20];
	string str("SWEEP 1 d w");
	int x = sscanf(str.c_str(), "SWEEP%s", tmp);
	int y = sscanf(str.c_str(), "wwww%s", tmp);
	cout << "x=" << x << "y=" << y << endl;
}


