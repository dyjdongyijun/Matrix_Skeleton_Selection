%% yijun@natt.oden.utexas.edu
% path = '/h2/yijun/Documents/MATLAB/RandNLA/CUR/';
% path_result_cache = '/h2/yijun/Documents/MATLAB/RandNLA/CUR/result_cache/';
% path_target = '/h2/yijun/Documents/MATLAB/RandNLA/dataset/';
% scp ./ yijun@natt.oden.utexas.edu:/h2/yijun/Documents/MATLAB/RandNLA/dataset/
%% local
clear; close;
path_target = 'C:\\Users\\yijundong\\Documents\\MATLAB\\OdenUT\\RandNLA\\dataset\\';
path = 'C:\\Users\\yijundong\\Documents\\MATLAB\\OdenUT\\RandNLA\\CUR\\';

tags = {'GSE10072', 'ACTIVSg2000', 'p2p-Gnutella09', 'large',...
        'snn-1e4-5e3_a2b1_k10_r1e3_s1e-3', 'weightedlaplacian-n1e4-m5n'};

%% fig:spectra_overview
figure();
spectra = cell(1, length(tags));
for iter = 1:length(tags)
    tag = tags{iter};
    target = load(strcat(path_target, sprintf('target_%s.mat',tag)));
    spectra{iter} = target.sigma;
    
    subplot(3,2,iter)
    semilogy(target.sigma, 'k.-', 'MarkerSize',10, 'LineWidth', 1)
    if iter < 5
        title(sprintf('\\texttt{%s} spectrum',tag), 'interpreter', 'latex')
    elseif iter == 5
        title('SNN($a=2$, $b=1$, $k=10$, rank$=10^3$) spectrum', 'interpreter', 'latex')
    else % iter==6
        title('Random weighted Laplacian spectrum', 'interpreter', 'latex')
    end
    xlim([1 length(target.sigma)])
    set(gca,'FontSize',12)
end

%% Rand-CUR
clear; close;
% path = '/h2/yijun/Documents/MATLAB/RandNLA/CUR/';
% path_target = '/h2/yijun/Documents/MATLAB/RandNLA/dataset/';
path_target = 'C:\\Users\\yijundong\\Documents\\MATLAB\\OdenUT\\RandNLA\\dataset\\';
path = 'C:\\Users\\yijundong\\Documents\\MATLAB\\OdenUT\\RandNLA\\CUR\\';
% tag = 'large';
% tag = 'snn-1e3-1e3_a2b1_k100_r1e3_s1e-3';
% tag = 'yaleface-64x64';
tag = 'mnist-train';
target = load(strcat(path_target, sprintf('target_%s.mat',tag)));
A = target.A;
%%
k = load(sprintf('rank_%s.mat',tag)); k = k.k;
time = load(sprintf('time_%s.mat',tag));
errfro = load(sprintf('errfro_%s.mat',tag));
err2 = load(sprintf('err2_%s.mat',tag));

ksr = load(sprintf('rank_%s-srcur.mat',tag));
timesr = load(sprintf('time_%s-srcur.mat',tag));
errfrosr = load(sprintf('errfro_%s-srcur.mat',tag));
err2sr = load(sprintf('err2_%s-srcur.mat',tag));
%%
err2.SRCUR = err2sr.SRCUR;
errfro.SRCUR = errfrosr.SRCUR;
time.SRCUR = timesr.SRCUR;
save(sprintf('err2_%s.mat',tag),'-struct','err2')
save(sprintf('errfro_%s.mat',tag),'-struct','errfro')
save(sprintf('time_%s.mat',tag),'-struct','time')
%%
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
stylemap = struct(...
                'CPQR',...
                {'Color',[0.93,0.69,0.13],...
                 'LineStyle','-','LineWidth',1.5,...
                 'Marker','d','MarkerSize',6,'MarkerFaceColor',[0.93,0.69,0.13]},...
                ...
                'CPQR2pass',...
                {'Color',[0.93,0.69,0.13],...
                 'LineStyle',':','LineWidth',1.5,...
                 'Marker','*','MarkerSize',10,'MarkerFaceColor',[0.93,0.69,0.13]},...
                'CPQR2passOrtho',...
                {'Color',[0.93,0.69,0.13],...
                 'LineStyle',':','LineWidth',1.5,...
                 'Marker','x','MarkerSize',10,'MarkerFaceColor',[0.93,0.69,0.13]},...
                ...
                'LUPP',...
                {'Color',[0.85,0.33,0.10],...
                 'LineStyle','-','LineWidth',1.5,...
                 'Marker','d','MarkerSize',6,'MarkerFaceColor',[0.85,0.33,0.10]},...
                'LUPP2pass',...
                {'Color',[0.85,0.33,0.10],...
                 'LineStyle',':','LineWidth',1.5,...
                 'Marker','*','MarkerSize',10,'MarkerFaceColor',[0.85,0.33,0.10]},...
                'LUPP2passOrtho',...
                {'Color',[0.85,0.33,0.10],...
                 'LineStyle',':','LineWidth',1.5,...
                 'Marker','x','MarkerSize',10,'MarkerFaceColor',[0.85,0.33,0.10]},...
                ...
                'RSVDDEIM',...
                {'Color',[0.47,0.67,0.19],...
                 'LineStyle','-','LineWidth',1.5,...
                 'Marker','s','MarkerSize',6,'MarkerFaceColor',[0.47,0.67,0.19]},...
                ...
                'RSVDLS',...
                {'Color',[0.00,0.45,0.74],...
                 'LineStyle','-','LineWidth',1.5,...
                 'Marker','o','MarkerSize',6,'MarkerFaceColor',[0.00,0.45,0.74]},...
                ...
                'SRCUR',...
                {'Color',[0.25 0.80 0.54],...
                 'LineStyle','-','LineWidth',1.5,...
                 'Marker','o','MarkerSize',6,'MarkerFaceColor',[0.25 0.80 0.54]});
%%
sigma = target.sigma;
sfro = sqrt(cumsum(sigma.^2,'reverse'));
% tag = '$10^3 \times 10^3$ SNN($a=2,b=1,k=10^2$,rank$=10^3$)';

algos = {'RSVDDEIM',...
         ...
         'LUPP',...
         'LUPP2pass',...
         ...'LUPP2passOrtho',...
         ...
         'CPQR',...
         'CPQR2pass',...
         ...'CPQR2passOrtho',...
         ...
         'RSVDLS',...
         ...
         'SRCUR'};
labels = arrayfun(@(i) legmap.(algos{i}), 1:length(algos), 'UniformOutput',false);

% frobenius norm
err = errfro;
optimal = sfro;
figure()     
semilogy(k, optimal(k+1)./optimal(1), 'k.-', 'MarkerSize',20, 'LineWidth', 1.5)
hold on
for aux = 1:length(algos)
    semilogy(k, (err.(algos{aux}))./optimal(1), stylemap.(algos{aux}))
end
hold off
xlim([k(1) k(end)])
xlabel('$k$','interpreter','latex')
ylabel('$||A-CUR||_F/||A||_F$','interpreter','latex')
legend('$\sqrt{\sum_{i=k+1}^r \sigma_i^2}/\sqrt{\sum_{i=1}^r \sigma_i^2}$',...
    labels{:},...
    'interpreter','latex')
title(sprintf('\\texttt{%s} Randomized',tag),...
    'interpreter','latex')
set(gca,'FontSize',12)

% spectral norm
err = err2;
optimal = sigma;
figure()     
semilogy(k, optimal(k+1)./optimal(1), 'k.-', 'MarkerSize',20, 'LineWidth', 1.5)
hold on
for aux = 1:length(algos)
    semilogy(k, (err.(algos{aux}))./optimal(1), stylemap.(algos{aux}))
end
hold off
xlim([k(1) k(end)])
xlabel('$k$','interpreter','latex')
ylabel('$||A-CUR||_2/||A||_2$','interpreter','latex')
legend('$\sigma_{k+1}/\sigma_{1}$',...
    labels{:},...
    'interpreter','latex')
title(sprintf('\\texttt{%s} Randomized',tag),...
    'interpreter','latex')
set(gca,'FontSize',12)


% time plot: non-stream
labels = arrayfun(@(i) legmap.(algos{i}), 1:length(algos), 'UniformOutput',false);
     
figure()
semilogy(k, time.(algos{1}), stylemap.(algos{1})) 
hold on
for aux = 2:length(algos)
    plot(k, time.(algos{aux}), stylemap.(algos{aux}))
end
hold off
xlim([k(2) k(end)])
xlabel('$k$','interpreter','latex')
ylabel('time / sec','interpreter','latex')
legend(labels{:}, 'interpreter','latex')
title(sprintf('\\texttt{%s} randomized',tag),...
    'interpreter','latex')
set(gca,'FontSize',12)

%%
