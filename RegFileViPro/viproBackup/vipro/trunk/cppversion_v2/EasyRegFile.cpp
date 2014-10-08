
class userInput {
	public:
	string technology; 
	int memory_size; 
	int n_banks; 
	int n_colMux; 
	int n_rows;
	int word_size;
	int readPorts;
	int writePorts;
	int bitcellUpsize;
	float SAoffset;
	float BCheight;
 	float BCwidth; 
	float energy_constraint;
	float delay_constraint;
	int WDwidth; 
	float temp;
	float vdd;
	string TASEpath; 

	int knobCount;
	float knobMin[20];
	float knobMax[20];
	string knobName[20];

	bool calNumBanks;
	int minNumBanks;
	int maxNumBanks;

	bool calNumColMux;
	int minNumColMux;
	int maxNumColMux;


	bool WLBoost;
	float WLOffset;

	int PCratio;
	int WLratio;
	
	string sweepToken;
	float sweepBegin;
	float sweepEnd;
	float sweepStep; 
	string sweepOutput;

	userInput();
	~userInput();
	void print();
	void setTech(string tech);
	void setMemSize(int memSize);
	void setNBanks(int nBanks);
	void setNColMux(int nColMux); 
	void setNRows(int nRows); 
	void setWordSize(int wordSize);
	void setSAOffset(float SAOffset); 
	void setBCHeight(float BCHeight); 
	void setBCWidth(float BCWidth); 
	void setENConstraint(float ENConst); 
	void setDLConstraint(float DLConst); 
	void setWDWidth(int WDWidth); 
	void setTASEPath(string path); 
	void setTemp(float temperature);
	void setVdd(float vdd);
	void setWLBoost(bool WLBoostFlag);
	void setWLOffset(float offset);
	void setReadPorts(int numReadPorts);
	void setWritePorts(int numWritePorts);
	void setBitcellUpsize(int size);
	string getTech(); 
	int getMemSize(); 
	int getNBanks(); 
	int getNColMux(); 
	int getNRows(); 
	int getWordSize(); 
	float getSAOffset(); 
	float getBCHeight(); 
	float getBCWidth(); 
	float getENConstraint(); 
	float getDLConstraint(); 
	float getWDWidth(); 
	string getTASEPath(); 
	float getTemp();
	float getVdd();
	bool getWLBoost();
	float getWLOffset();
	int getReadPorts();
	int getWritePorts();
	int getBitcellUpsize();
};
class SRAMSubblock {
	public:
        userInput* input;
        string tasePath; 
        string tech; 

        void runTASE(string tempPath) { 
                stringstream sst;
                cout << "perl " << tasePath << "/device/BIN/run.pl -i " << tempPath << endl;
		sst << "perl " << tasePath << "/device/BIN/run.pl -i " << tempPath;
                system(sst.str().c_str());
        }
	void moveResults(string test) {
                stringstream mvcmd;
                mvcmd << "cp -fr " << tasePath << "/device/BIN/" << getenv("USER") << " ../results_v2/" << test;
                system(mvcmd.str().c_str());
	}
	string constructTempelate(string testName, string techTemp, string testInfo) {
                stringstream templatePath;
		templatePath << tasePath << "/template/RVP_" << testName << tech << ".ini";
		ofstream ofile(templatePath.str().c_str());
                ofile << techTemp << testInfo << endl;
                ofile.close();
		return templatePath.str();
	}
};
class DFF: public SRAMSubblock {
        private:
	float delay_DFF;
	float delay_DFF_w;
	float energy_DFF_r;
	float energy_DFF_w;

        public:
        DFF() {
        }
        DFF(userInput& uInp) {
        }
        ~DFF() {
        }
        void setInput(userInput& uImp) {
                input = &uImp;
                tasePath = input->TASEpath;
                tech = input->technology;
        }
        void simulate(string techTemp) {
                string testInfo = "<ocn>\n\
RVP_DFF\n\
</ocn>\n";
		string tempPath = constructTempelate("DFF",techTemp,testInfo);
                runTASE(tempPath);
		moveResults("DFF");
        }
        void extractOutput() {
                stringstream sst;
                ifstream fileHandle;
                fileHandle.open("../results_v2/DFF/RVP_DFF/data.txt"); 
                if(!fileHandle.is_open()) {
			cerr << "Error: Can't open output file \n ../results_v2/DFF/RVP_DFF/data.txt" << endl;
			exit(1);
		}
		sst << fileHandle.rdbuf();
                sst >> delay_DFF >> delay_DFF_w >> energy_DFF_r >> energy_DFF_w; 
                fileHandle.close();
        }
	float getRdelay() {
		return delay_DFF;
	}
	float getRenergy() {
		return energy_DFF_r;
	}	
	float getWdelay() {
		return delay_DFF_w;
	}
	float getWenergy() {
		return energy_DFF_w;
	}
        void print() {
           cout << "tasePath " << tasePath <<  endl;
	   cout << "delay_DFF= " << delay_DFF << "\n energy_DFF_r= " << energy_DFF_r << endl;
	   cout << "delay_DFF_w= " << delay_DFF_w << "\n energy_DFF_w= " << energy_DFF_w << endl;
	}
};

class rowDecoder : public SRAMSubblock {
        private:
	int nRows;

	float energy_rowDecoder;
	float delay_rowDecoder;
        
	public:
        rowDecoder() {
        }
        rowDecoder(userInput& uInp) {
        }
        ~rowDecoder() {
        }
        void simulate(string techTemp) {
                stringstream techTemplate;
                techTemplate << techTemp;

		// Check if WL Boosting is specified
		if(input->WLBoost) {
                techTemplate << "<ocn>\n\
RVP_Decoder_WWL_Boost\n\
</ocn>\n";
		}
		else
		{
                techTemplate << "<ocn>\n\
RVP_Decoder\n\
</ocn>\n";
		}
                stringstream newTempPath;
                newTempPath << tasePath << "/template/RVP_RD_" << tech << ".ini";
                ofstream ofile(newTempPath.str().c_str());
                ofile << techTemplate.str() << endl;
                ofile.close();
                runTASE(newTempPath.str());
		moveResults("RD");
        }
        void extractOutput() {
                stringstream sst_path, sst;
                ifstream fileHandle;
                string dummy;
		
		//Revisit the hierarchy
		//Check WL Boosting
		if(input->WLBoost) {
    	       		sst_path << "../results_v2/RD/RVP_Decoder_WWL_Boost/output_" << nRows << ".txt";
    	        	fileHandle.open(sst_path.str().c_str());
       		        cout << " Rows= " << nRows << endl;
			if(!fileHandle.is_open()) {
				cerr << "Error: Can't open output file \n" << sst_path << endl;
				exit(1);
			}
			sst << fileHandle.rdbuf();

			float power; 
			sst >> dummy >> dummy >> dummy >> delay_rowDecoder >>  power;
			energy_rowDecoder = power*32e-9;
		} else {	
    	       		sst_path << "../results_v2/RD/RVP_Decoder/output_" << nRows << ".txt";
    	        	fileHandle.open(sst_path.str().c_str());
       		        cout << " Rows= " << nRows << endl;
			if(!fileHandle.is_open()) {
				cerr << "Error: Can't open output file \n" << sst_path << endl;
				exit(1);
			}
			sst << fileHandle.rdbuf();
			string str = sst.str();
			regex_t re; 
			size_t     nmatch = 3;
			regmatch_t pmatch[3];	
	
			char *pattern = "[^\n]*\n[^\n]*\n[^\n]*\n[ \t]*[^ \t]+[ \t]*[^ \t]+[ \t]*[^ \t]+[ \t]*([^ \t]+)[ \t]*([^ \t]+)";
			regcomp(&re, pattern, REG_EXTENDED); 
			int status = regexec(&re, str.c_str(), nmatch, pmatch, 0); 
			regfree(&re); 
			if(status!=0) {
				cerr << "Error: Can't Parse Row Decoder file " << sst_path.str().c_str() << "\n" << str << endl;
				exit(0);
			}
			string delay_s = str.substr(pmatch[1].rm_so, pmatch[1].rm_eo - pmatch[1].rm_so);
			string energy_s = str.substr(pmatch[2].rm_so, pmatch[2].rm_eo - pmatch[2].rm_so);
			delay_rowDecoder = atof(delay_s.c_str());
			energy_rowDecoder = atof(energy_s.c_str())*32e-9;
                }
		fileHandle.close();
        }
        void setInput(userInput& uImp) {
                input = &uImp;
                tasePath = input->TASEpath;
                tech = input->technology;
        	nRows = (int)log2((int)input->n_rows);
	}
	float getEnergy() {
		return energy_rowDecoder;
	}
	float getDelay() {
		return delay_rowDecoder;
	}
        void print() {
           	cout << "tasePath " << tasePath <<  endl;
	   	cout << "delay_rowDecoder= " << delay_rowDecoder << "\n energy_rowDecoder= " << energy_rowDecoder << endl;
	}
};

class timingBlock : public SRAMSubblock {
        private:

	float energy_timing;

        public:
        timingBlock() {
        }
        timingBlock(userInput& uInp) {
        }
        ~timingBlock() {
        }
        void simulate(string techTemp) {
                stringstream techTemplate;
                techTemplate << techTemp;
                techTemplate << "<ocn>\n\
RVP_TIMING\n\
</ocn>\n";
                stringstream newTempPath;
                newTempPath << tasePath << "/template/RVP_TB_" << tech << ".ini";
                ofstream ofile(newTempPath.str().c_str());
                ofile << techTemplate.str() << endl;
                ofile.close();
                runTASE(newTempPath.str());

		moveResults("TB");
        }
        void extractOutput() {
                stringstream sst;
                ifstream fileHandle;

                fileHandle.open("../results_v2/TB/RVP_TIMING/data.txt");
                if(!fileHandle.is_open()) {
			cerr << "Error: Can't open output file \n ../results_v2/TB/RVP_TIMING/data.txt" << endl;
			exit(1);
		}
                sst << fileHandle.rdbuf();
                sst >> energy_timing;
                fileHandle.close();
        }
        void setInput(userInput& uImp) {
                input = &uImp;
                tasePath = input->TASEpath;
                tech = input->technology;
        }
	void print() {
	        cout << "tasePath= " << tasePath <<  endl;
		cout << "energy_timing= " << energy_timing << endl;
	}
	float getEnergy() {
		return energy_timing;
	}
};

class dynamicRead : public SRAMSubblock {
private:

	float delay_dynamicRead;
	float energy_dynamicRead;
	float delay_staticRead;
	float energy_staticRead;
	float delay_staticWrite;
	float energy_staticWrite;
	float delay_dynamicWrite;
	float energy_dynamicWrite;
	float chargeDelay_dynamicWrite;
	float chargeDelay_staticWrite;

public:
	dynamicRead() {
	}
	dynamicRead(userInput& uInp) {
	}
	~dynamicRead() {
	}
	void simulate(string techTemp) {

		//First add input parameters to ini file, in this case we add the number of read and write ports

		//Need to figure out how many global and local bit lines to use
		int gblNumStatic = 0;
		int lblNumStatic = 0;
	    int gblNumDynamic = 0;
		int lblNumDynamic = 0;
		string writeNetlist = "./netlist";
		if(input->readPorts <= 1)
		{
			writeNetlist = "./netlist1Read";
		}

		int logRow = this->calculateGlobalBitLineNumber();
		if((logRow % 2) == 0){
			gblNumStatic = lblNumStatic = logRow/2;
			gblNumDynamic = logRow/2 - 1;
			lblNumDynamic = logRow/2;
		}
		else
		{
			gblNumStatic = logRow/2;
			lblNumStatic = logRow/2 + 1;
			gblNumDynamic = lblNumDynamic = logRow/2;
		}


		//Split read ports evenly across bitcell, account for odd numbers
		int readPortsQ = 0;
		int readPortsQB = 0;

		if(((input->readPorts) % 2) == 0)
		{
			readPortsQ = (input->readPorts/2);
			readPortsQB = (input->readPorts/2);
		}
		else
		{
			readPortsQ = (input->readPorts/2)+1;
			readPortsQB = (input->readPorts/2);
		}


		/*
		int bitcellReadPortCap = 0;
		int bitcellReadPortCapQB = 0;
		int bitcellStaticReadPortCap = 0;
		int bitcellStaticReadPortCapQB = 0;

		if(((input->readPorts) % 2) == 0)
		{
			bitcellReadPortCap = (input->readPorts/2)*5;
			bitcellReadPortCapQB = (input->readPorts/2)*5;
			bitcellStaticReadPortCap = (input->readPorts/2)*3;
			bitcellStaticReadPortCapQB = (input->readPorts/2)*3;
		} else
		{
			bitcellReadPortCap = ((input->readPorts/2)+1)*5;
			bitcellReadPortCapQB = (input->readPorts/2)*5;
			bitcellStaticReadPortCap = ((input->readPorts/2)+1)*3;
			bitcellStaticReadPortCapQB = (input->readPorts/2)*3;
		}
		*/

		int pDownWidth = 5;

		stringstream techTemplate;
		techTemplate << techTemp;
		techTemplate << "\
						#############################\n\
						# Register File Ports\n\
						#############################\n\
						<readPorts>\t" << input->readPorts << "\n\
						<writePorts>\t" << input->writePorts << "\n\
						<gblNumStatic>\t" << gblNumStatic << "\n\
						<lblNumStatic>\t" << lblNumStatic << "\n\
						<gblNumDynamic>\t" << gblNumDynamic << "\n\
						<lblNumDynamic>\t" << lblNumDynamic << "\n\
						<rows>\t" << input->n_rows << "\n\
						<pullDownWidth>\t" << pDownWidth << "\n\
						<bitcellUpsize>\t" << input->bitcellUpsize << "\n\
						<readPortsQ>\t" << readPortsQ << "\n\
						<readPortsQB>\t" << readPortsQB << "\n\
						<writeNetlist>\t" << writeNetlist;

		//Now add the tests that need to be run, both static read and dynamic read

				techTemplate << "\n\
						<ocn>\n\
						RF_Static_Read\n\
						RF_Dynamic_Read\n";
				if(input->readPorts == 1){
					techTemplate << "\
						RF_Write_Static_1Read\n\
						RF_Write_Dynamic_1Read\n\
						</ocn>\n";
				}
				else
				{
					techTemplate << "\
						RF_Write_Static\n\
						RF_Write_Dynamic\n\
						</ocn>\n";
				}

	//			techTemplate << "\n\
						<ocn>\n\
						RF_Write_Dynamic\n\
						</ocn>\n";


		//Create ini file
		stringstream newTempPath;
		newTempPath << tasePath << "/template/RVP_DR_" << tech << ".ini";
		ofstream ofile(newTempPath.str().c_str());
		ofile << techTemplate.str() << endl;
		ofile.close();



		//Run TASE with the new ini file
		runTASE(newTempPath.str());

		//Move results to specified directory
		moveResults("DR");
	}

	void extractOutput() {

		//First extract dyanmic read results
		stringstream sst;
		ifstream fileHandle;
		string oneRead = "";
		if(input->readPorts == 1)
		{
			oneRead = "_1Read";
		}

		fileHandle.open("../results_v2/DR/RF_Dynamic_Read/data.txt");
		sst << fileHandle.rdbuf();
		sst >> delay_dynamicRead; 
		sst >> energy_dynamicRead;
		cout << fileHandle.good() << " - delay_dynamicRead " << delay_dynamicRead << endl;
		fileHandle.close();

		//Then static Read
		stringstream Staticsst;
		ifstream StaticfileHandle;

		StaticfileHandle.open("../results_v2/DR/RF_Static_Read/data.txt");
		Staticsst << StaticfileHandle.rdbuf();
		Staticsst >> delay_staticRead; 
		Staticsst >> energy_staticRead;
		cout << StaticfileHandle.good() << " - delay_staticRead " << delay_staticRead << endl;
		StaticfileHandle.close();

		//Then dynamic Write
		stringstream DynamicWritesst;
		ifstream DynamicWritefileHandle;


		string writeFile = "../results_v2/DR/RF_Write_Dynamic" + oneRead + "/data.txt";
		DynamicWritefileHandle.open(writeFile.c_str());
		DynamicWritesst << DynamicWritefileHandle.rdbuf();
		DynamicWritesst >> delay_dynamicWrite; 
		DynamicWritesst >> chargeDelay_dynamicWrite;
		DynamicWritesst >> energy_dynamicWrite;
		cout << DynamicWritefileHandle.good() << " - delay_dynamicWrite " << delay_dynamicWrite << endl;
		DynamicWritefileHandle.close();

		//Then Static Write
		stringstream StaticWritesst;
		ifstream StaticWritefileHandle;

		writeFile = "../results_v2/DR/RF_Write_Static" + oneRead + "/data.txt";
		StaticWritefileHandle.open(writeFile.c_str());
		StaticWritesst << StaticWritefileHandle.rdbuf();
		StaticWritesst >> delay_staticWrite;
		StaticWritesst >> chargeDelay_staticWrite;
		StaticWritesst >> energy_staticWrite;
		cout << StaticWritefileHandle.good() << " - delay_StaticWrite " << delay_staticWrite << endl;
		StaticWritefileHandle.close();

	}

	void setInput(userInput& uImp) {
		input = &uImp;
		tasePath = input->TASEpath;
		tech = input->technology;
	}

	void print() {
		cout << "tasePath= " << tasePath <<  endl;
		cout << "delay_dynamicRead= " << delay_dynamicRead << endl;
	}

	float getDynamicReadDelay() {
		return delay_dynamicRead;
	}
	float getDynamicReadEnergy() {
		return energy_dynamicRead;
	}
	float getStaticReadDelay() {
		return delay_staticRead;
	}
	float getStaticReadEnergy() {
		return energy_staticRead;
	}	
	float getDynamicWriteDelay() {
		return delay_dynamicWrite;
	}
	float getDynamicWriteChargeDelay() {
		return chargeDelay_dynamicWrite;
	}
	float getDynamicWriteEnergy() {
		return energy_dynamicWrite;
	}
	float getStaticWriteDelay() {
		return delay_staticWrite;
	}
	float getStaticWriteChargeDelay() {
		return chargeDelay_staticWrite;
	}
	float getStaticWriteEnergy() {
		return energy_staticWrite;
	}

	int calculateGlobalBitLineNumber(){
		int rows = (input->memory_size)/(input->word_size);
		
		//Calculate integer log2 of number or rows
		int power = 0;
		int i = 0;
		while(true){
			rows = rows/2;
			if(rows == 0) break;

			i++;
		
		}

		return i;
		
	}

};
