clear all
config = Config();
config.sigma_ksi = 1;


trace = ExtendedTrace(config, clock, 4);
trace.V = 0;
trace.N_periods = 0;
trace = trace.Initialization();
trace = trace.Go;

StateVector = trace.StateVector;
y = (trace.Measurements) * config.c;
R = y - StateVector(9,:)*config.c;
RD = [R(2,:) - R(1,:);R(3,:) - R(1,:);R(4,:) - R(1,:)];
period = StateVector(8,:);
StateVector = StateVector([1 2 4 5 9],:);



