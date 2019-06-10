init_data=importdata('D:\share\ToLeibo\New folder\Port4_Pattern Test.csv');

%Amplitude to complex data
init_data(:,4)=init_data(:,4)*pi/180;
init_data(:,6)=init_data(:,6)*pi/180;
for i=1:length(init_data(:,1))
    init_data(i,3)=power(10,0.05*(init_data(i,3)+53));
    init_data(i,5)=power(10,0.05*(init_data(i,5)+53));

    complex_data(i,1)=init_data(i,1)+90;
    complex_data(i,2)=init_data(i,2);
    complex_data(i,3)=init_data(i,3)*cos(init_data(i,4));
    complex_data(i,4)=init_data(i,3)*sin(init_data(i,4));
    complex_data(i,5)=init_data(i,5)*cos(init_data(i,6));
    complex_data(i,6)=init_data(i,5)*sin(init_data(i,6));
end
% dlmwrite('D:\share\ToLeibo\Port4_complex.csv',complex_data);

%change Theta and Phi range
change_data=[];
for j=3:6
    temp_data=complex_data(:,j);
    temp_data=reshape(temp_data,71,[]);
	temp_data=[temp_data(1,:);temp_data;temp_data(71,:)];
    temp_data=temp_data(:,1:36);
    temp_data=[temp_data(37:73,:),flipud(temp_data(1:37,:))];
    temp_data=[temp_data,temp_data(:,1)];
    temp_data=reshape(temp_data',37*73,1);
    change_data=[change_data,temp_data];
end
oldx=0:5:180;
oldy=0:5:360;
[x,y]=meshgrid(oldx,oldy);
x1=reshape(x,[],1);
y1=reshape(y,[],1);
change_data=[x1,y1,change_data];
GetHFSSFile(change_data,'D:\share\ToLeibo','Port4_changeAngle');

%interp data
phi_data=change_data(:,3)+1j*change_data(:,4);
theta_data=change_data(:,5)+1j*change_data(:,6);
theta_data=reshape(theta_data,73,37);
phi_data=reshape(phi_data,73,37);

[xi,yi]=meshgrid(0:180,0:360);
new_theta_data=interp2(x,y,theta_data,xi,yi);
new_phi_data=interp2(x,y,phi_data,xi,yi);

new_theta_data=reshape(new_theta_data,[],1);
new_phi_data=reshape(new_phi_data,[],1);
xi=reshape(xi,[],1);
yi=reshape(yi,[],1);
new_data=[xi,yi,real(new_theta_data),imag(new_theta_data),real(new_phi_data),imag(new_phi_data)];


GetHFSSFile(new_data,'D:\share\ToLeibo','Port4_interpData');
% dlmwrite('D:\share\ToLeibo\interp.csv',new_data);