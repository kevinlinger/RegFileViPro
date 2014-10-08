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
	char temp[25] = "wdef 70 ldef 50 zdef 70";
	int len,wid;
	//sscanf(temp, "%sldef %d",&len);
	sscanf(temp, "wdef %d",&wid);

	cout << "<ldef>	" << len << "  <wdef> " <<  wid << endl; 
}


