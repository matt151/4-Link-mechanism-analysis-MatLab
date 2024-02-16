%NOTE this Template file is intended to help you with your crank slider
%position calculations. It will not run without being appropriately  edited
 
% Slider crank mechanism position solved using complex algebra loop closure solution
close all; 
clear;  
 
% Define known parameters
%dimensions
r2 =   0.026 %short bar - crankshaft diameter = 43.2 mm = radius - length of bar is 22.6mm 
r3 =   0.145 %long bar - connecting rod 145mm (m) 
Ax =     0 %crank centre position x (m)
Ay =     0 %crank centre position y (m)
theta2_initial = 10 %initial crank angle wrt x axis (radians)
theta2d= 100 %crank angular velocity (radians/sec) 

%plot parameters and counter 
a = 10;% title font size 
i =0;% initial time integer 

%piston head plot 
ps = 0.085; %sets the width/height dimension of the piston "box" - the cylider on a real piston - based off a diameter of 85mm for a piston head 

%Coupler movement tracker 
BP = 0.05; % tracks the couplers (connecting rod) movement 
theta_5 = 0.4; % angle measurement needed to track coupler movement.

%set the plot handles
figure(1); hold on; 
h3 = text(-1,-1,'0'); % sets the position of the time 
h4 = patch([0 0 0 0 ],[0 0 0 0],'k-') %plots the piston box patch() prints a polygon
h1 = plot([ 0 0 0 ] , [ 0 0 0 ] ,'ro','markerfacecolor',[0 0 0]); %plots the red dots/ can make it a square for fun using s 3 dots
h2 = plot([ 0 0 0 ] , [ 0 0 0 ] ,'o-','linewidth',4); %plots the links (blue, thick lines) 3 lines 

%Plot tracer dot 
h2a = plot([ 0 ],[ 0 ] ,'yo');% c = cyan, o = cirlce 
 
axis([-0.5 0.5 -0.3 0.3]); 
axis('square');% creates square axis  
%axis off %hides axis lines
xlabel("Linear movemet in direction of cylinder (m)")
title('Crank slider movement of a Piston - linkage between crank - connecting rod - piston','FontSize',a);% sets the title of the animation 
plot([-1 5],[0 0], 'k-') %sets the line the piston box moves along 
 
%start calculation loop
for t = 0:0.01:(2*pi/theta2d);
 
   %increment counter and update time array
   i = i+1; time(i) = t;
 
   %define crank angle at each time increment
   theta2(i) =  theta2_initial+theta2d*t; %initial angle + angle displaced during time t
 
   %resets theta2 angle to zero after each 360deg revolution
   if theta2(i)>pi 
       theta2(i) = theta2(i)-2*pi*floor(theta2(i)/(2*pi));
   end
   
   %Define position of B at each time increment    
   Bx(i) = r2*cos(theta2(i)); % x component of crank position according to angle in given iteration
   By(i) = r2*sin(theta2(i)); 
   
   %Define connecting rod angle at each time increment
   theta3(i) = asin(By(i)/r3) 
 
   %Define r1 and piston position at each time increment
   r1(i) = Bx(i) + r3*cos(theta3(i))
   
   Cx(i) =  r1(i)
   Cy(i) =  0 % the slider is not free to move in the y direction
   
   %define position of coupler point P - allos motion to be tracked 
    Px(i) = Bx(i) + BP*cos(theta3(i)+theta_5);
    Py(i) = By(i) + BP*sin(theta3(i)+theta_5);

   %update plot wuth calculated information 
   figure(1); 
   %plots the new position of the piston
   set(h4,'Xdata', [Cx(i)-ps Cx(i)+ps  Cx(i)+ps Cx(i)-ps], 'Ydata' , [Cy(i)-ps Cy(i)-ps  Cy(i)+ps Cy(i)+ps ]);  
   %plots the red points
   set(h1,'Xdata', [Ax Bx(i) Cx(i) ], 'Ydata' , [Ay By(i) Cy(i) ]); 
   %plots the blue links
   set(h2,'Xdata', [Ax Bx(i) Cx(i) ], 'Ydata' , [Ay By(i) Cy(i) ]);  
   %displays time at the bottom of the plot
   set(h3,'string',['t = ' num2str(time(i))]); 
     
   pause(0.01);
end
 
figure(2); hold on; grid on; box on; 
subplot(1,2,1)
set(gcf,'color','white')
set(gca,'fontsize',14)
plot(time, theta2,'r-',time, theta3,'b-')
legend('crank (\theta_2)','coupler (\theta_3)')
xlabel('time - s')
ylabel('angle - rad')
 
subplot(1,2,2)
hold on; grid on; box on; 
set(gcf,'color','white')
set(gca,'fontsize',14)
plot(time, r1,'r-')
legend('piston position (r_1)')
xlabel('time - s')
ylabel('position - m')

%plot coupler position
figure(1); plot(Px,Py,'c-','linewidth',3)% plots movement of coupler point p 
