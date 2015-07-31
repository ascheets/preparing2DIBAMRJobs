function [CL,CD,Re] = dataread2()

close all
clear all
clc

path_name=pwd; %Path name to the folder of interest

starting_time=1000; %First time step to be included in data analysis

time_step=1000; %Interval between outputted time steps (this should match the interval in the input2d file)

final_time=800000; %Final time step to be included in data analysis

timestep=5.0e-5;

GridSize=512; %IBAMR fluid grid size
Stroke='NACA2412'; %Description of stroke type (ex. 'FruitFly' or 'alpha=90, beta=0')

density = 1000; %fluid dynamic density (from IBAMR)
velocity = 0.1; %m/s^2
length = 0.03; %m (characteristic length)
mu = 0.001; %dynamic viscosity

Re = (density*velocity*length)/mu %Reynolds number of the simulation

%LOOP THAT EXTRACTS FORCE DATA FROM HIER_DATA

    for i=1:1
        
        n=1; 
        
        for k=starting_time:time_step:final_time
            
            if n < 10
                %This line opens the file of interest and gives it an FileID #
                fileID = fopen([path_name '/hier_data_IB2d/F.0' num2str(k)]);  
                
                %Scans the file for numbers (skipping 'Processor' lines) and puts them in a cell called C
                C = textscan(fileID,'%f','HeaderLines',3,'delimiter',' ','commentstyle','P'); 
                
                %Converts cell C to matrix A
                A = C{1}; 
                
                %close the FileID #
                fclose(fileID); 
                
                %note that force is the "non-dimensional" force, or force
                %coefficient.
                
                %This is the horizontal force (odd numbered entries in vector C)
                force(n,1)=-2*sum(A(1:2:end))/(density*velocity^2*length); 
                
                %This is the vertical force (even numbered entries in vector C)
                force(n,2)=-2*sum(A(2:2:end))/(density*velocity^2*length); 
                
                %Increase n by 1, so that we can enter the next forces on the next row
                n=n+1; 
                
            else
                %This line opens the file of interest and gives it an FileID #
                fileID = fopen([path_name '/hier_data_IB2d/F.' num2str(k)]);  
                
                %Scans the file for numbers (skipping 'Processor' lines) and puts them in a cell called C
                C=textscan(fileID,'%f','HeaderLines',3,'delimiter',' ','commentstyle','P'); 
                
                %Converts cell C to matrix A
                A=C{1}; 
                
                %close the FileID #
                fclose(fileID); 
                
                %note that force is the "non-dimensional" force, or force
                %coefficient.
                
                %This is the horizontal force (odd numbered entries in vector C)
                force(n,1)=-2*sum(A(1:2:end))/(density*velocity^2*length);
                
                %This is the vertical force (even numbered entries in vector C)
                force(n,2)=-2*sum(A(2:2:end))/(density*velocity^2*length); 
                
                %Increase n by 1, so that we can enter the next forces on the next row
                n=n+1; 
            end
        end
        clear A
        clear C     
    end

time=(starting_time:time_step:final_time)*timestep;    

%force data smoothed
force_smooth(:,1)=smooth(force(:,1),9);
force_smooth(:,2)=smooth(force(:,2),9);


figure

subplot(1,2,1)

hold on

%plot of horizontal force over time
plot(time,force(:,1),'c-','LineWidth',2)

%plot of vertical force over time
plot(time,force(:,2),'m-','LineWidth',2)

%plot of smoothed horizontal force over time
plot(time,force_smooth(:,1),'k-','LineWidth',2)

%plot of smoothed vertical force over time
plot(time,force_smooth(:,2),'k-','LineWidth',2)

%plot horizontal line at y = 0
x=[0,40]; y=[0,0]; plot(x,y,'k-')

%plot details
title(['Non-Dimensional Force Coefficients over Time'],'FontSize',12,'FontName','Arial')
xlabel('Time','FontSize',12)
ylabel('Non-Dimensional Force','FontSize',12)
legend('Horizontal','Vertical')
axis([0 40 -6 6])


%PLOT 2
subplot(1,2,2)

%for second figure, plot vertical force vs horizontal
plot(force(:,1),force(:,2), 'b*')

%plot details
title(['Coefficient of Lift vs Coefficient of Drag'],'FontSize',12,'FontName','Arial')
xlabel('Non-Dimensional Horizontal Force','FontSize',12)
ylabel('Non-Dimensional Vertical Force','FontSize',12)

%find average coefficient of drag
CD = mean(force(:,1))

%find average coefficient of lift
CL = mean(force(:,2))


%save the plots as a png
saveas(gcf, 'Force_over_time', 'png')