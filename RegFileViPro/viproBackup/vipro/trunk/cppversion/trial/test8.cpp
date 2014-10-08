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
	string x = ("Hello World");
	cout << x.c_str() << " " << x << endl;

	//char x1[] = "Hey Whats up";
	char* x2 = strcat((char*)x.c_str(),"YES");
	cout << x.c_str() << " " << x2 << endl;
}
