function optimizeBruteForce(Econ, Dcon)

% Constraints got from function argument. Function argument is got from
% user.m. xcon=0 means minimize x for the given constraint on the y.
% Econ = 0;
% Dcon = 2;

% Get memory capacity from constructor
%constructor;

% Starting the search for best R,C from R=8, as lower values are
% unrealistic. Search is restricted to R and C both being at least 8. Also
% the column muxing is restricted to <=4. So NC <=4*word_size.
% Correspondingly NR >= mem_size/4*word_size. Also, NC >= word-size. So,
% NR<=mem_size/word-size
%NR = max(Memory_Size./(4*Word_Size), 8);
Memory_Size=8096;
Word_Size=16;
NR = 8;
NC = Memory_Size./NR;
opt_R = 0;
opt_C = 0;
minE = realmax;
minD = realmax;
fout = fopen('output.txt', 'a');
% The end point for the search is when NC = 8 i.e. NR <= mem_size/8
while (NR <= min(Memory_Size/8,Memory_Size/Word_Size))
    
    % Create SRAM object for write and read and find their energies and
    % delays. Keep track of NR and NC for which the wc energy and delay is
    % the best.
    %fprintf(fout, 'Now Examining array with %d rows and %d cols\n',NR, NC);
    % Get E and D for read and write
    SRAM = SRAM_Top(1,NR,NC);
    SRAM.D;
    SRAM.E;
    Energy_Write = SRAM.Energy(1);
    Delay_Write = SRAM.Delay(1);
    SRAM = SRAM_Top(0,NR,NC);
    SRAM.D;
    SRAM.E;
    Energy_Read = SRAM.Energy(1);
    Delay_Read = SRAM.Delay(1);
    
    % Get worst case E and D
    Energy = max(Energy_Read, Energy_Write);
    Delay = max(Delay_Read, Delay_Write);
    
    % Check if the R-C combination satisfies the required constraint
    if (Econ == 0) % implies we need to check if delay constraint is satisfied
        if (Delay > Dcon) % This combination of R, C is ruled out. Go to next iteration of while loop
            %fprintf(fout, '%d rows and %d cols does not satisfy delay constraint\n',NR, NC);
            % Increment and Decrement R and C by multiples of 2.
            NR = NR*2;
            NC = NC/2;
            continue;
        elseif (Energy < minE)
            minE = Energy;
            minD = Delay;
            opt_R = NR;
            opt_C = NC;
        end
    end
    
    if (Dcon == 0) 
        if (Energy > Econ)
            %fprintf(fout, '%d rows and %d cols does not satisfy energy constraint\n',NR, NC);
            % Increment and Decrement R and C by multiples of 2.
            NR = NR*2;
            NC = NC/2;
            continue;
        elseif (Delay < minD)
            minE = Energy;
            minD = Delay;
            opt_R = NR;
            opt_C = NC;
        end
    end
       
    % Increment and Decrement R and C by multiples of 2.
    NR = NR*2;
    NC = NC/2;
end

% Print results for opt R and C to file

if (opt_R ~= 0)
    fprintf(fout, '%e\t%d\t%d\t%e\t%e\n', Dcon, opt_R, opt_C, minE, minD);
else
    % fprintf(fout, 'No Solution Exists for Given Constraints. Please relax the constraints and try again\n');
end
fclose(fout);
