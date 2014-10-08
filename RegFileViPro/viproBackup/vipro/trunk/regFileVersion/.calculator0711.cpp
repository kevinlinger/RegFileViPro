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

#include "metalCap.cpp"
#include "periphery2.cpp"

using namespace std;

userInput::userInput() {
	//Intialize partameters
	//Can u intialize with struct
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
				cout << "DAMN ---> " << cmd.c_str() << endl;
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
			RD.extractOutput();
			//CM.extractOutput();
			BC.extractOutput();
			TB.extractOutput();
			//WD.extractOutput();
			ioDFF.extractOutput();
			BM.extractOutput();
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

class calculator {
	private:
		userInput inputHandle;
		SRAM* sram;
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
		for (float var = inputHandle.sweepBegin; var < inputHandle.sweepEnd; var+=inputHandle.sweepStep) {
			// Modify the input 
			// Determine the token
			if(!strcmp(inputHandle.sweepToken.c_str(), "SAoffset")) {
				inputHandle.SAoffset = var;
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
	CT->runCharTests();
	//CT->simulate();
	CT->sweep();
	
	float rE,rD, wE, wD;
	rE=88;
	rD=99;
	wE=188;
	wD=199;
	
	CT->getED(rE,rD,wE, wD);	
	CT->print();
	cout << "rEn= " << rE << " rDel= " << rD << "\nwEn= " << wE << " wDel= " << wD << endl;
	
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
