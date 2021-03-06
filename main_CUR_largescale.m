clear;

k = [10,10,10,10,20,40,60,80,100,120,140,160,180,200];
tag = 'snn-1e6-1e6-a2b1-k100-r400-s2or';
algos = {'CPQR','CPQR2pass',...'CSCPQR',...
         'LUPP','LUPP2pass',...'CSLUPP',...
         'RSVDDEIM','RSVDLS'};
% test_CUR_large(1e6, k, algos, tag)

%% load output data
targetspec = load(sprintf('target-spec_%s.mat',tag));
time = load(sprintf('time_%s.mat',tag));
errfro = load(sprintf('errfro_%s.mat',tag));
err2 = load(sprintf('err2_%s.mat',tag));

%% % % % % % % % % % % Plots % % % % % % % % % %
algos = {'CPQR',...'CPQR2pass',...'CSCPQR',...
         'LUPP',...'LUPP2pass',...'CSLUPP',...
         'RSVDDEIM','RSVDLS'};

markers = {'o','s','d','^','v','>','<','p','h','+','*','x'};
legmap = struct('DetCPQR','Det-CPQR',...
                'CPQR','Rand-CPQR',...
                'CPQR2pass','Rand-CPQR-1piter',...
                'CPQR2passOrtho','Rand-CPQR-1piter-ortho',...
                'CSCPQR','CS-CPQR',...
                'CPQRstream','Stream-CPQR',...
                'CSCPQRstream','Stream-CPQR',...
                ...
                'DetLUPP','Det-LUPP',...
                'LUPP','Rand-LUPP',...
                'LUPP2pass','Rand-LUPP-1piter',...
                'LUPP2passOrtho','Rand-LUPP-1piter-ortho',...
                'CSLUPP','CS-LUPP',...
                'LUPPstream','Stream-LUPP',...
                ...
                'SVDDEIM','SVD-DEIM',...
                'RSVDDEIM','RSVD-DEIM',...
                'CSSVDDEIM','CSSVD-DEIM',...
                'RSVDDEIMstream','Stream-SVD-DEIM',...
                'CSSVDDEIMstream','Stream-SVD-DEIM',...
                ...
                'LUCP','Det-LUCP',...
                'ACA','DenseSketch-ACA',...(stream)
                'CSLUCP','SparseSketch-LUCP',...(stream)
                ...
                'SVDLS','SVD-LS',...
                'RSVDLS','RSVD-LS',...
                'CSSVDLS','CSSVD-LS',...
                'RSVDLSstream','Stream-SVD-LS',...
                'CSSVDLSstream','Stream-SVD-LS',...
                ...
                'SRCUR','SRCUR');
labels = arrayfun(@(i) legmap.(algos{i}), 1:length(algos), 'UniformOutput',false);

mkmap = struct('RSVDDEIM', strcat('m', markers{1},'-'), ...
               'LUPP', strcat('c', markers{2},'-'), ...
               'CSLUPP', strcat('c', markers{2},'-.'), ...
               'LUPP2pass', strcat('c', markers{2},':'), ...
               'CPQR', strcat('r', markers{3},'-'), ...
               'CSCPQR', strcat('r', markers{3},'-.'), ...
               'CPQR2pass', strcat('r', markers{3},':'), ...
               'RSVDLS', strcat('g', markers{4},'-'), ...
               'SRCUR', strcat('b', markers{5},'-'));
markers = arrayfun(@(i) mkmap.(algos{i}), 1:length(algos), 'UniformOutput',false);
%%
sigma = targetspec.spec;
sfro = sqrt(cumsum(sigma.^2,'reverse'));
% tag = '$10^3 \times 10^3$ SNN($a=2,b=1,k=10^2$,rank$=10^3$)';
% tag = 'Random weighted Laplacian $n=1000, m=4n$';
% tag = 'Dense Gaussian matrix $1000 \times 1000$';

% frobenius norm
err = errfro;
optimal = sfro;
st = 5;
ed = length(k);

% figure()    
subplot(1,3,1)
semilogy(k, optimal(k+1)./optimal(1), 'k.-', 'MarkerSize',20, 'LineWidth', 1.5)
hold on
for aux = 1:length(algos)
    semilogy(k, (err.(algos{aux}))./optimal(1), mkmap.(algos{aux}), 'LineWidth', 1.5)
%     plot(k, (err.(algos{aux})), mkmap.(algos{aux}), 'LineWidth', 1.5)
end
hold off
xlim([k(st) k(ed)])
xlabel('$k$','interpreter','latex')
ylabel('$||A-CUR||_F/||A||_F$','interpreter','latex')
legend('$\sqrt{\sum_{i=k+1}^r \sigma_i^2}/\sqrt{\sum_{i=1}^r \sigma_i^2}$',...
       labels{:},...
       'interpreter','latex')
% title(sprintf('\\texttt{%s} Randomized',tag), 'interpreter','latex')
set(gca,'FontSize',20)


% spectral norm
err = err2;
optimal = sigma;
% figure()   
subplot(1,3,2)
semilogy(k, optimal(k+1)./optimal(1), 'k.-', 'MarkerSize',20, 'LineWidth', 1.5)
hold on
for aux = 1:length(algos)
    semilogy(k, (err.(algos{aux}))./optimal(1), mkmap.(algos{aux}), 'LineWidth', 1.5)
%     plot(k, (err.(algos{aux})), mkmap.(algos{aux}), 'LineWidth', 1.5)
end
hold off
xlim([k(st) k(ed)])
xlabel('$k$','interpreter','latex')
ylabel('$||A-CUR||_2/||A||_2$','interpreter','latex')
% legend('$\sigma_{k+1}/\sigma_{1}$', labels{:}, 'interpreter','latex')
% title('Spectral norm error', 'interpreter','latex')
set(gca,'FontSize',20)

% time
% figure()
subplot(1,3,3)
hold on
for aux = 1:length(algos)
    semilogy(k, time.(algos{aux}), mkmap.(algos{aux}), 'LineWidth', 1.5)
end
hold off
xlim([k(st) k(ed)])
xlabel('$k$','interpreter','latex')
ylabel('Time (s)','interpreter','latex')
% legend(labels{:}, 'interpreter','latex')
% title('Runtime', 'interpreter','latex')
set(gca,'FontSize',20)

