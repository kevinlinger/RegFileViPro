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
	    int WLratio = 2;
	    float SAoffset = 0.15; 
	    int PCratio = 2;

	    while (iteration < 1e2 && rMoves < 5) {

	        ++iteration;
    
	        // Get a new b,r,c 
		int lock = 0;
		int itr = 0;
		while(1) {
			cout << "\n\n b " << b << " r = " << r << " c = " << c <<  "\n";
			++itr;
			if(itr > 1e2) {
			   cout << "Exceed max number of substitutions" << endl;
			   //lock = 1;
			}
			int ran = int(rand() % 3);
			if(ran == 0) {
				WLratio = changeWLratio();
	
			} else if(ran ==1) {
				PCratio = changePCratio();			
			
			} else if(ran == 2) {
				SAoffset = changeSAoffset();
			}
			if(!tryComb(WLratio, SAoffset, PCratio)) {
				break;
			}
		}
		// Store hash to avoid re-iteration
		hash = WLratio*100 + PCratio*10 + SAoffset;

		//cout << "Calculated Hash = " << hash << endl;
		hList.push_back(hash);
		//cout << "DONE nb = "  << nb << " nr = " <<  nr << " nc = " << nc << endl;
       	 
		// Change input
		// Call Simulate
		// Get Energy/Delay
		float energy, delay;
		//energy = en[hash];
		//delay = del[hash];

		inputHandle.WLratio = (int)WLratio; 
		inputHandle.PCratio = (int)PCratio;
		inputHandle.SAoffset = (int)SAoffset;
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
