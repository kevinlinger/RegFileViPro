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
	string str("SWEEP X d w");
	char cstr[] = "Hello World Hello World Hello World";
	sscanf(str.c_str(), "SWEEP%*[ \t]%(.*)", cstr);
	cout << "Hello->" << cstr << endl;
}


