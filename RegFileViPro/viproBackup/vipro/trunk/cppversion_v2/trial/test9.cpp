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
	char* ch1,ch2;
	int it;
	char* str = "rowDecoder = 1";
	int x = sscanf(str,"rowDecoder[ \t]+= %d",&it);
	cout << x << endl;
}

