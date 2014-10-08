#include <iostream>
#include <cstring>
#include <fstream>
#include <sstream>
#include <string>
#include <map>
#include <regex.h>

using namespace std;

void xoxo(string st)
{
	stringstream sst;
	sst << st;
	cout << sst.str() << endl;
}
int main()
{
	stringstream sst;
	sst << "Hello" << endl;
	//xoxo("POPO");
	stringstream sst2 = sst.str();
}
