% Lista de números primos menores que 100
primes([2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97]).

% Limite superior (10^16)
limit(10000000000000000).

% Calcula o fatorial de um número
factorial(0, 1). % Caso base: fatorial de 0 é 1
factorial(N, F) :-
N > 0,
N1 is N - 1,
factorial(N1, F1),
F is N * F1.

% Calcula combinações (n choose r)
choose(N, R, C) :-
factorial(N, FN),     % Calcula o fatorial de N
factorial(R, FR),     % Calcula o fatorial de R
NR is N - R,
factorial(NR, FNR),   % Calcula o fatorial de (N-R)
C is FN // (FR * FNR). % Calcula a combinação usando fatoriais

% Conta quantos multiplos existem de uma combinação de primos
count_multiples(0, _, Product, Count) :-
limit(Limit),
Count is Limit // Product. % Se não há mais primos a considerar, conta os multiplos do produto atual
count_multiples(N, MinIndex, CurrentProduct, TotalCount) :-
primes(Primes),
length(Primes, Length),
N > 0,
MaxIndex is Length - N + 1,
findall(Count, (
    between(MinIndex, MaxIndex, I),
    nth0(I, Primes, Prime), % Pega o primo na posição I
    NextProduct is CurrentProduct * Prime, % Calcula o próximo produto
    limit(Limit),
    NextProduct =< Limit, % Verifica se o produto não excede o limite
    N1 is N - 1,
    NextMinIndex is I + 1,
    count_multiples(N1, NextMinIndex, NextProduct, Count) % Chama recursivamente
), Counts),
sum_list(Counts, TotalCount). % Soma todos os multiplos encontrados

% Função principal para calcular a resposta
main :-
primes(Primes),
length(Primes, NumPrimes),
limit(Limit),
findall(Result, (
    between(4, NumPrimes, NumUsedPrimes), % Itera sobre o número de primos usados, começando com 4
    base_product(NumUsedPrimes, BaseProduct), % Calcula o produto base dos primeiros N primos
    BaseProduct =< Limit, % Verifica se o produto base está dentro do limite
    count_multiples(NumUsedPrimes, 0, 1, LocalCount), % Conta os multiplos para essa combinação
    choose(NumUsedPrimes - 1, 3, Coefficient), % Calcula o coeficiente para a inclusão-exclusão
    Sign is (-1) ^ (NumUsedPrimes - 4), % Alterna o sinal para a inclusão-exclusão
    Result is Sign * LocalCount * Coefficient % Calcula o resultado parcial
), Results),
sum_list(Results, Answer), % Soma todos os resultados parciais
format('Answer: ~d~n', [Answer]). % Imprime a resposta final

% Calcula o produto base para os primeiros N primos
base_product(N, Product) :-
primes(Primes),
take(N, Primes, Prefix), % Pega os primeiros N primos
foldl(multiply, Prefix, 1, Product). % Calcula o produto desses primos

% Pega os primeiros N elementos de uma lista
take(0, _, []) :- !.
take(_, [], []) :- !.
take(N, [H|T], [H|Rest]) :-
N > 0,
N1 is N - 1,
take(N1, T, Rest).

% Multiplica dois números
multiply(X, Y, Z) :- Z is X * Y.

% Executa a função principal ao carregar o arquivo
:- main.