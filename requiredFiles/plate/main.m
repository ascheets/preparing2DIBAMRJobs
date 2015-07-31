function main(attackAngle) 

%generates .vertex, .target, etc files

numberNodes = 638;

%open the file to write to
vertex_fid = fopen(['naca2D_' num2str(512) '.vertex'], 'w');

%first line is the number of vertices in the file
fprintf(vertex_fid, '%d\n', numberNodes);

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
axis([-0.05,0.05,-.02,.02]); %for plotting

%WRITE VERTICES FOR SET OF POLYNOMIALS DEFINING CROSS SECTION

%poly1

a1 = 0.0005;
a2 = 0;
a3 = 0;
a4 = 0;

coeffs(1) = a1;
coeffs(2) = a2;
coeffs(3) = a3;
coeffs(4) = a4;

lowerBound = 0;
upperBound = 0.03;

poly1 = poly(coeffs, lowerBound, upperBound, step, initialX, aoa);
poly1.writeVertices(); %lower major curve

%poly2

a1 = -0.0005;
a2 = 0;
a3 = 0;
a4 = 0;

coeffs(1) = a1;
coeffs(2) = a2;
coeffs(3) = a3;
coeffs(4) = a4;

lowerBound = 0;
upperBound = 0.03;

poly2 = poly(coeffs, lowerBound, upperBound, step, initialX, aoa);
poly2.writeVertices(); %upper major curve

%strLine1

xPos = -0.015;
lowerBound = -0.0005;
upperBound = 0.0005;

strLine1 = strLine(xPos, lowerBound, upperBound, step, aoa);
strLine1.writeVertices();

%strLine2

xPos = 0.015;
lowerBound = -0.0005;
upperBound = 0.0005;

strLine2 = strLine(xPos, lowerBound, upperBound, step, aoa);
strLine2.writeVertices();

%finish plot
hold off;

%close the .vertex file
fclose(vertex_fid);

%WRITE .TARGET FILE

targetForce = 1.0e2;

target_fid = fopen(['naca2D_' num2str(512) '.target'], 'w');

fprintf(target_fid, '%d\n', numberNodes);

for s = 0:numberNodes-1
   
    fprintf(target_fid, '%d %1.16e\n', s, targetForce);
    
end

fclose(target_fid);



