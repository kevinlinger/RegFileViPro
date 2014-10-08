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
// 	char* str = "ibm45";
// 	int techNode;
// 	char* substr;
// 	sscanf(str,"%[^0-9]%d",substr,&techNode);
// 	cout << "substr = " << substr << " techNode = " << techNode << endl;
	
	char strx[20] = "1 2   755  78";
	int i1,i2,i3;
	i1=10;
	i2=10;
	i3=10;
	//sscanf(strx,"%*d %d %d %d",&i1,&i2,&i3);
	string ch;
	stringstream sst;
	int x1, x2;
	sst << "10 10 6 7 8 9" << endl;
	sst >> ch >> ch >> x1 >> x2;
	//cout << "i1= " << i1 << " i2= " << i2 << " i3= " << i3 << "\n";
	cout << "x1 = " << x1 << "x2 = " << x2 << endl;	

	int xx;
	cout << "xx = " << xx << endl;
	
}

