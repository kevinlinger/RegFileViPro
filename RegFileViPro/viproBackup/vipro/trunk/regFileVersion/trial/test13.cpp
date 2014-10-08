#include <iostream>
#include <cstring>
#include <fstream>
#include <sstream>
#include <string>
#include <map>
#include <regex.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>


using namespace std;

int main()
{
	struct stat st;
	stat("./tmp1",&st);
	if(st.st_mode && S_IFDIR)
        printf(" /tmp1 is present\n");
}

