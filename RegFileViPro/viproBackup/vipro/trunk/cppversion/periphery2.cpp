class userInput {
	public:
	string technology; 
	int memory_size; 
	int n_banks; 
	int n_colMux; 
	int n_rows;
	int word_size;
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
};
class SRAMSubblock {
	public:
        userInput* input;
        string tasePath; 
        string tech; 

        void runTASE(string tempPath) { 
                stringstream sst;
		//cout << "perl " << tasePath << "/device/BIN/run.pl -i " << tempPath << endl;
                sst << "perl " << tasePath << "/device/BIN/run.pl -i " << tempPath;
                system(sst.str().c_str());
        }
	void moveResults(string test) {
                stringstream mvcmd;
                mvcmd << "cp -fr " << tasePath << "/device/BIN/" << getenv("USER") << " ../results/" << test;
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
                fileHandle.open("../results/DFF/RVP_DFF/data.txt"); 
                if(!fileHandle.is_open()) {
			cerr << "Error: Can't open output file \n ../results/DFF/RVP_DFF/data.txt" << endl;
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

class senseAmp : public SRAMSubblock {
        private:
	float energy_SA;
	float delay_SA;
	
        public:
        senseAmp() {
        }
        senseAmp(userInput& uInp) {
        }
        ~senseAmp() {
        }
        void getBCInfo() {
        }
        void simulate(string techTemp) {
                stringstream techTemplate;
                techTemplate << techTemp;
                techTemplate << "<ocn>\n\
RVP_SA\n\
</ocn>\n";
                stringstream newTempPath;
                newTempPath << tasePath << "/template/RVP_SA_" << tech << ".ini";
                ofstream ofile(newTempPath.str().c_str());
                ofile << techTemplate.str() << endl;
                ofile.close();
                runTASE(newTempPath.str());
		moveResults("SA");	
        }
        void extractOutput() {
                stringstream sst;
                ifstream fileHandle;
                string dummy;

                fileHandle.open("../results/SA/RVP_SA/datar.txt");
                if(!fileHandle.is_open()) {
			cerr << "Error: Can't open output file \n ../results/SA/RVP_SA/datar.txt" << endl;
			exit(1);
		}
		sst << fileHandle.rdbuf();
                sst >> dummy >> dummy >> energy_SA >> delay_SA;
                fileHandle.close();
        }
        void setInput(userInput& uImp) {
                input = &uImp;
                tasePath = input->TASEpath;
                tech = input->technology;
        }
	float getDelay() {
		return delay_SA;
	}
	float getEnergy() {
		return energy_SA;
	}
        void print() {
           cout << "tasePath " << tasePath <<  endl;
	   cout << "energy_SA= " << energy_SA << "\n delay_SA= " << delay_SA << endl;
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
                techTemplate << "<ocn>\n\
RVP_Decoder\n\
</ocn>\n";
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

                sst_path << "../results/RD/RVP_Decoder/output_" << nRows << ".txt";
                fileHandle.open(sst_path.str().c_str());
                if(!fileHandle.is_open()) {
			cerr << "Error: Can't open output file \n" << sst_path << endl;
			exit(1);
		}
		sst << fileHandle.rdbuf();
		string str = sst.str();
		
		regex_t re; 
		size_t     nmatch = 3;
		regmatch_t pmatch[3];

		char *pattern = "[^\n]*\n[^\n]*\n[^\n]*\n[^\n]*\n[^\n]*\n[ \t]*[^ \t]+[ \t]*[^ \t]+[ \t]*[^ \t]+[ \t]*([^ \t]+)[ \t]*([^ \t]+)";
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
// should be included somehow
class colMux : public SRAMSubblock {
        private:

        public:
        colMux() {
        }
        colMux(userInput& uInp) {
        }
        ~colMux() {
        }
        void simulate(string techTemp) {
                stringstream techTemplate;
                techTemplate << techTemp;
                techTemplate << "<ocn>\n\
RVP_Bank_Mux\n\
</ocn>\n";
                stringstream newTempPath;
                newTempPath << tasePath << "/template/RVP_CM_" << tech << ".ini";
                ofstream ofile(newTempPath.str().c_str());
                ofile << techTemplate.str() << endl;
                ofile.close();
                runTASE(newTempPath.str());
		moveResults("CM");
        }
        void setInput(userInput& uImp) {
                input = &uImp;
                tasePath = input->TASEpath;
                tech = input->technology;
        }
};
class bitCell : public SRAMSubblock {
        private:
	float vdd;
	float memSize;

	// Separate them & Add Precharge-Class
	float delay_bitcell_r;
	float delay_pch_r;
	float energy_bitcell_r;
	float energy_pch_r;

	// Not getting this one
	// Do you use pre-charge during write?
	// thought the write driver do it!
	float delay_pch_w;
	float delay_writeDriver;
	float delay_bitcell_w;
	float energy_pch_w;
	float energy_bitcell_w;
	float energy_writeDriver;
	
	float leakage_power;
	
        public:
        bitCell() {
        }
        bitCell(userInput& uInp) {
        }
        ~bitCell() {
        }
        void simulate(string techTemp) {
                // Find ldef and wdef
		regex_t re; 
		regmatch_t pmatch[2];

		char *pattern1 = "[ \t]*<ldef>[ \t]*([0-9]+)[ \t]*n";
		regcomp(&re, pattern1, REG_EXTENDED); 
		regexec(&re, techTemp.c_str(), 2, pmatch, 0); 
		int ldef = atoi(techTemp.substr(pmatch[1].rm_so, pmatch[1].rm_eo - pmatch[1].rm_so).c_str());
		regfree(&re); 

		char *pattern2 = "[ \t]*<wdef>[ \t]*([0-9]+)[ \t]*n";
		regcomp(&re, pattern2, REG_EXTENDED); 
		regexec(&re, techTemp.c_str(), 2, pmatch, 0); 
		int wdef = atoi(techTemp.substr(pmatch[1].rm_so, pmatch[1].rm_eo - pmatch[1].rm_so).c_str());
		regfree(&re); 

		stringstream techTemplate;
                techTemplate << techTemp;
		// Add PCH parameters
                int pcRatio =  6;
		if(input->PCratio != -1) {
			pcRatio = input->PCratio; 
		}
		techTemplate << "<wpc> " << pcRatio*wdef*1e-9 << "\n<lpc> " << ldef*1e-9 << endl;

                int wlRatio =  1;
		if(input->WLratio != -1) {
			wlRatio = input->WLratio; 
		}
		techTemplate << "<WLratio> " << wlRatio << endl;

                // Add BC Tests
                techTemplate << "\n<scs>\n\
RVP_Ileak_PU\n\
RVP_Ileak_PD\n\
RVP_Ileak_PG\n\
</scs>\n\
\n\
<ocn>\n\
RVP_CD\n\
</ocn>\n";
                stringstream newTempPath;
                newTempPath << tasePath << "/template/RVP_BC_" << tech << ".ini";
                ofstream ofile(newTempPath.str().c_str());
                ofile << techTemplate.str() << endl;
                ofile.close();
                runTASE(newTempPath.str());
		moveResults("BC");
        }
	void extractOutput() {
                stringstream sst;
                ifstream fileHandle;
                string dummy;
                fileHandle.open("../results/BC/RVP_CD/datar.txt");
                if(!fileHandle.is_open()) {
			cerr << "Error: Can't open output file \n ../results/BC/RVP_CD/datar.txt" << endl;
			exit(1);
		}
                sst << fileHandle.rdbuf();
                sst >> dummy >> dummy >> dummy >> delay_bitcell_r >> delay_pch_r >> energy_pch_r >> energy_bitcell_r;
                fileHandle.close();

                sst.clear();
		sst.str("");

                fileHandle.open("../results/BC/RVP_CD/dataw.txt");
                if(!fileHandle.is_open()) {
			cerr << "Error: Can't open output file \n ../results/BC/RVP_CD/dataw.txt" << endl;
			exit(1);
		}
                sst << fileHandle.rdbuf();
                sst >> dummy >> dummy >> dummy >> delay_pch_w >> delay_writeDriver >> delay_bitcell_w >> energy_pch_w >> energy_bitcell_w >> energy_writeDriver;
                fileHandle.close();


                // Take it from the input
                //int vdd = 1; 
                //int memSize = 512;

		// Re-visit Leakage Calculations!!
		// Is it Vdd or Vth
			
                float iOffPg,iOffPu, iOffPd;

                sst.clear();
		sst.str("");

	        // Pass-gate leakage
                fileHandle.open("../results/BC/RVP_Ileak_PG/DAT/dc_N1_NX_d.dat");
                if(!fileHandle.is_open()) {
			cerr << "Error: Can't open output file \n ../results/BC/RVP_Ileak_PG/DAT/dc_N1_NX_d.dat" << endl;
			exit(1);
		}
		sst << fileHandle.rdbuf();
                sst >> iOffPg; 
                fileHandle.close();

                sst.clear();
		sst.str("");

                // Pull-up leakage
                fileHandle.open("../results/BC/RVP_Ileak_PU/DAT/dc_P1_PX_d.dat");
                if(!fileHandle.is_open()) {
			cerr << "Error: Can't open output file \n ../results/BC/RVP_Ileak_PU/DAT/dc_P1_PX_d.dat" << endl;
			exit(1);
		}
                sst << fileHandle.rdbuf();
                sst >> iOffPu; 
                fileHandle.close();

                sst.clear();
		sst.str("");

                // Pull-down leakage
                fileHandle.open("../results/BC/RVP_Ileak_PD/DAT/dc_N1_NX_d.dat");
                if(!fileHandle.is_open()) {
			cerr << "Error: Can't open output file \n ../results/BC/RVP_Ileak_PD/DAT/dc_N1_NX_d.dat" << endl;
			exit(1);
		}
                sst << fileHandle.rdbuf();
                sst >> iOffPd; 
                fileHandle.close();

                leakage_power=(iOffPu+iOffPg+iOffPd)*memSize*vdd;
	}
	void print() {
	        cout << "tasePath " << tasePath <<  endl;
                cout << "delay_bitcell_r= "  << delay_bitcell_r << "\n energy_bitcell_r = " << energy_bitcell_r << endl;
		cout << "delay_pch_r= " << delay_pch_r << "\n energy_pch_r " << energy_pch_r << endl;
		cout << "delay_pch_w= " << delay_pch_w << "\n energy_pch_w= " << energy_pch_w << endl;
		cout << "delay_writeDriver= " << delay_writeDriver << "\n energy_writeDriver= " << energy_writeDriver << endl;
		cout << "delay_bitcell_w= " << delay_bitcell_w << "\n energy_bitcell_w= " << energy_bitcell_w << endl;
		cout << "leakage= " << leakage_power << endl;
	}
        void setInput(userInput& uImp) {
                input = &uImp;
                tasePath = input->TASEpath;
                tech = input->technology;
        	vdd = input->vdd;
		memSize = input->memory_size;
	}
	float getBCRDelay() {
		return delay_bitcell_r;
	}
	float getBCREnergy() {
		return energy_bitcell_r;
	}
	float getBCWDelay() {
		return delay_bitcell_w;
	}
	float getBCWEnergy() {
		return energy_bitcell_w;
	}
	float getPCRDelay() {
		return delay_pch_r;
	}
	float getPCREnergy() {
		return energy_pch_r;
	}
	float getPCWDelay() {
		return delay_pch_w;
	}
	float getPCWEnergy() {
		return energy_pch_w;
	}
	float getWDDelay() {
		return delay_writeDriver;
	}
	float getWDEnergy() {
		return energy_writeDriver;
	}
	float getBCLeakage() {
		return leakage_power;
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

                fileHandle.open("../results/TB/RVP_TIMING/data.txt");
                if(!fileHandle.is_open()) {
			cerr << "Error: Can't open output file \n ../results/TB/RVP_TIMING/data.txt" << endl;
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

// Needs to separate the driver
// from the SRAM bitcell test
class writeDriver : public SRAMSubblock {
        private:
        public:
        writeDriver() {
        }
        writeDriver(userInput& uInp) {
        }
        ~writeDriver() {
        }
        // Currently with the BC
        void simulate(string techTemp) {
        }
        void setInput(userInput& uImp) {
                input = &uImp;
                tasePath = input->TASEpath;
                tech = input->technology;
        }
};

// Q: Why colMux is ignored?
// Q: Why energy is ignored in bankmux?
class bankMux : public SRAMSubblock {
        private:

	float delay_bankSelect;
	float delay_bankOutput;

        public:
        bankMux() {
        }
        bankMux(userInput& uInp) {
        }
        ~bankMux() {
        }
        void simulate(string techTemp) {
                stringstream techTemplate;
                techTemplate << techTemp;
                techTemplate << "<ocn>\n\
RVP_Bank_Mux\n\
</ocn>\n";
                stringstream newTempPath;
                newTempPath << tasePath << "/template/RVP_BM_" << tech << ".ini";
                ofstream ofile(newTempPath.str().c_str());
                ofile << techTemplate.str() << endl;
                ofile.close();
                runTASE(newTempPath.str());
                moveResults("BM");
        }
	void extractOutput() {
                stringstream sst;
                ifstream fileHandle;
                string dummy;

                fileHandle.open("../results/BM/RVP_Bank_Mux/data.txt");
                sst << fileHandle.rdbuf();
                sst >> dummy >> dummy >> dummy >> delay_bankSelect >> delay_bankOutput;
                cout << fileHandle.good() << " - delay_bankSelect " << delay_bankSelect << " delay_bankOutput " << delay_bankOutput << endl;
                fileHandle.close();
        }
        void setInput(userInput& uImp) {
                input = &uImp;
                tasePath = input->TASEpath;
                tech = input->technology;
        }
	void print() {
	        cout << "tasePath= " << tasePath <<  endl;
		cout << "delay_bankSelect= " << delay_bankSelect << "\n delay_bankOutput= " << delay_bankOutput << endl;
	}
	float getBankSelectDelay() {
		return delay_bankSelect;
	}
	float getBankOutputDelay() {
		return delay_bankOutput;
	}
};
