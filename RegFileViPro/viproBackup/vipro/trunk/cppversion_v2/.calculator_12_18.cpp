#include <regex.h>
#include <iostream>
#include <fstream>
#include <string>
#include <cstring>
#include <sstream>
#include <stdlib.h> 

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#include <vector>
#include <map>

#include "metalCap.cpp"
#include "periphery2.cpp"

using namespace std;

userInput::userInput() {
	//Intialize partameters
	//Can u intialize with struct
	knobCount = 0;
	PCratio = -1;
	WLratio = -1;
	calNumBanks = false;
	calNumColMux = false;
}
userInput::~userInput() {
}
void userInput::print() {
	cout <<  "technology: " << technology << "\n"
	         "memory_size: " << memory_size << "\n"
		 "n_banks: " << n_banks << "\n"
		 "n_colMux: " << n_colMux << "\n"
		 "n_rows: " << n_rows << "\n"
		 "word_size: " << word_size << "\n"
		 "SAoffset: " << SAoffset << "\n"
		 "BCheight: " << BCheight << "\n"
		 "BCwidth: " << BCwidth << "\n"
		 "energy_constraint: " << energy_constraint << "\n"
		 "delay_constraint: " << delay_constraint << "\n"
		 "WDwidth: "  << WDwidth << "\n"
		 "TASEpath: " << TASEpath << "\n"
		 "sweepToken: " <<  sweepToken << "\n"
		 "sweepBegin: " << sweepBegin << "\n" 
		 "sweepEnd: "  << sweepEnd << "\n"
		 "sweepStep: " << sweepStep << "\n"
		 "sweepOutput: " << sweepOutput << endl;
		 
		 for(int i = 0; i < knobCount; ++i) {
		 	cout << "knobMin[i] " << knobMin[i] << " knobMax[i] " << knobMax[i] << " knobName[i] " << knobName[i] << endl;
		 }
}
void userInput::setTech(string tech) {
	technology = tech;
}
void userInput::setMemSize(int memSize) {
	memory_size = memSize;
}
void userInput::setNBanks(int nBanks) {
	n_banks = nBanks;
}
void userInput::setNColMux(int nColMux) {
	n_colMux = nColMux;
}
void userInput::setNRows(int nRows) {
	n_rows = nRows;
}
void userInput::setWordSize(int wordSize) {
	word_size = wordSize;
}
void userInput::setSAOffset(float SAOffset) {
	SAoffset = SAOffset;
}
void userInput::setBCHeight(float BCHeight) {
	BCheight  = BCHeight;
}
void userInput::setBCWidth(float BCWidth) {
	BCwidth  = BCWidth;
}
void userInput::setENConstraint(float ENConst) {
	energy_constraint = ENConst;
}
void userInput::setDLConstraint(float DLConst) {
	delay_constraint = DLConst;
}
void userInput::setWDWidth(int WDWidth) {
	WDwidth = WDWidth;
}
void userInput::setTASEPath(string path) {
	TASEpath = path;
}
void userInput::setTemp(float temperature) {
	temp = temperature;
}
void userInput::setVdd(float Vdd) {
	vdd = Vdd;
}
string userInput::getTech() {
	return technology;
}
int userInput::getMemSize() {
	return memory_size;
}
int userInput::getNBanks() {
	return n_banks;
}
int userInput::getNColMux() {
	return n_colMux;
}
int userInput::getNRows() {
	return n_rows;
}
int userInput::getWordSize() {
	return word_size;
}
float userInput::getSAOffset() {
	return SAoffset;
}
float userInput::getBCHeight() {
	return BCheight;
}
float userInput::getBCWidth() {
	return  BCwidth;
}
float userInput::getENConstraint() {
	return  energy_constraint;
}
float userInput::getDLConstraint() {
	return delay_constraint;
}
float userInput::getWDWidth() {
	return  WDwidth;
}
string userInput::getTASEPath() {
	return  TASEpath;
}
float userInput::getTemp() {
	return  temp;
}
float userInput::getVdd() {
	return vdd;
}

class parser {
	private:
		string   inputFile;
		userInput input_handle;
		
	public:
		parser() {
		}
		~parser() {
		}
		string openFile(char* file) {
			ifstream handle(file);
			if (!handle.is_open()) {
				cerr << "Error: Can't open input file " << file << endl;
				exit(1);
			}
			stringstream sst;
			sst << handle.rdbuf();
			return sst.str();
			handle.close();
			//cout << st << endl;
		}
		int parseFile(char* file) {
			string str = openFile(file);
			consumeComments(str);
			consumeNewLines(str);			
			int count = 0;
			ofstream han("output.txt");
			while(!str.empty()) {
				++count;
				han << count << " - " << str.empty() << endl;
				han << str << "----\n" << endl;				
				parseToken(str);
			}
			han.close();
			return 0;
		}
		void consumeComments(string& str) {
			    // find begin of comment till new line
			    size_t index1 = str.find('%');
			    if(index1 != string::npos) {
				    size_t index2 = str.find('\n',index1);
				    //cout << str << '\n' << endl;
				    //cout << index1 << " " << index2 << endl;
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
		int parseToken(string& str) {
			string cmd = checkCmd(str);
			if (!strcmp(cmd.c_str(), "SWEEP")) {
				cout << "----SWEEP----" << endl;
				parseSWEEPToken(str);
			}
			else if (!strcmp(cmd.c_str(), "OPTIMIZE")) {
				parseOPTIMIZEToken(str);
			}
			else {
				cout << "DAMN ---> " << str.c_str() << endl;
				parseUserToken(str);			
			}
		}
		int parseUserToken(string& str) {
			regex_t re; 
			size_t     nmatch = 3;
			regmatch_t pmatch[3];

			char *pattern = "^[ \t]*([^ \t]+)[ \t]*=[ \t]*([^ \t]+)[ \t]*;[ \t]*";
			if(regcomp(&re, pattern, REG_EXTENDED) != 0) { 
			   cerr << "Error: Can't Parse Token at \n" << str << endl; 
			   exit(1);
			} 
			int status = regexec(&re, str.c_str(), nmatch, pmatch, 0); 
			regfree(&re); 

		 	if(status!=0) {
				cerr << "Error: Can't Parse Token at \n" << str << endl;
				exit(1);
			}
			string token = str.substr(pmatch[1].rm_so, pmatch[1].rm_eo - pmatch[1].rm_so);
			string value = str.substr(pmatch[2].rm_so, pmatch[2].rm_eo - pmatch[2].rm_so);
			int ivalue = atoi(value.c_str());
			float fvalue = atof(value.c_str());
			if(token == "technology") { 
				input_handle.setTech(value);
			} else if (token == "memSize") {
				input_handle.setMemSize(ivalue);
			} else if (token ==  "rows") {
				input_handle.setNRows(ivalue);
			} else if (token ==  "banks" ) {
				input_handle.setNBanks(ivalue);
			} else if (token ==  "colMux") {
				input_handle.setNColMux(ivalue);
			} else if (token ==  "wordSize") {
				input_handle.setWordSize(ivalue);
			} else if (token ==  "SAoffset") {
				input_handle.setSAOffset(fvalue);
			} else if (token ==  "height") {
				input_handle.setBCHeight(fvalue);
			} else if (token ==  "width") {
				input_handle.setBCWidth(fvalue);
			} else if (token ==  "energyConstraint" ) {
				input_handle.setENConstraint(fvalue);
			} else if (token ==  "delayConstraint") {
				input_handle.setDLConstraint(fvalue);
			} else if (token ==  "wnio") {
				input_handle.setWDWidth(ivalue);
			} else if (token ==  "tasePath" ) {
				input_handle.setTASEPath(value);
			} else if (token ==  "temp" ) {
				input_handle.setTemp(fvalue);
			} else if (token ==  "vdd" ) {
				input_handle.setVdd(fvalue);
			} else {
				cerr << "Error: Can't Parse Token at \n" << str << endl;
				exit(1);
			}
		        str.erase(pmatch[0].rm_so, pmatch[0].rm_eo - pmatch[0].rm_so);
		}

		//EX: SWEEP SAoffset 0.05 0.3 0.05 ./sweep.txt
		int parseSWEEPToken(string& str) {
			cout << str << endl;
			regex_t re; 
			size_t nmatch = 6;
			regmatch_t pmatch[6];
			// Modify to check for numbers
			char *pattern = "^[ \t]*SWEEP[ \t]*([^ \t]+)[ \t]*([^ \t]+)[ \t]*([^ \t]+)[ \t]*([^ \t]+)[ \t]*([^ \t]+)[ \t]*";
			regcomp(&re, pattern, REG_EXTENDED); 
			int status = regexec(&re, str.c_str(), nmatch, pmatch, 0); 
			regfree(&re); 
			if(status != 0) {
				cerr << "Error: Can't Parse SWEEP Token" << endl;
				exit(1);
			}
			input_handle.sweepToken = str.substr(pmatch[1].rm_so, pmatch[1].rm_eo - pmatch[1].rm_so);
			input_handle.sweepBegin = atof(str.substr(pmatch[2].rm_so, pmatch[2].rm_eo - pmatch[2].rm_so).c_str());
			input_handle.sweepEnd = atof(str.substr(pmatch[3].rm_so, pmatch[3].rm_eo - pmatch[3].rm_so).c_str());
			input_handle.sweepStep = atof(str.substr(pmatch[4].rm_so, pmatch[4].rm_eo - pmatch[4].rm_so).c_str());
			input_handle.sweepOutput = str.substr(pmatch[5].rm_so, pmatch[5].rm_eo - pmatch[5].rm_so);
			str.erase(pmatch[0].rm_so, pmatch[0].rm_eo - pmatch[0].rm_so);
			// No need for returning int
			return 0;
		}
		int parseOPTIMIZEToken(string& str) {
			cout << str << endl;
			regex_t re; 
			size_t nmatch = 3;
			regmatch_t pmatch[3];
			// Modify to check for numbers
			char *pattern = "^[ \t]*OPTIMIZE[ \t]*OBJECTIVE(.*)[ \t]*KNOBS(.*)[ \t]*";
			regcomp(&re, pattern, REG_EXTENDED); 
			int status = regexec(&re, str.c_str(), nmatch, pmatch, 0); 
			regfree(&re); 
			if(status != 0) {
				cerr << "Error: Can't Parse OPTIMIZE Token" << endl;
				exit(1);
			}
			string obj = str.substr(pmatch[1].rm_so, pmatch[1].rm_eo - pmatch[1].rm_so);
			string knobs = str.substr(pmatch[2].rm_so, pmatch[2].rm_eo - pmatch[2].rm_so);
			parseKNOBS(knobs);
			
			str.erase(pmatch[0].rm_so, pmatch[0].rm_eo - pmatch[0].rm_so);
			cout << "OBJ = " << obj << "KNOB = " << knobs << endl;
			// No need for returning int
			return 0;
		}
		int parseKNOBS(string& str) {
			while(!str.empty()) {
				cout << str << endl;
				regex_t re; 
				size_t nmatch = 6;
				regmatch_t pmatch[6];
				// Modify to check for numbers
				char *pattern = "^[ \t]*([^ \t]+)[ \t]*([0-9]+(\\.[0-9]+)?)?[ \t]*([0-9]+(\\.[0-9]+)?)?[ \t]*";
				regcomp(&re, pattern, REG_EXTENDED); 
				int status = regexec(&re, str.c_str(), nmatch, pmatch, 0); 
				regfree(&re); 
				if(status != 0) {
					cerr << "Error: Can't Parse OPTIMIZE Token" << endl;
					exit(1);
				}
				if(
				    (pmatch[2].rm_so == -1 && pmatch[4].rm_so != -1)
				||  (pmatch[4].rm_so == -1 && pmatch[2].rm_so != -1)
				  )
				{
					cerr << "Error: Can't Parse OPTIMIZE Token." << endl;
					cerr << "Format: OPTIMIZE KNOBS KONB1 [MIN MAX] KNOB2 [MIN MAX] .." << endl;
					exit(1);
				}
				// store min max
				int count = input_handle.knobCount++;
				input_handle.knobMin[count] = -1;
				input_handle.knobMax[count] = -1;
				input_handle.knobName[count] = str.substr(pmatch[1].rm_so, pmatch[1].rm_eo - pmatch[1].rm_so);
				if(pmatch[2].rm_so != -1) {
					input_handle.knobMin[count] = atof((str.substr(pmatch[2].rm_so, pmatch[2].rm_eo - pmatch[2].rm_so)).c_str());
					input_handle.knobMax[count] = atof((str.substr(pmatch[4].rm_so, pmatch[4].rm_eo - pmatch[4].rm_so)).c_str());
					cout << "knob = " << input_handle.knobName[count] << " min = " << input_handle.knobMin[count] << " max = " << input_handle.knobMax[count] << endl;
				}
				str.erase(pmatch[0].rm_so, pmatch[0].rm_eo - pmatch[0].rm_so);
			
				// Error if Min > Max 
				float min = input_handle.knobMin[count];
				float max = input_handle.knobMax[count];
				if(min > max)
  				  cerr << "Maximum value of " << input_handle.knobName[count] << " is greater than its minimum value." << endl;

				// Limit the value of bank, rows, col 
				if(input_handle.knobName[count] == "NBANKS") {
					if(max > 16 || min < 1) {
					  cerr << "Number of banks should be between 1 and 16" << endl;;
					  exit(1);
					}	
				} else if (input_handle.knobName[count] == "NCOLS") {
					if(max > 8 || min < 1) {
					  cerr << "Number of columns should be between 1 and 8" << endl;;
					  exit(1);
					}
				} else if (input_handle.knobName[count] == "NROWS") {
					if(max > 512 || min < 32) {
					  cerr << "Number of rows should be between 32 and 512" << endl;;
					  exit(1);
					}
				}
			}
			return 0;
		}
		string checkCmd(string str) {
			char st[20];
			if(sscanf(str.c_str(),"SWEEP%s", st)) {
				return "SWEEP";
			} 
			else if(sscanf(str.c_str(),"OPTIMIZE%s",st)) {
				return "OPTIMIZE";
			}
			else {
				return "";
			} 
		}
		userInput getInputHandle() {
			return input_handle;
		}
};
	
class SRAM {
	private:
		// Change objects to pointers if needed
		userInput inp; // should be changed to separate SRAM components from Tests
		senseAmp SA;
		rowDecoder RD;
		colMux CM;
		bitCell BC;
		timingBlock TB;
		writeDriver WD;
		DFF ioDFF;
		bankMux BM;
		stringstream techTemplate;
		
		double gateCap;
		double rbl; 
		double cbl; 
		double cwl;

	
	public:
		SRAM(userInput& uImp) {
			inp = uImp;
			cout << "Const2 Called" << endl;
		 gateCap = 0;
		 rbl = 0; 
		 cbl = 0; 
		 cwl = 0;
		}
		SRAM() {
		 cout << "Const Called" << endl;
		 gateCap = 0;
		 rbl = 0; 
		 cbl = 0; 
		 cwl = 0;

		}
		~SRAM() {
		}
		void setInput(userInput& uImp) {
			inp = uImp;
			SA.setInput(uImp);
			RD.setInput(uImp);
			CM.setInput(uImp);
			BC.setInput(uImp);
			TB.setInput(uImp);
			WD.setInput(uImp);
			ioDFF.setInput(uImp);
			BM.setInput(uImp);
		}
		void charGateCap() {
			// Need to check TASE flag
			// Need to check if SCOT needs pre-processor(s)
			string tasePath = inp.TASEpath;
			stringstream templ_path,new_templ_path; 
			string tech = inp.technology;
			templ_path << tasePath << "/template/RVPtpl_" << tech << ".ini";
			new_templ_path << tasePath << "/template/RVPn_" << tech << ".ini";
			
			ifstream tpl(templ_path.str().c_str());
			ofstream newtpl(new_templ_path.str().c_str());
			stringstream new_tpl;
			if (tpl.is_open()) {
				new_tpl << tpl.rdbuf();
 			   	tpl.close();
  			} else {
				cerr << "Error: Can't find input template.\n";
				exit(1);
			}
			new_tpl << "\n\
<ocn>\n\
RVP_Gate_Capacitance\n\
</ocn>\n";
		
			newtpl << new_tpl.str();
			newtpl.close();
			
			// Run TASE 
			runTASE(new_templ_path.str());
			
			// Move Results
			stringstream mvCmd; 
			mvCmd << "mv " << tasePath << "/device/BIN/" << getenv("USER") << " ../results/GC"; 
			system(mvCmd.str().c_str());


			// Get the Gate Cap 
			ifstream fileHandle ("../results/GC/RVP_Gate_Capacitance/data.txt");
			if (fileHandle.is_open()) {
				stringstream st;
				st << fileHandle.rdbuf(); 
				gateCap = atof(st.str().c_str());
				//cout << "RVP_Gate opened" << endl;
 			   	fileHandle.close();
  			} else {
				cerr << "Error: Can't open RVP_Gate_Capacitance test output " <<  endl;
				exit(1);
			}
		}
		void calculateTechRC() {
			// Calculate R,C of tech, then CWL,CBL RBL
			float param[] = {0, 0, 0, 0, 0};
			// Get tech node
			int techNode;
			sscanf(inp.technology.c_str(),"%*[^0-9]%d",&techNode);
			//cout << "techNode = " << techNode << endl;
			RC obj = InterconnectRC(techNode, "i", "cu", param);
			rbl = obj.res*inp.BCheight*1e6;
			cbl = obj.cap*inp.BCheight*1e6;
			cwl = obj.cap*inp.BCwidth*1e6;
			//cout << rbl << " " << cbl << " " << cwl << endl;
			//exit(1);
		}


		// should be moved to calculator
		// call it add cap to template
		void constructTemplate() {

		        // Empty the template
			techTemplate.str("");
			techTemplate.clear();
			
			// Read the input template
			string tasePath = inp.TASEpath;
			string tech = inp.technology;
			stringstream templ_path;
			templ_path << tasePath << "/template/RVPtpl_" << tech << ".ini";
			
			ifstream tpl(templ_path.str().c_str());
			if (!tpl.is_open()) {
				cerr << "Error: Can't find input template.\n";
				exit(1);
			}
			// Read the template and replace
			// Bit-cell information by user input
			// TODO-Need to check input complete
			// Check if height and width are mandatory
			string line;
			while(!tpl.eof()) {
				getline(tpl,line);
				if(line.find("addrRow") != string::npos) {
					techTemplate << "<addrRow>  " << log2(inp.n_rows) << endl;
				
				} else if(line.find("<NR_sweep>") != string::npos) {
					techTemplate << "<NR_sweep>  " << inp.n_rows << endl;
				

				} else if(line.find("<addrCol>") != string::npos) {
					techTemplate << "<addrCol>  " << log2(inp.n_colMux) << endl;
				
				} else if(line.find("<numBanks>") != string::npos) {
					techTemplate << "<numBanks>  " << inp.n_banks << endl;
				
				} else if(line.find("<memsize>") != string::npos) {
					techTemplate << "<memsize>  " << inp.memory_size << endl;
				
				} else if(line.find("<ws>") != string::npos) {
					techTemplate << "<ws>  " << inp.word_size << endl;

				} else if(line.find("<NC_sweep>") != string::npos) {
					techTemplate << "<NC_sweep> " << inp.n_colMux * inp.word_size << endl;

				} else if(line.find("<temp>") != string::npos) {
					techTemplate << "<temp> " << inp.temp << endl;

				} else if(line.find("<BL_DIFF>") != string::npos) {
					techTemplate << "<BL_DIFF> " << inp.SAoffset << endl;

				} else {		                
					techTemplate << line << endl;
		   		}
			}
			tpl.close();

			// Add the Gate Cap, cbl, cwl, rbl to the template 
			techTemplate << "\
<cg>\t" << gateCap << "\
\n\
\n####################\n\
# Metal Parasitics\n\
####################\n\
<rbl>\t" << rbl << "\n\
<cbl>\t" << cbl << "\n\
<cwl>\t" << cwl << "\n\
<char>\t0\n"; 		

			// Copy Bitcell dimensions 
			// TODO - Needs to be generic
			// Check which test needs that info
			// Add BC info to the template
			ifstream bc("../configuration/bitcellSizes.m");
			techTemplate << "\
#############################\n\
# Bitcell device dimensions\n\
#############################\n";
			if(!bc.is_open()) {
				cerr << "Error: Can't open bitcellSizes.m file.\n";
				exit(1);
			}
			while(!bc.eof()) {
				string line;
				getline(bc,line);
				//skip empty lines
				if(line.empty()) {
					continue;
				}
				regex_t re; 
				size_t     nmatch = 3;
				regmatch_t pmatch[3];
				char *pattern = "^[ \t]*([^ \t]+)[ \t]*=[ \t]*([^ \t]+)[ \t]*;";
				regcomp(&re, pattern, REG_EXTENDED); 
				int status = regexec(&re, line.c_str(), nmatch, pmatch, 0); 
				regfree(&re); 
	 			if(status!=0) {
					cerr << "Error: Can't Parse bitcell file.\n" << endl; 
					exit(1);
				}
				string token = line.substr(pmatch[1].rm_so, pmatch[1].rm_eo - pmatch[1].rm_so);
				string value = line.substr(pmatch[2].rm_so, pmatch[2].rm_eo - pmatch[2].rm_so);
				techTemplate << "<" << token << ">" << "\t" << value << endl;
			}
			bc.close();
			//cout << "TEMPLATE \n" << techTemplate.str().c_str() << endl;
		}
		void rmPrevResults() {
			// Delete previous results
			system("rm -fr ../results");
			// Create new folder if it doesn't exist
			struct stat st;
			stat("../results",&st);
			//if(! (st.st_mode && S_IFDIR) ) {
				system("mkdir ../results");
			//}
		}
		void simulate(string tests) {
			cout << "start simulation" << endl;
			// Run all tests
			if(tests.empty()) {
				SA.simulate(techTemplate.str());
				RD.simulate(techTemplate.str());
				CM.simulate(techTemplate.str());
				BC.simulate(techTemplate.str());
				TB.simulate(techTemplate.str());
				WD.simulate(techTemplate.str());
				ioDFF.simulate(techTemplate.str());
				BM.simulate(techTemplate.str());
				return;
			}
			// Run specified tests
			if(tests == "SA") {
				SA.simulate(techTemplate.str());
			}
			cout << "simulation done" << endl;
		}
		void extractOutput() {
			cout << "start extracting output" << endl;
			SA.extractOutput();
			cout << "SA Output extracted" << endl;
			RD.extractOutput();
			cout << "RD Output extracted" << endl;
			//CM.extractOutput();
			BC.extractOutput();
			cout << "BC Output extracted" << endl;
			TB.extractOutput();
			cout << "TB Output extracted" << endl;
			//WD.extractOutput();
			ioDFF.extractOutput();
			cout << "ioDFF Output extracted" << endl;
			BM.extractOutput();
			cout << "BM Output extracted" << endl;
			cout << "output extraction done" << endl;
		}
		void print() {
			cout << "start printing" << endl;
			SA.print();
			RD.print();
			//CM.print();
			BC.print();
			TB.print();
			//WD.print();
			ioDFF.print();
			BM.print();
			cout << "printing done" << endl;
		}
		////////////////////////////////////////////////////////////////////////////////////////////
		// read delay calculation
		// stage 1- input data latching in DFF
		// stage 2- row decoding
		// stage 3- max(WL pulse width required to write bitcell+SA delay, bank select signal delay)
		// stage 4- precharging BL back to VDD (this can be done in parallel with stage 2)
		// stage 5- data sent from bank select to DFF +output data latching in DFF
		////////////////////////////////////////////////////////////////////////////////////////////
		void calculateReadED(float& read_energy, float& read_delay) {
			// pch_r - due to driving bitlines back to .95*VDD after read (current default)
			float energy_pch_r = BC.getPCREnergy();
			float delay_pch_r = BC.getPCRDelay();

			// read- ED to discharge bitline to VDD-<BL_DIFF> (set in user.m)
			float energy_bitcell_r = BC.getBCREnergy();
			float delay_bitcell_r = BC.getBCRDelay();

			// only for read- sense amp resolution time, bank muxing to output DFF
			float energy_SA = SA.getEnergy();
			float delay_SA = SA.getDelay();
			
			// where can you get it?
			float energy_bankMux=0;

			// delay bankSelect is the propagation delay on the bank select signal, this occurs in parallel of the WL pulse+SA resolution
			// delay_bankOutput is the progation delay through the bank mux to the output DFF
			float delay_bankSelect = BM.getBankSelectDelay();
			float delay_bankOutput = BM.getBankOutputDelay();

			// read- ED of address inputs latching + output data latching
			float energy_DFF_r = ioDFF.getRenergy();
			float delay_DFF = ioDFF.getRdelay();	

			// ED of row decoder/wordline driver
			float energy_rowDecoder = RD.getEnergy();
			float delay_rowDecoder = RD.getDelay();

			// total leakage power from bitcells- converted later to leakage energy by multiplying by Tmin
			float leakage_power = BC.getBCLeakage();

			// ED for timing block
			float energy_timing = TB.getEnergy();
				
			//WL.calculateReadED();
				
			// Move leakage to staticE
			read_delay=delay_DFF+max(delay_pch_r,delay_rowDecoder)+max(delay_bitcell_r+delay_SA,delay_bankSelect)+delay_bankOutput+delay_DFF;
			read_energy=leakage_power*read_delay+energy_timing+energy_DFF_r+energy_rowDecoder+energy_pch_r+energy_bitcell_r+energy_bankMux+energy_SA;
			
			cout << "read_delay = " << read_delay << "  read_energy = " << read_energy << endl;
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////
		// write delay calculation
		// stage 1- input data latching in DFF
		// stage 2- row decoding, column/bank decoding, write BL droop (this calculation has 2 parts, the delay of the actual write driver pulling the BL low, and the propgation delay of the data from the DFF to the write driver)
		// stage 3- WL pulse width required to write bitcell
		// stage 4- precharging BL back to VDD (this can be done in parallel with stage 2)
		//////////////////////////////////////////////////////////////////////////////////////////
		void calculateWriteED(float& write_energy, float& write_delay) {

			// pch_w - driving bitlines back to .95*VDD after write (current default)
			float energy_pch_w = BC.getPCWEnergy();
			float delay_pch_w = BC.getPCWDelay();

			// write- ED to flip bitcell 
			float energy_bitcell_w = BC.getBCWEnergy();
			float delay_bitcell_w = BC.getBCWDelay();

			// only for write- delay measured driving bitline to VDD*.05
			float energy_writeDriver = BC.getWDEnergy();
			float delay_writeDriver = BC.getWDDelay();

			// write- ED of data inputs
			float delay_DFF = ioDFF.getRdelay();	
			float energy_DFF_w = ioDFF.getWenergy();
			float delay_DFF_w = ioDFF.getWdelay();

			// ED of row decoder/wordline driver
			float energy_rowDecoder = RD.getEnergy();
			float delay_rowDecoder = RD.getDelay();

			// total leakage power from bitcells- converted later to leakage energy by multiplying by Tmin
			float leakage_power = BC.getBCLeakage();

			// ED for timing block
			float energy_timing = TB.getEnergy();

			write_delay = delay_DFF+max(max(delay_rowDecoder,(delay_DFF_w-delay_DFF+delay_writeDriver)),delay_pch_w)+delay_bitcell_w;
			write_energy = leakage_power*write_delay+energy_timing+energy_DFF_w+energy_rowDecoder+energy_writeDriver+energy_pch_w+energy_bitcell_w;

			//cout << "write_delay = " << write_delay << " write_energy = " << write_energy << endl; 
		}
	        void runTASE(string tempPath) { 
	                stringstream sst;
	                sst << "perl " << inp.TASEpath << "/device/BIN/run.pl -i " << tempPath;
	                system(sst.str().c_str());
	        }
};

// TODO - Need to check memory size!
// Check the validity of the input

class calculator {
	private:
		userInput inputHandle;
		SRAM* sram;

		map<float, float> en;
		map<float, float> del;
		vector<float> hList;

	public:
	calculator() {
	}
	~calculator() {
	}
	void parseInputFile() {
		//Create parser handle
		parser* parserHandle = new parser;
		parserHandle->parseFile("user.m");

		//Get user input handle
		inputHandle = parserHandle->getInputHandle();
		//inputHandle.print();
	}
	void printInputParam() {
		inputHandle.print();
	}
	void createSRAM() {
		// Create SRAM obj
		sram = new SRAM;
		sram->setInput(inputHandle);
	}
	void rmPrevResults() {
		sram->rmPrevResults();
	}
	void runCharTests() {
		// Run Gate Capacitance Test
		sram->charGateCap();
		sram->calculateTechRC();
	}
	void simulate() {
		sram->rmPrevResults();
		sram->constructTemplate();
		sram->simulate("");
		sram->extractOutput();
	}
	void sweep() {
		float rE, rD, wE, wD;
		ofstream ofile(inputHandle.sweepOutput.c_str());
		// TODO - Make it generic
		for (float var = inputHandle.sweepBegin; var <= inputHandle.sweepEnd; var+=inputHandle.sweepStep) {
			// Modify the input 
			// Determine the token
			if(!strcmp(inputHandle.sweepToken.c_str(), "SAoffset")) {
				inputHandle.SAoffset = var;
			} 
			else if(!strcmp(inputHandle.sweepToken.c_str(), "PCratio")) {
				inputHandle.PCratio = (int)var;
			}
			else if(!strcmp(inputHandle.sweepToken.c_str(), "WLratio")) {
				inputHandle.WLratio = (int)var;
			}
			sram->setInput(inputHandle);

			// Simulate
			simulate();

			// Get new ED
			getED(rE,rD,wE, wD);	
		
			// Write to output file
			ofile << "\nSAOffset =" << var << endl; 
			ofile << "readEnergy= " << rE << endl;
			ofile << "readDelay= " << rD << endl;
			ofile << "writeEnergy= " << wE << endl;
			ofile << "writeDelay= " << wD << endl;
		}
		ofile.close();
	}
	// Used for debugging
	void constHash () {
		int b, r, c;
		float e, d, hash;
		ifstream file("/var/home/plb3qt/scratch/plb3qt/SRAM_OPT/cpp/SRAM8K.dat");
		cout << "Construct Hash" << endl;
		if(!file.is_open()) {
			cout << "CANT OPEN FILE" << endl;
		}
		while (!file.eof()) {
			string line;
			getline(file,line);
			//cout << " line = " << line << endl;
			sscanf(line.c_str(),"%d %d %d %f %f",&b, &r, &c, &e, &d);		
			cout << b << " " << r << " " << c << " " << e << " " << d << endl;
			hash = c + r + b*1e3;
			e*=1e12;
			d*=1e9;
			en[hash] = e; 
			del[hash] = d; 
			cout << "hash = " << hash << endl;
			cout << "en[hash] = " << en[hash] << endl;
		}
		file.close();
	}
	float getR (int in) {
		float r;
			if (in == 0) {
			// return either 2 or 0.5
			r = int(rand() % 2);
			if (r == 0) {
		       	    r = 0.5;
			} else if (r == 1){
			    r = 2;
			} 
	
		} else if (in == 1) {
			// return either 2,4 or 0.5,0.25
			r = int(rand() % 4);
			if (r == 0) {
		           r = 0.5;
			} else if (r == 1){
			   r = 2;
			} else if (r == 2) {
			   r = 0.25;
			} else {
			   r = 4;
			} 

		} else {
			// return either 2,4,8 or 0.5,0.25,0.125
			r = int(rand() % 8);
			if (r == 0) {
		           r = 0.5;
			} else if (r == 1){
			   r = 2;
			} else if (r == 2) {
			   r = 0.25;
			} else if (r == 3) {
			   r = 4;
			} else if (r == 4) {
			   r = 0.125;
			} else if (r == 5) {
			   r = 8;
			} else if (r == 6) {
			   r = 1.0/16;
			} else {
			   r = 16;
			}
		}
		return r;
	}
	// Used for debugging
	bool checkStatus (float r, float c, float b) {
		// search for the element		
		float hash = r + c + b*1e3;
		cout << "hash = " << hash << endl;
		vector<float>::iterator it = find(hList.begin(), hList.end(), hash);
		if(it == hList.end())
			return 1;
		else 
			return 0;
	}
	void execOptimize() {
		constHash();
		optimize();	
	}
	// Eliminate the dependency between
	// the number of banks, rows and col Mux
	// if rows, colMux and banks are included
	// Use only rows and colMux. number of banks
	// will be calculated according to the defined
	// values of rows and colMux.
	void redefineKnobs() {
		
		// Check which system level knob is defined in the user.m file
		bool tune_rows, tune_colMux, tune_banks = false;
		for(int i=0; i < inputHandle.knobCount; ++i) 
		{	       
		       string name = inputHandle.knobName[i];
		       if (!strcmp(name.c_str(),"NBANKS")) {
		       		tune_banks = true;
		       } else if(!strcmp(name.c_str(),"NCOLS")) {
		       		tune_colMux = true;
		       } else if(!strcmp(name.c_str(),"NROWS")) {
		       		tune_rows = true;
		       }
		}

		// Determine which knobs will be used
		// others will be calculated
		bool add_rows, add_colMux = false;

  		// Add rows & colM to the knobs
	        if(tune_banks && tune_colMux && tune_rows) {
	   		add_rows = true;
			add_colMux = true;
			inputHandle.calNumBanks = true;
		} 
		// Add only rows to the knobs
		else if (tune_rows) 
		{
		   add_rows = true;
		   if(tune_banks) 
			inputHandle.calNumBanks = true;
		   else
			inputHandle.calNumColMux = true;		   
		}
		// Add only colMux to the knobs
		else if (tune_colMux) 
		{
		   add_colMux = true;
		   inputHandle.calNumBanks = true;
		}
		
		// Redefine knobs
		int newknobCount = 0;
		string newknobName[20];
		float newknobMin[20];
		float newknobMax[20]; 
		for(int i=0; i < inputHandle.knobCount; ++i) 
		{	       
		       if (
		         (!strcmp(inputHandle.knobName[i].c_str(),"NCOLS") && !add_colMux) ||
			 (!strcmp(inputHandle.knobName[i].c_str(),"NROWS") && !add_rows) ||
			 (!strcmp(inputHandle.knobName[i].c_str() == "NBANKS"))
			  ) 
		       {
		       		// Don't add the knob
		       		cout << "XXXXXXXXXXXXXXXXXXXXXXX" << endl;
		       } 
		       else
		       {
				newknobName[newknobCount] = inputHandle.knobName[i]; 
		       		newknobMin[newknobCount] = inputHandle.knobMin[i];
		       		newknobMax[newknobCount] = inputHandle.knobMax[i];
		       		++newknobCount;
		       }
		}
		
		// Overwrite Userinput object
		inputHandle.knobCount = newknobCount;
		for(int i=0; i < newknobCount; ++i) 
		{	       
	       		inputHandle.knobName[i] = newknobName[i];
	       		inputHandle.knobMin[i] = newknobMin[i];
	       		inputHandle.knobMax[i] = newknobMax[i];
		}
	}
	void optimize () {
	
	    //ofstream file("output.txt");
   	    // the probability
    	    //alpha =0.999;
   	    float proba = 0.999;
   	    float alpha =0.3;
	    float temperature = 400;
	    float eps = 0.001;
	    float iteration = 0;
	    float curr_cost = 100000;
	    float best_cost = 100000;
	    float cur_var = 1;
	    float rMoves = 0;    

	    float hash;
	    float b, r, c, m, w, s, nc, nr, nb;
    
	    // Initial Values
	    w = inputHandle.word_size;
	    m = inputHandle.memory_size;
	    b = inputHandle.n_banks;
	    c = inputHandle.n_colMux;
	    r = inputHandle.n_rows;
	    // Check
	    //r = m / (c * w);
   	     
	    // Determine the knobs
	    bool tuneNBank = 0;
	    bool tuneNRow = 0;
            bool tuneNCol = 0;
    	    for(int i = 0; i < inputHandle.knobCount; ++i) {
    		if(!strcmp(inputHandle.knobName[i].c_str(), "NBANKS")) {
			tuneNBank = 1;
		}
	    	else if(!strcmp(inputHandle.knobName[i].c_str(), "NCOLS")) {
			tuneNCol = 1;
		}
    		else if(!strcmp(inputHandle.knobName[i].c_str(), "NROWS")) {
			tuneNRow = 1;
		}
	    }
    	    cout << "tuneNBank = " << tuneNBank << " tuneNRow = " << tuneNRow  << " tuneNCol = " << tuneNCol  << endl;
	    // Error if one knob exist on the system level
	    if ((tuneNBank + tuneNCol + tuneNRow) == 1) {
    		cerr << "Error: Insufficient number of knobs at the system level <banks, cols, rows>" << endl;
		exit(1);
    	    }

	    // while the temperature did not reach eps
	    // while ($temperature > $eps && $iteration < 25 && $rMoves < 1e3) {
    
	    while (iteration < 1e2 && rMoves < 5) {

	        ++iteration;
    
	        if(iteration == 2) {
			exit(0);
		}
		
		// Get a new b,r,c 
		int lock = 0;
		int itr = 0;
		while(1) {
			cout << "\n\n b " << b << " r = " << r << " c = " << c <<  "\n";
			++itr;
			if(itr > 1e2) {
			   lock = 1;
			}
			if(itr > 1e3) {
			   lock = 2;
			}
			if(itr > 1e5) {
			   cout << "Exceed Max Number Of Substitution" << endl;
			   exit(0);
			}
			
			// Check tuneBank flag
			int modifyB = 0;
			if(tuneNBank && tuneNCol && tuneNRow) {
				modifyB = int(rand() % 2);
			
			} else if (tuneNBank) {
				modifyB = 0;
			}
		
			if(modifyB) {
				cout << "ChangeBank" << endl;
				//Change b
				float ch = getR(lock);
				if ( (b*ch <= 16) && (b*ch >= 1)) {
					// Change r or c
					int modifyR = 0; 
					if(tuneNCol && tuneNRow) {
						modifyR = int(rand() % 2);
					} else if (tuneNRow) {
						modifyR = 1;
					}			
					if (modifyR && (r/ch <= 512) && (r/ch >= 32) && checkStatus(r/ch, c, b*ch)) {
						// Change r
						cout << "ChooseR" << endl;
						nb=b*ch;
						nr=r/ch;
						nc = c; 
						break;
					} else if ( (c/ch >= 1) && (c/ch <= 8) && checkStatus(r, c/ch, b*ch)) {
						// Change c
						cout << "ChooseC" << endl;
						nb=b*ch;
						nc=c/ch;
						nr = r; 
						break;
					}
				}	
			
			} else {
				// Don't Change b
				cout << "DontChangeBank" << endl;
				float ch = getR(lock);
				if ((r*ch <= 512) && (r*ch >= 32) && (c/ch >= 1) && (c/ch <= 8) && checkStatus(r*ch, c/ch, b)) {
					// Change r&c
					nr=r*ch;
					nc=c/ch;
					nb = b; 
					break;
				} 
			}
		}
		// Store hash to avoid re-iteration
		hash = nc + nr + nb*1e3;
		cout << "Calculated Hash = " << hash << endl;
		hList.push_back(hash);
		cout << "DONE nb = "  << nb << " nr = " <<  nr << " nc = " << nc << endl;
       	 
		// Change input
		// Call Simulate
		// Get Energy/Delay
		float energy, delay;
		//energy = en[hash];
		//delay = del[hash];

		inputHandle.n_banks = (int)nb; 
		inputHandle.n_colMux = (int)nc;
		inputHandle.n_rows = (int)nr;
		sram->setInput(inputHandle);

		// Simulate
		simulate();

		// Get new ED
		float rE,rD,wE, wD;
		getED(rE,rD,wE, wD);	
	        energy = rE + wE;
		delay = rD + wD;
		 
		// Evaluate new cost
		float new_cost = energy;
	
		if(delay > 1.05) {
			new_cost+=100*delay;
		}
		cout << "NC: " << new_cost << endl;
		
       		// Compute the distance of the new permuted configuration
        	float delta = new_cost - curr_cost;

	        // if the new cost is smaller accept it and assign it
	        if (delta<0) {
		    b=nb;
		    r=nr;
		    c=nc;
		    curr_cost = new_cost;
		    cout << "-Accept Move-\t" << endl;
		    if (new_cost < best_cost) {
	       	        best_cost = new_cost;            
		    }
 	       } else {
  	            // Decrease Pa for now.
		    // proba = rand();
            	    proba = 0.15;
	    
		    // if the new cost is worse accept 
       		    // it but with a probability level
       		    // if the probability is less than 
       		    // E to the power -delta/temperature.
       		    // otherwise the old value is kept
            	    if (proba < exp(-delta/temperature)) {
	 	   	b=nb;
	 	   	r=nr;
	 	   	c=nc;
	  	   	curr_cost = new_cost;
		   	float tmp = exp(-delta/temperature);
  	    	   	cout << "-Accept Move prob = " << proba << " tmp = " << tmp << endl;
	    	   } else {
  	 	        ++rMoves;
      	 	   	cout  << "-Reject Move-" << endl;
	    	   }
	 	}

       		// Cooling process on every iteration
      		temperature = temperature * alpha;
    
  	  	cout << "\n\nit= " << iteration << " \t " << nb << " " << nr << " " << nc << " " << new_cost << "\t" << b << " " << r << " " << c << " " << " " << curr_cost << "\t" << best_cost << endl;
	   }
	}
	void runBruteForce() 
	{
	    // Get the total num of iterations
	    float num_iterations = 1;
	    for(int i=0; i < inputHandle.knobCount; ++i) {
	    	float count;
		// banks, col and rows are specified 
		// in a multiple of 2 increments
		// count=2 when min=2, max=4. 
		if(
		   inputHandle.knobName[i] == "NBANKS" ||
		   inputHandle.knobName[i] == "NCOLS" ||
	           inputHandle.knobName[i] == "NROWS"
		  ) {
		      count = inputHandle.knobMax[i] / inputHandle.knobMin[i];
		 } else {
		      count = inputHandle.knobMax[i] - inputHandle.knobMin[i];
		 }
		num_iterations *= count;
	    }
	    // Debug
	    cout << "num_iterations = " << num_iterations << endl;
    	    
	    // Current value of knobs
	    float knob_curr_val[32];

	    // Loop over all the iterations
	    for(int i=0; i < num_iterations; ++i)
	    {

	    	// Assign initial values for the knobs
		if(i == 0) {
			for(int i=0; i < inputHandle.knobCount; ++i)
	      		  knob_curr_val[i] = inputHandle.knobMin[i];
		} 
		else
		{
		// Update knobs values
			int count = 1;
			for(int j=0; j < inputHandle.knobCount; ++j) 
			{
				if (!((i+1) % count))
				{
					// Check if it is a system level knob
					// Multiply banks, rows, col 
					// increment anything else
					bool sysKnob = false;
					if(inputHandle.knobName[j] == "NBANKS" ||
					   inputHandle.knobName[j] == "NCOLS" ||
					   inputHandle.knobName[j] == "NROWS") {
						sysKnob = true;
					}
					// Update the knobs values
					if(knob_curr_val[j] >= inputHandle.knobMax[j]) {
						knob_curr_val[j] = inputHandle.knobMin[j];
					} else {
					   	if(sysKnob) {
						   knob_curr_val[j] *= 2;
						} else {
					    	   knob_curr_val[j] += 1;
						} 
					}
					// Update count to determine which 
					// knob to update for this iteration
					if(sysKnob) {
						count *= (int)(inputHandle.knobMax[j]/inputHandle.knobMin[j]);
					} else {
						count *= (int)(inputHandle.knobMax[j] - inputHandle.knobMin[j]);
					}
				}

			} // End of update knobs looop
		} // End of if(it == 0)

	        // Copy the new values of the knob to
	        // the input object to be used in simulation
		for(int j=0; j < inputHandle.knobCount; ++j) 
		{	       
		       string name = inputHandle.knobName[j];
		       if (!strcmp(name.c_str(),"NBANKS")) {
		       
		               //Update number of banks at the end
		               //after calculating # rows, columns
		       } else if(strcmp(name.c_str(),"NCOLS")) {
		               inputHandle.n_colMux = (int)knob_curr_val[j];
		       } else if(strcmp(name.c_str(),"NROWS")) {
		               inputHandle.n_rows = (int)knob_curr_val[j];
		       }
		}	
				       
		// Re-write bank (b=mem_size/col*rows)
		// Need to wait untill col and rows values
		// are written to confirm the new value
		// of #bank
		bool invalid = false;
		for(int j=0; j < inputHandle.knobCount; ++j) {
			if(inputHandle.knobName[j] == "NBANKS") {
				inputHandle.n_banks =  inputHandle.memory_size / (inputHandle.n_colMux * inputHandle.n_rows); 
				// Modify konb_curr_val - just for debugging
				knob_curr_val[j] = inputHandle.n_banks; 
				// Check number of banks is valid
				// Continue to next iteration if not
				//DEBUG
				//cout << "Inside bank check " << inputHandle.n_banks   << " colMux " << inputHandle.n_colMux << " rows " << inputHandle.n_rows <<  endl;
				if(
				    inputHandle.n_banks < inputHandle.knobMin[j] ||
				    inputHandle.n_banks > inputHandle.knobMax[j] ||
   				    inputHandle.n_banks < 1  || 
				    inputHandle.n_banks > 16
				   )
				 {
				  	invalid = true;
				 } 
			}
		}
		
		// Tune bank
		inputHandle.n_banks =  inputHandle.memory_size / (inputHandle.n_colMux * inputHandle.n_rows); 

		// Skip this iteration - Invalid design
		if(invalid)
		{
		  cout << "Invalid " << inputHandle.n_banks << " " << inputHandle.n_rows << " " << inputHandle.n_colMux << endl;
		  continue;
		}
		// Update input handle inside the SRAM object
		sram->setInput(inputHandle);

	    	// Simulate
	   	// simulate();

	    	// Get new ED
		//float rE,rD,wE, wD;
	    	//getED(rE,rD,wE, wD);    
	    	//energy = rE + wE;
	    	//delay = rD + wD;

		// Print iteration info
		for(int j=0; j < inputHandle.knobCount; ++j) 
			cout << inputHandle.knobName[j] << " = " << knob_curr_val[j] << endl;
		//cout << "Energy = " << energy << "Delay = " << delay << endl;
		cout << endl;
	   
	   } // End of iterations loop
	}
	void getED(float&rE, float&rD, float&wE, float&wD) {
		sram->calculateReadED(rE,rD);
		sram->calculateWriteED(wE,wD);
	}
	void print() {
		sram->print();
	}
};

int main()
{
	calculator* CT = new calculator;
	CT->parseInputFile();
	CT->createSRAM();
	CT->rmPrevResults();
	CT->printInputParam();
	CT->redefineKnobs();
	CT->printInputParam();
	//CT->runCharTests();
	//CT->simulate();
	//CT->sweep();
	//CT->execOptimize();
	//CT->runBruteForce();
	
	float rE,rD, wE, wD;
	rE=88;
	rD=99;
	wE=188;
	wD=199;
	
	//CT->getED(rE,rD,wE, wD);	
	//CT->print();
	//cout << "rEn= " << rE << " rDel= " << rD << "\nwEn= " << wE << " wDel= " << wD << endl;
	
	//Create parser handle
	//parser* parserHandle = new parser;
	//parserHandle->parseFile("user.m");

	//Get user input handle
	//userInput inputHandle = parserHandle->getInputHandle();
	//inputHandle.print();

	// Create SRAM obj
	//SRAM* sram = new SRAM;
	//sram->setInput(inputHandle);
	//sram->runPreSimulation();
	//sram->runSimulations();
	//sram->constructTemplate();
	
	
	return 0;
}
