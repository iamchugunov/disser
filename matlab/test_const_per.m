clear all
config = Config();
config.sigma_ksi = 1;


trace = ExtendedTrace(config, clock, 4);
trace.V = 200;
trace.N_periods = 0;
trace = trace.Initialization();
trace = trace.Go;

StateVector = trace.StateVector;
y = (trace.Measurements) * config.c;
R = y - StateVector(9,:)*config.c;
RD = [R(2,:) - R(1,:);R(3,:) - R(1,:);R(4,:) - R(1,:)];
period = StateVector(8,:);
StateVector = StateVector([1 2 4 5 9],:);

X1(:,1) = [StateVector(1,1);StateVector(2,1);StateVector(3,1);StateVector(4,1)];
Fil1 = ToAEKF_RD(X1(:,1), RD(:,1), config);

X2(:,1) = [StateVector(1,1);StateVector(2,1);StateVector(3,1);StateVector(4,1);StateVector(5,1)*config.c];
Fil2 = ToAEKF_const_per(X2(:,1), y(:,1), config);

X3(:,1) = [StateVector(1,1);StateVector(2,1);StateVector(3,1);StateVector(4,1);StateVector(5,1)*config.c;];
Fil3 = ToAEKF_const_perh(X3(:,1), y(:,1), config);

d = 0;
dt(1) = 1;
dt12(:,1) = period(:,1);
for i = 1:length(y)
   [X0(:,i), dop(:,i)] = coord_solver2D(y(:,i), config.posts, [StateVector(1,i);StateVector(3,i);StateVector(5,i)*config.c], config.hei); 
   [Xd(:,i), dPR] = NavSolver_D(R(:,i), config.posts, [StateVector(1,i);StateVector(3,i)], config.hei);
    if i > 1
        dt(i) = mean(y(:,i) - y(:,i-1))/config.c;
        
        Fil1 = Fil1.Update(RD(:,i), period(i-1), config);
        X1(:,i) = Fil1.X;
        
        Fil2 = Fil2.Update(y(:,i), period(i-1) + normrnd(0, 0*10e-9), config);
        X2(:,i) = Fil2.X;
        dt11(:,i) = Fil2.dt_raw;
        dt12(:,i) = Fil2.dt_fil;
        
        Fil3 = Fil3.Update(y(:,i), period(i-1) + normrnd(0, 0*10e-9), config);
        X3(:,i) = Fil3.X;
        
    end
end

dt11(1) = [];
dt12(1) = [];
dt(1) = [];
period(end) = [];

X0(3,:) = X0(3,:)/config.c;
X2(5,:) = X2(5,:)/config.c;
X3(5,:) = X3(5,:)/config.c;

errd = (StateVector([1 3],1:end-d) - Xd([1 2],1:end-d));
errmnk = (StateVector([1 3 5],1:end-d) - X0([1 2 3],1:end-d));
errf1 = (StateVector([1 3],1:end-d) - X1([1 3],1:end-d));
errf2 = (StateVector([1 3 5],1:end-d) - X2([1 3 5],1:end-d));
errf3 = (StateVector([1 3 5],1:end-d) - X3([1 3 5],1:end-d));


figure(1)
plot(config.posts(1,:),config.posts(2,:),'vk','linewidth',2)
grid on
hold on
daspect([1 1 1])
plot(X0(1,:),X0(2,:),'g')
plot(X1(1,:),X1(3,:),'b.-','linewidth',2)
plot(Xd(1,:),Xd(2,:),'k-.','linewidth',1)
plot(X2(1,:),X2(3,:),'r-.','linewidth',2)
legend('posts','ĞÄ','ĞÄÔ','Ä','Ô1')


figure(2)
grid on
title('Îøèáêà ïî õ')
hold on
plot(errmnk(1,:),'g')
plot(errf1(1,:),'b','linewidth',2)
plot(errd(1,:),'k','linewidth',1)
plot(errf2(1,:),'r','linewidth',2)
xlabel('k, òàêòû')
ylabel('x, ì')
legend('ĞÄ','ĞÄÔ','Ä','Ô1')

figure(3)
grid on
title('Îøèáêà ïî y')
hold on
plot(errmnk(2,:),'g')
plot(errf1(2,:),'b','linewidth',2)
plot(errd(2,:),'k','linewidth',1)
plot(errf2(2,:),'r','linewidth',2)
xlabel('k, òàêòû')
ylabel('y, ì')
legend('ĞÄ','ĞÄÔ','Ä','Ô1')

figure(4)
grid on
title('Îøèáêà ïî âğåìåíè èçëó÷åíèÿ')
hold on
% plot(errmnk(3,:),'g')
plot(errf2(3,:),'r','linewidth',2)
plot(errf3(3,:),'b','linewidth',2)
xlabel('k, òàêòû')
ylabel('T_{èçë}, ñåê')
% legend('ĞÄ','Ô1','Ô*')

fprintf('=======================================================================================\n')
fprintf('Ïî x:\n')
fprintf(['ĞÄ\tÌÎ: ' num2str(mean(errmnk(1,:))) ' ì\tÑÊÎ: ' num2str(std(errmnk(1,:))) ' ì\n'] )
fprintf(['ĞÄÔ\tÌÎ: ' num2str(mean(errf1(1,:))) ' ì\tÑÊÎ: ' num2str(std(errf1(1,:))) ' ì\n'] )
fprintf(['Ä\tÌÎ: ' num2str(mean(errd(1,:))) ' ì\tÑÊÎ: ' num2str(std(errd(1,:))) ' ì\n'] )
fprintf(['Ô1\tÌÎ: ' num2str(mean(errf2(1,:))) ' ì\tÑÊÎ: ' num2str(std(errf2(1,:))) ' ì\n'] )
fprintf('Ïî y:\n')
fprintf(['ĞÄ\tÌÎ: ' num2str(mean(errmnk(2,:))) ' ì\tÑÊÎ: ' num2str(std(errmnk(2,:))) ' ì\n'] )
fprintf(['ĞÄÔ\tÌÎ: ' num2str(mean(errf1(2,:))) ' ì\tÑÊÎ: ' num2str(std(errf1(2,:))) ' ì\n'] )
fprintf(['Ä\tÌÎ: ' num2str(mean(errd(2,:))) ' ì\tÑÊÎ: ' num2str(std(errd(2,:))) ' ì\n'] )
fprintf(['Ô1\tÌÎ: ' num2str(mean(errf2(2,:))) ' ì\tÑÊÎ: ' num2str(std(errf2(2,:))) ' ì\n'] )
fprintf('Ïî âğåìåíè èçëó÷åíèÿ:\n')
fprintf(['ĞÄ\tÌÎ: ' num2str(mean(errmnk(3,:))) ' ñ\tÑÊÎ: ' num2str(std(errmnk(3,:))) ' ñ\n'] )
fprintf(['Ô1\tÌÎ: ' num2str(mean(errf2(3,:))) ' ñ\tÑÊÎ: ' num2str(std(errf2(3,:))) ' ñ\n'] )
fprintf('=======================================================================================\n')