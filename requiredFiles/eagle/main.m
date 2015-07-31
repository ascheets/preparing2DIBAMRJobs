function main(attackAngle) 

%generates .vertex, .target, etc files

numberNodes = 618;

%open the file to write to
vertex_fid = fopen(['naca2D_' num2str(512) '.vertex'], 'w');

%first line is the number of vertices in the file
fprintf(vertex_fid, '%d\n', numberNodes - 1);

%general information

%these parameters should match the input2d file in this directory
L = 0.1; %Length of computational domain
maxLevels = 3; %max number of levels in locally refined grid
refRatio = 4; %refinement ratio between levels
N = 32; %actual number of grid cells on coarsest grid level
finest = (refRatio^(maxLevels-1))*N; %effective number of grid cells on
                                     %finest gird level

dx = (1.0*L)/finest; %spacing for eulerian points
                                     
step = dx/2; %spacing for lagrangian points

initialX = 0; %displacement within channel

aoa = attackAngle; %set angle of attack

hold on; %for plotting polynomials
axis([-0.02,0.02,-.02,.02]); %for plotting

%WRITE VERTICES FOR SET OF POLYNOMIALS DEFINING CROSS SECTION

%poly1

a1 = 0.0011623;
a2 = 0.58440583;
a3 = -38.215532;
a4 = 587.250803;

coeffs(1) = a1;
coeffs(2) = a2;
coeffs(3) = a3;
coeffs(4) = a4;

lowerBound = 0.002;
upperBound = 0.03;

poly1 = poly(coeffs, lowerBound, upperBound, step, initialX, aoa);
poly1.writeVertices(); %lower major curve

%poly2

a1 = 0.00274959;
a2 = 0.6297824;
a3 = -48.058399;
a4 = 813.480322;

coeffs(1) = a1;
coeffs(2) = a2;
coeffs(3) = a3;
coeffs(4) = a4;

lowerBound = 0.0015;
upperBound = 0.03;

poly2 = poly(coeffs, lowerBound, upperBound, step, initialX, aoa);
poly2.writeVertices(); %upper major curve

%poly3

a1 = 0.00101549;
a2 = 0.53652211;
a3 = 45.8653851;
a4 = -12518.758;

coeffs(1) = a1;
coeffs(2) = a2;
coeffs(3) = a3;
coeffs(4) = a4;

lowerBound = 0.0005;
upperBound = 0.002;

poly3 = poly(coeffs, lowerBound, upperBound, step, initialX, aoa);
poly3.writeVertices(); %lower minor curve

%poly4
a1 = 0.00205288;
a2 = 1.36481185;
a3 = -206.91772;
a4 = 10132.6482;

coeffs(1) = a1;
coeffs(2) = a2;
coeffs(3) = a3;
coeffs(4) = a4;

lowerBound = 0;
upperBound = 0.0015;

poly4 = poly(coeffs, lowerBound, upperBound, step, initialX, aoa);
poly4.writeVertices(); %upper minor curve

%poly5
a1 = 0.00173061;
a2 = -2.462876;
a3 = 3597.01671;
a4 = -1335505.7;

coeffs(1) = a1;
coeffs(2) = a2;
coeffs(3) = a3;
coeffs(4) = a4;

lowerBound = 0;
upperBound = 0.0005;

poly5 = poly(coeffs, lowerBound, upperBound, step, initialX, aoa);
poly5.writeVertices(); %curve for the tip

%finish plot
hold off;

%close the .vertex file
fclose(vertex_fid);

%WRITE .TARGET FILE

targetForce = 1.0e2;

target_fid = fopen(['naca2D_' num2str(512) '.target'], 'w');

fprintf(target_fid, '%d\n', numberNodes - 1);

for s = 0:numberNodes-1
   
    fprintf(target_fid, '%d %1.16e\n', s, targetForce);
    
end

fclose(target_fid);



