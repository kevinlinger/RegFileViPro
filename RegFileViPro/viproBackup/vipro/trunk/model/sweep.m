dcon = 0.3;
delete('output.txt');
while (dcon <= 3)
    optimizeBruteForce(0, dcon*1e-9);
    dcon = dcon+0.05;
end

