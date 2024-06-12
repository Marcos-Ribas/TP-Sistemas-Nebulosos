clear;
clc;
%%%%%%%%%%%%%%%%%%%%%%%%% Luana Prates - Trabalho final Sistemas Nebulosos

% Variáveis de entrada
fis = mamfis('Name', "perfilInvestidor", 'DefuzzificationMethod', 'centroid');
fis = addInput(fis, [0 20], 'Name', 'Carencia'); % anos
fis = addInput(fis, [0 100], 'Name', 'Aversao'); % porcentagem
fis = addInput(fis, [0 100], 'Name', 'Conhecimento'); % porcentagem
fis = addInput(fis, [0 150*10^3], 'Name', 'PL');
 
% Variáveis de saída
fis = addOutput(fis, [0 100], 'Name', "Perfil"); % porcentagem

% Funções de Pertinência das Entradas: Parâmetros para a função sino - [largura, inclinação, centro]

% Função de Pertinência da entrada Carência
fis = addMF(fis, 'Carencia', "trimf", [-10 0 10], 'Name', 'Baixa');
fis = addMF(fis, 'Carencia', "trimf", [0.00001 10 20], 'Name', 'Media');
fis = addMF(fis, 'Carencia', "trimf", [10 20 30], 'Name', 'Alta');

% Função de Pertinência da entrada Aversão ao Risco
fis = addMF(fis, 'Aversao', "trimf", [-50 0 50], 'Name', 'Baixa');
fis = addMF(fis, 'Aversao', "trimf", [0.00001 50 100], 'Name', 'Media');
fis = addMF(fis, 'Aversao', "trimf", [50 100 150], 'Name', 'Alta');

% Função de Pertinência da entrada Conhecimento % so 3 variaveis
fis = addMF(fis, 'Conhecimento', 'trimf', [-25 0 25], 'Name', 'Nenhum');
fis = addMF(fis, 'Conhecimento', "trimf", [0.00001 25 50], 'Name', 'Basico');
fis = addMF(fis, 'Conhecimento', "trimf", [25 50 75], 'Name', 'Intermediario');
fis = addMF(fis, 'Conhecimento', "trimf", [50 75 100.1], 'Name', 'Avancado');

% Função de Pertinência da entrada PL (Patrimônio Líquido)
fis = addMF(fis, 'PL', "trimf", [-50*10^3 0 50*10^3], 'Name', 'Baixo');
fis = addMF(fis, 'PL', "trimf", [0.00001 50*10^3 100*10^3], 'Name', 'Medio');
fis = addMF(fis, 'PL', "trimf", [50*10^3 100*10^3 150.1*10^3], 'Name', 'Alto');


% Função de Pertinência das Saídas % em porcentagem
fis = addMF(fis, "Perfil",  "trimf", [-50 0 50], 'Name', "Conservador");
fis = addMF(fis, "Perfil",  "trimf", [0.00001 50 100], 'Name', "Moderado");
fis = addMF(fis, "Perfil",  "trimf", [50 100 150], 'Name', "Agressivo");

% Criar uma nova figura para todos os subplots
figure;

% Plotar as funções de pertinência da variável de entrada 'Carencia'
subplot(3, 2, 1);
plotmf(fis, 'input', 1);
title('Funções de Pertinência da Carencia');
xlabel('Carencia (anos)');
ylabel('Grau de Pertinência');
grid on;

% Plotar as funções de pertinência da variável de entrada 'Aversao'
subplot(3, 2, 2);
plotmf(fis, 'input', 2);
title('Funções de Pertinência da Aversao');
xlabel('Aversao ao Risco');
ylabel('Grau de Pertinência');
grid on;

% Plotar as funções de pertinência da variável de entrada 'Conhecimento'
subplot(3, 2, 3);
plotmf(fis, 'input', 3);
title('Funções de Pertinência do Conhecimento');
xlabel('Conhecimento do Mercado');
ylabel('Grau de Pertinência');
grid on;

% Plotar as funções de pertinência da variável de entrada 'PL'
subplot(3, 2, 4);
plotmf(fis, 'input', 4);
title('Funções de Pertinência do PL');
xlabel('Patrimônio Líquido (em reais)');
ylabel('Grau de Pertinência');
grid on;

% Plotar as funções de pertinência da saída
subplot(3, 2, 6);
plotmf(fis, 'output', 1);
title('Funções de Pertinência da Saída');
xlabel('Perfil');
ylabel('Grau de Pertinência');
grid on;

clc

% Definição das funções de pertinência
carencia = {'Baixa', 'Media', 'Alta'};
aversao = {'Baixa', 'Media', 'Alta'};
conhecimento = {'Nenhum', 'Basico', 'Intermediario', 'Avancado'};
pl = {'Baixo', 'Medio', 'Alto'};

% Inicializar uma célula para armazenar as combinações
combinations = cell(numel(carencia) * numel(aversao) * numel(conhecimento) * numel(pl), 4);

% Índice para a célula de combinações
index = 1;

% Gerar todas as combinações possíveis usando loops aninhados
for i = 1:numel(carencia)
    for j = 1:numel(aversao)
        for k = 1:numel(conhecimento)
            for l = 1:numel(pl)
                combinations{index, 1} = carencia{i};
                combinations{index, 2} = aversao{j};
                combinations{index, 3} = conhecimento{k};
                combinations{index, 4} = pl{l};
                index = index + 1;
            end
        end
    end
end

% Exibir as combinações
%for i = 1:size(combinations, 1)
%    fprintf('Carencia: %s, Aversao: %s, Conhecimento: %s, PL: %s\n', ...
%        combinations{i, 1}, combinations{i, 2}, combinations{i, 3}, combinations{i, 4});
%end

% Importar as regras do arquivo Excel
filename = 'regras.xlsx';
data = readtable(filename);

% Adicionar as regras ao sistema Fuzzy
for i = 1:height(data)
    rule = sprintf('%s == %s & %s == %s & %s == %s & %s == %s => Perfil = %s', ...
        fis.Inputs(1).Name, char(data{i, 'Carencia'}), ...
        fis.Inputs(2).Name, char(data{i, 'Aversao'}), ...
        fis.Inputs(3).Name, char(data{i, 'Conhecimento'}), ...
        fis.Inputs(4).Name, char(data{i, 'PL'}), ...
        char(data{i, 'Perfil'}));
    fis = addRule(fis, rule);
end

% Exibir as regras
%disp(showrule(fis));
close;

% Solicitar ao usuário os valores das entradas
carencia = input('Em quanto tempo você precisa do valor investido? Digite um valor de 1 a 20 anos: '); 
aversao = input('De 0 a 100, o quanto você se considera averso ao risco: ');
conhecimento = input('Digite o valor do Conhecimento do Mercado (0 a 100): ');
pl = input('Digite o valor do Patrimonio Liquido (em reais, 0 a 200000): ');

% Calcular a saída usando o sistema Fuzzy
perfil = evalfis(fis, [carencia aversao conhecimento pl]);

% Exibir o perfil resultante
disp(['O perfil do investidor é: ', num2str(perfil)]);
