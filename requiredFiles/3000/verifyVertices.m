%MAKE SURE THE VERTICES CREATE THE GEOMETRY WE WANT

fileID = fopen('naca2D_512.vertex', 'rt');

fgets(fileID); %Ignore first line?

formatSpec = '%1.16e %1.16e\n';

sizeA = [2 Inf];

A = fscanf(fileID, '%e', sizeA);

A = A';

hold on;

plot(A(:,1),A(:,2),'r*')

axis([-0.05,0.15,-.05,.05]);

hold off;

fclose(fileID);
