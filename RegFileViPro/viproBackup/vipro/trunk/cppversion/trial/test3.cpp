#include <iostream>
#include <cstring>
#include <fstream>
#include <sstream>
#include <string>

using namespace std;

void consumeComments(string& str) {
	    // find begin of comment till new line
	    size_t index1 = str.find('#');
	    if(index1 != string::npos) {
		    size_t index2 = str.find('\n',index1);
		    //cout << str << '\n' << endl;
		    cout << index1 << " " << index2 << endl;
		    str.erase(index1,index2-index1+1);
		    //cout << str << '\n' << endl;
		    consumeComments(str);
	    }
}
void consumeNewLines(string& str) {
	// find new line
	size_t index = str.find('\n');
	if(index != string::npos) {
		const char* ch = " ";
		str.replace(index,1,ch);
		consumeNewLines(str);
	}
}

int main()
{
	ifstream han("input.txt");
	stringstream sst;
	sst << han.rdbuf();
	string st = sst.str();
	consumeComments(st);
	consumeNewLines(st);
	cout << st << endl;
	return 0;

}
