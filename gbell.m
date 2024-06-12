clear;
clc;
%%%%%%%%%%%%%%%%%%%%%%%%% Luana Prates - Trabalho final Sistemas Nebulosos

% Variáveis de entrada
fis = mamfis('Name', "perfilInvestidor", 'DefuzzificationMethod', 'centroid');
fis = addInput(fis, [0 20], 'Name', 'Carencia'); 
fis = addInput(fis, [0 100], 'Name', 'Aversao');
fis = addInput(fis, [0 100], 'Name', 'Conhecimento');
fis = addInput(fis, [0 600000], 'Name', 'PL');
 
% Variáveis de saída
fis = addOutput(fis, [0 100], 'Name', "Perfil");

% Funções de Pertinência das Entradas: Parâmetros para a função sino - [largura, inclinação, centro]

% Função de Pertinência da entrada Carência
fis = addMF(fis, 'Carencia', 'gbellmf', [1 2 5], 'Name', 'Baixa');
fis = addMF(fis, 'Carencia', 'gbellmf', [1 2 10], 'Name', 'Media');
fis = addMF(fis, 'Carencia', 'gbellmf', [1 2 15], 'Name', 'Alta');

% Função de Pertinência da entrada Aversão ao Risco
fis = addMF(fis, 'Aversao', 'gbellmf', [1 2 25], 'Name', 'Baixa');
fis = addMF(fis, 'Aversao', 'gbellmf', [1 2 50], 'Name', 'Media');
fis = addMF(fis, 'Aversao', 'gbellmf', [1 2 75], 'Name', 'Alta');

% Função de Pertinência da entrada Conhecimento
fis = addMF(fis, 'Conhecimento', 'gbellmf', [25 2 0], 'Name', 'Nenhum');
fis = addMF(fis, 'Conhecimento', 'gbellmf', [25 2 25], 'Name', 'Basico');
fis = addMF(fis, 'Conhecimento', 'gbellmf', [25 2 50], 'Name', 'Intermediario');
fis = addMF(fis, 'Conhecimento', 'gbellmf', [25 2 75], 'Name', 'Avancado');

% Função de Pertinência da entrada PL (Patrimônio Líquido)
fis = addMF(fis, 'PL', 'gbellmf', [100000 2 100000], 'Name', 'Baixo');
fis = addMF(fis, 'PL', 'gbellmf', [100000 2 300000], 'Name', 'Medio');
fis = addMF(fis, 'PL', 'gbellmf', [100000 2 500000], 'Name', 'Alto');

% Função de Pertinência das Saídas
fis = addMF(fis, "Perfil", 'gbellmf', [25 2 25], 'Name', "Conservador");
fis = addMF(fis, "Perfil", 'gbellmf', [25 2 50], 'Name', "Moderado");
fis = addMF(fis, "Perfil", 'gbellmf', [25 2 75], 'Name', "Agressivo");

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

% Solicitar ao usuário os valores das entradas
carencia = input('Em quanto tempo você precisa do valor investido? Digite um valor de 1 a 10 anos: '); 
aversao = input('De 1 a 3, o quanto você se considera averso ao risco? Sendo 1 - Não me importo em perder; 2 - Gosto de ter riscos controlados; 3 - Sou completamente contra a possibilidade de perder: ');
conhecimento = input('De 1 a 4, o quanto você conhece do mercado? Sendo 1 - Não Conheço; 4 - Conheço muito: ');
pl = input('Digite o valor do seu Patrimonio Liquido, de 1 até R$600.000: ');
carencia = 10;
aversao = 30;
conhecimento = 70;
pl = 300000;

% Calcular a saída usando o sistema Fuzzy
perfil = evalfis(fis, [carencia aversao conhecimento pl]);

% Exibir o perfil resultante
disp(['O perfil do investidor é: ' num2str(perfil)]);