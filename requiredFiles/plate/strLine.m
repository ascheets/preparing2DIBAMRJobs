classdef strLine
    properties
        
        %position of line on x axis
        xPos
        
        %upper bound on y axis
        upperBound
        
        %lower bound
        lowerBound
  
        %step
        step
        
        %aoa
        aoa
    
    end
    
    methods
        function this = strLine(xPos, lowerBound, upperBound, step, aoa)
            
            this.xPos = xPos;
            this.upperBound = upperBound;
            this.lowerBound = lowerBound;
            this.step = step;
            this.aoa = aoa * pi/180;
        end
        
        function this = writeVertices(this)
            
            R = [cos(this.aoa) -sin(this.aoa); sin(this.aoa) cos(this.aoa)]; 
            
            %open the file to write to
            vertex_fid = fopen(['naca2D_' num2str(512) '.vertex'], 'a+');
           
            y = this.lowerBound;
            
            while y < this.upperBound
                
                %COORDINATES
                X(1) = this.xPos;
                X(2) = y;
                
                %TRANSFORM FOR ANGLE OF ATTACK
                centerPoint(1) = 0;
                centerPoint(2) = this.lowerBound + ((this.upperBound - this.lowerBound)/2);
                
                X = X - centerPoint;
                X = X*R;
                
                %PLOT THE POINT
                plot(X(1),X(2),'*r')
                
                %WRITE THE COORDINATES TO THE VERTEX FILE
                fprintf(vertex_fid, '%1.16e %1.16e\n', X(1), X(2));
           
                %UPDATE Y
                y = y + this.step;
            end
        end
    end
end
