%    Coursework 2023 -- Part 2
%% Main Body -- Do NOT edit

if ~exist('suppress_figures','var')
    clc; clear; close all;
    show_plots =    1;
else
    show_plots =    0;
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%           Section 1          %%%%%%%%%%%%%%
%%%%%%%%%%%%%%          PERCEPTRON          %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('dataset_heart_attack'); % loads X, t and x_titles
I =                 400; % number of training iterations
gamma =             0.2; % learning rate
theta_A =           [1.83388501459509;-2.25884686100365;0.862173320368121;0.318765239858981;-1.30768829630527;-0.433592022305684;0.342624466538650;3.57839693972576;2.76943702988488;-1.34988694015652;3.03492346633185;0.725404224946106;-0.0630548731896562;0.714742903826096];
theta_B =           [-0.204966058299775;-0.124144348216312;1.48969760778547;1.40903448980048;1.41719241342961;0.671497133608081;-1.20748692268504;0.717238651328839;1.63023528916473;0.488893770311789;1.03469300991786;0.726885133383238;-0.303440924786016;0.293871467096658;-0.787282803758638;0.888395631757642;-1.14707010696915;-1.06887045816803;-0.809498694424876;-2.94428416199490;1.43838029281510;0.325190539456198;-0.754928319169703;1.37029854009523;-1.71151641885370;-0.102242446085491;-0.241447041607358];

% Function 1
t_hat_A=            perceptron_predict(     X,      @mapping_A,  theta_A );
t_hat_B=            perceptron_predict(     X,      @mapping_B,  theta_B );
% Function 2
cm_A =              classification_margin(  X, t,   @mapping_A,  theta_A );
cm_B =              classification_margin(  X, t,   @mapping_B,  theta_B );
% Function 3
grad_per_theta_A =  perceptron_gradient(    X, t,   @mapping_A,  theta_A );
grad_per_theta_B =  perceptron_gradient(    X, t,   @mapping_B,  theta_B );
% Function 4
loss_haz_A =        hinge_at_zero_loss(     X, t,   @mapping_A,  theta_A );
loss_haz_B =        hinge_at_zero_loss(     X, t,   @mapping_B,  theta_B );
% Function 5
theta_mat_A =       perceptron_train_sgd(   X, t,   @mapping_A,  theta_A, I, gamma );
theta_mat_B =       perceptron_train_sgd(   X, t,   @mapping_B,  theta_B, I, gamma );

if show_plots % perceprton
    vec_loss_haz_A =            zeros(I+1,1);
    vec_loss_haz_B =            zeros(I+1,1);
    for ii=1:(I+1)
        vec_loss_haz_A(ii) =    hinge_at_zero_loss(  X,   t, @mapping_A, theta_mat_A(:,ii) );
        vec_loss_haz_B(ii) =    hinge_at_zero_loss(  X,   t, @mapping_B, theta_mat_B(:,ii) );
    end

    figure;
    plot(0:I,vec_loss_haz_A,'mo-' ,'DisplayName','features A'); hold on;
    plot(0:I,vec_loss_haz_B,'gx-' ,'DisplayName','features B');
    xlabel('Iteration','interpreter','latex');
    ylabel('loss','interpreter','latex');
    title ('Perceptron hinge-at-zero loss','interpreter','latex');
    legend show; grid;
end

% Function 6
discussion();

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%           Section 2          %%%%%%%%%%%%%%
%%%%%%%%%%%%%%     LOGISTIC REGRESSION      %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

S =                     30; % mini-batch size

% Function 7
logit_hat_A=            logistic_regression_logit(      X,      @mapping_A,  theta_A );
logit_hat_B=            logistic_regression_logit(      X,      @mapping_B,  theta_B );
% Function 8
grad_lr_theta_A =       logistic_regression_gradient(   X, t,   @mapping_A,  theta_A );
grad_lr_theta_B =       logistic_regression_gradient(   X, t,   @mapping_B,  theta_B );
% Function 9
loss_lr_A =             logistic_loss(                  X, t,   @mapping_A,  theta_A );
loss_lr_B =             logistic_loss(                  X, t,   @mapping_B,  theta_B );
% Function 10
theta_lr_mat_A =        logistic_regression_train_sgd(  X, t,   @mapping_A,  theta_A, I, gamma, S );
theta_lr_mat_B =        logistic_regression_train_sgd(  X, t,   @mapping_B,  theta_B, I, gamma, S );

% code for evalutating the test loss while training
vec_loss_lr_A =         zeros(1,I+1);
vec_loss_lr_B =         zeros(1,I+1);
for ii=1:(I+1)
    vec_loss_lr_A(ii) = logistic_loss(                  X, t,   @mapping_A,  theta_lr_mat_A(:,ii) );
    vec_loss_lr_B(ii) = logistic_loss(                  X, t,   @mapping_B,  theta_lr_mat_B(:,ii) );
end

% auxiliary code for plotting
if show_plots % logistic regression
    figure;
    plot(0:I,vec_loss_lr_A,'mo-','DisplayName','features A'); hold on;
    plot(0:I,vec_loss_lr_B,'gx-','DisplayName','features B');
    xlabel('Iteration','interpreter','latex');
    ylabel('loss','interpreter','latex');
    title ('Logistic Regression loss','interpreter','latex');
    legend show; grid;
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%           Section 3          %%%%%%%%%%%%%%
%%%%%%%%%%%%%%      NEURAL NETWORKS         %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

theta_nn.W1 =               [-0.9,+0.2;-0.5,+1.7;+0.4,+0.8];
theta_nn.W2 =               [-0.6,-1.1,-0.9;+1.4,-0.6,-0.2];
theta_nn.w3 =               [-0.8;+1.8];
x1_nn =                     [-1.0;+2.5];
t1_nn =                     1;
x2_nn =                     [-0.4;+3.2];
t2_nn =                     0;
% Function 11
leaky_ReLU_nn_1 =           leaky_ReLU(             x1_nn);
leaky_ReLU_nn_2 =           leaky_ReLU(             x2_nn);
% Function 12
grad_leaky_1 =              grad_leaky_ReLU(        x1_nn);
grad_leaky_2 =              grad_leaky_ReLU(        x2_nn);
% Function 13
[logit_nn_1, grad_nn_1] =   nn_logit_and_gradient( x1_nn, t1_nn, theta_nn);
[logit_nn_2, grad_nn_2] =   nn_logit_and_gradient( x2_nn, t2_nn, theta_nn);


disp('Licenses used (make sure only ''matlab'' follows):');
license('inuse')

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%   AUXILIARY FUNCTIONS        %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function U = mapping_A(X)
    vec_bias =  [131.62,246.26,0.15,0.53,149.65,0.33,1.04,1.4,0.73,2.31,54.37,0.68,0.97];
    vec_slope = [17.54,51.83,0.36,0.53,22.91,0.47,1.160,0.62,1.020,0.61,9.080,0.47,1.030];
    U =         [ones(size(X,1),1), (X-vec_bias)./vec_slope];
end
 
function U = mapping_B(X)
    vec_bias =  [131.62,246.26,0.15,0.53,149.65,0.33,1.04,1.4,0.73,2.31,54.37,0.68,0.97,17631.39,63323.53,0.15,0.55,22917.1,0.33,2.42,2.34,1.57,5.73,3037.91,0.68,2];
    vec_slope = [17.54,51.83,0.36,0.53,22.91,0.47,1.16,0.62,1.020,0.61,9.080,0.47,1.030,4858.22,29216.36,0.36,0.64,6609.27,0.47,4.520,1.580,3.060,2.710,975.830,0.47,2.640];
    U =         [ones(size(X,1),1), ([X,X.^2]-vec_bias)./vec_slope];
end

function out = sigmoid(in)
    out =       1./(1+exp(-in));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%   INSERT YOUR CODE IN THE FUNCTIONS BELOW  %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Function 1
function t_hat= perceptron_predict(X, map_func, theta)
    N = size(X,1);
    t_hat = zeros(N,1);

    d = map_func(X)*theta;
    for n = 1:N
        if d(n,1)>0
            t_hat(n,1) = 1;
        else
            t_hat(n,1) = 0;
        end
    end
end

% Function 2
function cm= classification_margin(X, t, map_func, theta) 
    N = size(X,1);
    d = map_func(X)*theta;
    cm = (2.*t-1).*d;
end

% Function 3
function grad_theta = perceptron_gradient(X, t, map_func, theta)
    N = size(X,1);
    u = map_func(X);
    d = u*theta;

    for n = 1:N
        if d(n,1)>0
            that(n,1) = 1;
        else
            that(n,1) = 0;
        end
    end

    for n = 1:N
        if that(n) == t(n)
            grad_theta(n,:) = 0;
        elseif that(n) ~= t(n) && t(n) == 1
            grad_theta(n,:) = -1 .* u(n,:);
        elseif that(n) ~= t(n) && t(n) == 0
            grad_theta(n,:) = 1 .* u(n,:);
        end
    end 
end

% Function 4
function loss = hinge_at_zero_loss(X, t, map_func, theta)
    N = size(X,1);
    d = map_func(X) * theta;
    margin = (2*t-1).*d;
    error = zeros(N,1);

    for n = 1:N
        if margin(n) > 0
            error(n) = 0;
        elseif margin(n) < 0
            error(n) = -1 * margin(n);
        end
    end

    loss = (1/N) * sum(error,"all");
end

% Function 5
function theta_mat = perceptron_train_sgd(X, t, map_func, theta_init, I, gamma)
    N = size(X,1);
    u = map_func(X);
    theta_mat(:,1) = theta_init;

    for i = 1:I
        n = 1 + mod((i-1),N);
        d = theta_init' * u(n,:)';
        tpm = 2*t(n)-1;
        margin = tpm*d;
            if margin < 0
                theta_init = theta_init + gamma * tpm * u(n,:)';    
            end
        theta_mat(:,i+1) = theta_init; 
    end
end

% Function 6
function discussion()
    disp('discussion:');
    disp('');
end

% Function 7
function logit= logistic_regression_logit(X, map_func, theta)
    u = map_func(X);
    logit = (theta' * u')'; 
end

% Function 8
function grad_theta = logistic_regression_gradient(X, t, map_func, theta)
    N = size(X,1);
    u = map_func(X);
    logit = logistic_regression_logit(X, map_func, theta);
    error = sigmoid(logit-t);

    for n = 1:N
        grad_theta(n,:) = error(n,:) * u(n,:);
    end 
end

% Function 9
function loss = logistic_loss(X, t, map_func, theta)
    N = size(X,1);
    u = map_func(X);    
    logit = u*theta;
    y = (2*t-1) .* logit;
    fy = log(1+exp(-y));
    loss = sum(fy,"all")/N;
end

% Function 10
function theta_mat = logistic_regression_train_sgd(X, t, map_func, theta_init, I, gamma, S)
    N = size(X,1);
    u = map_func(X);
    theta_mat(:,1) = theta_init;

    for i = 1:I
        sample = 1 + mod(S*(i-1)+[0:S-1]+1,N);
        g = zeros();
        for s = 1:S
            sig = 1/(1+exp(-theta_init'*u(sample(s),:)'))';
            g = g + 1/S * ((sig - t(sample(s),:))) * u(sample(s),:)';
        end
        theta_init = theta_init - gamma * g ;
        theta_mat(:,i+1) = theta_init;
    end
end

% Function 11
function out = leaky_ReLU(in)
    N = size(in,1);
        for n = 1:N
            if in(n,1) >= 0
                h(n,1) = in(n,1);
            elseif in(n,1) < 0
                h(n,1) = 0.1 .*in(n,1);
            end
        end
    out = h;
end

% Function 12
function out = grad_leaky_ReLU(in)
    N = size(in,1);
    for n = 1:N
        if in(n,1) > 0
            dh(n,1) = 1;
        elseif in(n,1) < 0
            dh(n,1) = 0.1*1;
        end
    end
    out = dh;
end

% Function 13
function [logit,grad_theta] = nn_logit_and_gradient(x, t, theta)
    a1 = theta.W1*x;
    h1 = leaky_ReLU(a1);
    a2 = theta.W2*h1;
    h2 = leaky_ReLU(a2);
    a3 = theta.w3'*h2;
    logit = 1/(1+exp(-a3));

    errorw3 = (sigmoid(a3) - t);
    grad_theta.w3 = errorw3 * h2;
    errorW2 = (grad_leaky_ReLU(a2).*theta.w3) * errorw3;
    grad_theta.W2 = errorW2 * h1';
    errorW1 = grad_leaky_ReLU(a1).*(theta.W2' * errorW2);
    grad_theta.W1 = errorW1 * x';
end