#include <iostream>
#include <cstring>
#include <fstream>
#include <sstream>
#include <string>
#include <map>
#include <regex.h>

using namespace std;

class A {
	public:
		int x;
		void print() {
			cout << "x = " << x << endl;
		}
};
class B : A {
	public:
		void setX(int val) {
			x = val;
			printv2();
		}
		void printv2() {
			cout << "x = " << x << endl;
		}
};
int main()
{
	B obj;
	obj.setX(10);
}

