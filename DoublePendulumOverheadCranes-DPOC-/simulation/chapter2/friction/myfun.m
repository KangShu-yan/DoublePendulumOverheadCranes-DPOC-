function F = myfun(theta,xdata)
    len = length(xdata);
    F = zeros(len,1);
    for i = 1:len;
        x = xdata(i);
        F(i)=theta(1)*tanh(x/theta(2))-theta(3)*abs(x)*x;
%          F(i)=theta(1)*tanh(x/0.05)-theta(2)*abs(x)*x;
%         F(i) =thetahat(1)*(tanh(thetahat(2)*x(i))-tanh(thetahat(3)*x(i)))+thetahat(4)*tanh(thetahat(5)*x(i))+thetahat(6)*x(i);
    end
    
end