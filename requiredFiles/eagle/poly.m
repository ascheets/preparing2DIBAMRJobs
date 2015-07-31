classdef poly
    properties
        
        %coefficients for polynomial
        a0
        a1
        a2
        a3
        
        %bounds of polynomial
        lowerBound
        upperBound
        
        %spacing between points to be plotted
        step
    
        %offset within channel
        initialX
        
        %angle of attack
        aoa
        
        %chord length
        c
        
        
    end
    
    methods
        function this = poly(coeffs, lowerBound, upperBound, step, initialX, aoa)
            
            this.a0 = coeffs(1);
            this.a1 = coeffs(2);
            this.a2 = coeffs(3);
            this.a3 = coeffs(4);
            
            this.lowerBound = lowerBound;
            this.upperBound = upperBound;
            
            this.step = step;
            
            this.initialX = initialX;
    
            this.aoa = aoa * pi/180;
            
            this.c = 0.03;
        end
        
        function this = writeVertices(this)
            
            R = [cos(this.aoa) -sin(this.aoa); sin(this.aoa) cos(this.aoa)]; 
            
            %open the file to write to
            vertex_fid = fopen(['naca2D_' num2str(512) '.vertex'], 'a+');
            
            x = this.lowerBound;
            
            while x < this.upperBound + this.initialX
               
                 %EQUATION FOR POLYNOMIAL DEFINING UPPER SURFACE
                 y = this.a3*x^3 + this.a2*x^2 + this.a1*x + this.a0;
                 
                 %COORDINATES
                 X(1) = this.initialX + x;
                 X(2) = y;
                 
                 %TRANSFORM FOR ANGLE OF ATTACK
                 centerPoint = this.initialX + (this.c)/2;
                 centerPoint(2) = 0;
                 
                 X = X-centerPoint;
                 X = X*R;
                
                 %PLOT THE POINT
                 plot(X(1),X(2),'*r')
                 
                 %WRITE THE COORDINATES TO THE VERTEX FILE
                 fprintf(vertex_fid, '%1.16e %1.16e\n', X(1), X(2));
                 
                 x = x + this.step;

            end
        end
    end
end
