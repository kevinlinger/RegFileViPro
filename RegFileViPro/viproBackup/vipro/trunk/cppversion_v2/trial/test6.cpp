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
	ifstream bc("../../configuration/bitcellSizes.m");
	stringstream bc_sst;
			bc_sst << "\
#############################\n\
# Bitcell device dimensions\n\
#############################\n";
			if(bc.is_open()) {
				while(!bc.eof()) {
					string line;
					getline(bc,line);
					cout << line << "  EOL" << endl;

					// skip empty line
					if(line.empty()) {
						continue;
					}
					regex_t re; 
					size_t     nmatch = 3;
					regmatch_t pmatch[3];

					char *pattern = "^[ \t]*([^ \t]+)[ \t]*=[ \t]*([^ \t]+)[ \t]*";
					// Don't check!
					regcomp(&re, pattern, REG_EXTENDED); 
					int status = regexec(&re, line.c_str(), nmatch, pmatch, 0); 
					regfree(&re); 

		 			if(status!=0) {
						cerr << "Error: Can't Parse bitcell file.\n" << endl; 
						exit(0);
					}
					string token = line.substr(pmatch[1].rm_so, pmatch[1].rm_eo - pmatch[1].rm_so);
					string value = line.substr(pmatch[2].rm_so, pmatch[2].rm_eo - pmatch[2].rm_so);
					bc_sst << token << "\t" << value << endl;
				}
			} else {
				cerr << "Error: Can't open bitcellSizes.m file.\n";
				exit(1);
			}
	
}
