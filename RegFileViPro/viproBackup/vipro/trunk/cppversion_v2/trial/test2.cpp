#include <iostream>
#include <cstring>
#include <fstream>
#include <sstream>

using namespace std;

int main()
{
	ifstream han("input.txt");
	stringstream sst;
	sst << han.rdbuf();
	string st = sst.str();
	cout << st << endl;
}
