#include <iostream>
#include <cstring>
#include <boost/algorithm/string.hpp>
// #include <boost/spirit>
#include <regex.h>

using namespace std;
using namespace boost;

int match(const char *string, char *pattern);

int main(int argc, char *argv[])
{
   char cstr1[]="HSPICE = 10";
   char delim[]="=";
   char *token;

   //cout << "cstr1 before being tokenized: " << cstr1[1] << endl << endl;

   
   //In the first call to strtok, the first argument is the line to be tokenized
   //split(cstr1, delim, token);
   //token=strtok(cstr1, delim);
   //cout << token << endl;

   //In subsequent calls to strtok, the first argument is NULL
   //while((token=strtok(NULL, delim))!=NULL)
   //{
   //      cout << token << endl;
   //}



   //int x = match("Key = 1245", "^Key[ \t]*=[ \t]*[1-9]+$");
   //cout << "x=" << x << endl;
 
   int status; 
   regex_t re; 

   //const char *string = "Key = 1235";
   const char *string = "Key = 1245 ";
   //char *pattern = "^Key[ \t]*=[ \t]*([1-9]+)$";
   //char *pattern = "^([^ \t]+)[ \t]*=[ \t]*([1-9]+)$";
   char *pattern = "^([^ \t]+)[ \t]*=[ \t]*([ \t]+)[ \t]*$";
   //char *pattern = "^([^ \t]+)[ \t]*=[ \t]*([^ \t]+)[ \t]*$";

   size_t     nmatch = 3;
   regmatch_t pmatch[3];
   
   if(regcomp(&re, pattern, REG_EXTENDED|REG_NEWLINE) != 0) { 
     cout << "Not Matched" << endl; 
   } 
   //status = regexec(&re, string, nmatch, pmatch, 0); 
   status = regexec(&re, string, 0, NULL, 0); 
   regfree(&re); 

   cout << "line=" << string << endl; 
   cout << "status=" << status << endl; 
   cout << " match = {" << &string[pmatch[1].rm_so] << "}" << endl;
}


  
int match(const char *string, char *pattern) { 
  int status; 
  regex_t re; 

  if(regcomp(&re, pattern, REG_EXTENDED|REG_NOSUB|REG_NEWLINE) != 0) { 
    return 1; 
  } 
  status = regexec(&re, string, (size_t)0, NULL, 0); 
  regfree(&re); 
  return status;
} 
  
