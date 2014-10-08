%%%%%%%%%%%%%%%%%%%%%%
% SRAM top-level class
%%%%%%%%%%%%%%%%%%%%%%

classdef SRAM_Top < SRAM_Component

	properties
        	iOffPu;
        	iOffPd;
        	iOffPg;
		IO;
		CD;
		SA;
		Decoder;
		Bitcell;
		Timing;
	end
	
	methods
	% Constructor
		function obj = SRAM_Top(toolPath,tasePath,uid)
			obj = obj@SRAM_Component(toolPath,tasePath,uid);
			obj.IO = SRAM_IO(toolPath,tasePath,uid);
			obj.CD = SRAM_CD(toolPath,tasePath,uid);
			obj.SA = SRAM_SA(toolPath,tasePath,uid);
			obj.Decoder = SRAM_Decoder(toolPath,tasePath,uid);
			obj.Bitcell = SRAM_Bitcell(toolPath,tasePath,uid);
			obj.Timing = SRAM_Timing(toolPath,tasePath,uid);
			
			vdd = load(strcat(obj.tasePath,'/device/BIN/',obj.uid,'/RVP_Ileak_PD/DAT/dc_dc.dat'));
			[minDiff, i] = min(abs(vdd-obj.vdd));
			load(strcat(obj.tasePath,'/device/BIN/',obj.uid,'/RVP_Ileak_PG/DAT/dc_N1_NX_d.dat'));
			obj.iOffPg = dc_N1_NX_d(i);
			load(strcat(obj.tasePath,'/device/BIN/',obj.uid,'/RVP_Ileak_PD/DAT/dc_N1_NX_d.dat'));
			obj.iOffPd = dc_N1_NX_d(i);
			load(strcat(obj.tasePath,'/device/BIN/',obj.uid,'/RVP_Ileak_PU/DAT/dc_P1_PX_d.dat'));
			obj.iOffPu = abs(dc_P1_PX_d(i));
		end     
		
        % Energy
	        function [eRd eWr] = E(obj)
			%Common terms
			edec = obj.Decoder.E;
			etmng = obj.Timing.E;
			
			[tminRd tminWr] = obj.D;
			elkg = obj.rows*obj.cols*obj.vdd*tminWr*(obj.iOffPg + obj.iOffPd + obj.iOffPu);
			%Write
			eio = obj.IO.E(1);
			ecd = obj.CD.E(1);
			esach = obj.SA.E(1);	
			ebcwr = obj.Bitcell.E(1);
			
			eWr = edec+eio+ecd+esach+ebcwr+etmng+elkg;
						
			%debug data
			fid = fopen(strcat(obj.toolPath,'/files/debugEnergyWrt.txt'),'w');
			fprintf(fid,'Decoder(erowdec) = %e\n',edec);
			fprintf(fid,'IO(eio) = %e\n',eio);
			fprintf(fid,'CD(ecd) = %e\n',ecd);	
			fprintf(fid,'SA(esach) = %e\n',esach);
			fprintf(fid,'Bitcell(ebcwr) = %e\n',ebcwr);
			fprintf(fid,'Timing(etmng) = %e\n',etmng);
			fprintf(fid,'Leakage(elkg) = %e\n',elkg);
			fprintf(fid,'Energy per write = %e\n',eWr);												
			fclose(fid);

			%Read
			eio = obj.IO.E(0);
			ecd = obj.CD.E(0);
			esa = obj.SA.E(0);
			ebcrd = obj.Bitcell.E(0);
			
			elkg = obj.rows*obj.cols*obj.vdd*tminRd*(obj.iOffPg + obj.iOffPd + obj.iOffPu);
			       
			eRd = edec+eio+ecd+esa+ebcrd+etmng+elkg;
			
			%debug data
			fid = fopen(strcat(obj.toolPath,'/files/debugEnergyRd.txt'),'w');
			fprintf(fid,'Decoder(erowdec) = %e\n',edec);
			fprintf(fid,'IO(eio) = %e\n',eio);
			fprintf(fid,'CD(ecd) = %e\n',ecd);	
			fprintf(fid,'SA(esa) = %e\n',esa);
			fprintf(fid,'Bitcell(ebcrd) = %e\n',ebcrd);
			fprintf(fid,'Timing(etmng) = %e\n',etmng);			
			fprintf(fid,'Leakge(elkg) = %e\n',elkg);	
			fprintf(fid,'Energy per read = %e\n',eRd);
			fclose(fid);
			
			if (obj.getMetrics == 0)
				dlmwrite(strcat(obj.toolPath,'/files/Energy_rows.txt'),eWr);
			end

			obj.energy = [eRd eWr];

        	end
		
        % Delay
        	function [tminRd tminWr] = D(obj)
			% Common terms
			ddec = obj.Decoder.D;

			% Write
			dio = obj.IO.D(1);
			dcdch = obj.CD.D(1);
			dsach = obj.SA.D(1);	
			dbcwr = obj.Bitcell.D;
			tminWr = max([dio ddec dcdch dsach],[],2) + dbcwr;
						
			%debug data
			fid = fopen(strcat(obj.toolPath,'/files/debugDelayWrt.txt'),'w');
			fprintf(fid,'IO(dio) =  %e\n',dio);
			fprintf(fid,'Predecode(drowdec) = %e\n',ddec);
			fprintf(fid,'CD(dcdch) =  %e\n',dcdch);	
			fprintf(fid,'SA(dsach) =  %e\n',dsach);
			fprintf(fid,'Bitcell(dbcwr) =  %e\n',dbcwr);
			fprintf(fid,'Tmin Write = %e \n', tminWr);
			fclose(fid);
			
			% Read
			dio = obj.IO.D(0);
			dbldr = obj.CD.D(0);
			dsa = obj.SA.D(0);
			
			tminRd = max([dio ddec],[],2) + dbldr + dsa;
			
			%debug data
			fid = fopen(strcat(obj.toolPath,'/files/debugDelayRd.txt'),'w');
			fprintf(fid,'IO(dio) =  %e\n',dio);
			fprintf(fid,'Predecode(drowpre) = %e\n',ddec);
			fprintf(fid,'CD(dbldr) =  %e\n',dbldr);
			fprintf(fid,'SA(dsa) = %e\n',dsa);
			fprintf(fid,'Tmin Read = %e \n', tminRd);
			fclose(fid);

			obj.delay = [tminRd tminWr];
			
			if (obj.getMetrics == 0)
				dlmwrite(strcat(obj.toolPath,'/files/Delay_rows.txt'),tminRd);
			end
       		end

     	end
end
