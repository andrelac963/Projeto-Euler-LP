from math import factorial

# Lista de números primos menores que 100
primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97]

# Limite superior para os números que estamos considerando
N = 10**16

def count_multiples(n, min_index, current_product):
    # Função recursiva para contar quantos números são divisíveis por um produto de 'n' primos distintos.
    # - n: número de primos a serem usados no produto
    # - min_index: índice mínimo na lista de primos para começar a considerar
    # - current_product: produto atual dos primos selecionados
    if n == 0:
        # Se não precisamos mais selecionar primos, retornamos quantos múltiplos existem
        return N // current_product

    total = 0
    # Iterar sobre os primos começando do índice mínimo
    for i in range(min_index, len(primes) - n + 1):
        next_product = current_product * primes[i]
        if next_product > N:
            # Se o próximo produto exceder N, paramos a busca
            break
        # Adiciona à contagem o resultado da chamada recursiva
        total += count_multiples(n - 1, i + 1, next_product)

    return total

def choose(n, r):
    #Calcula combinações (n escolhe r), ou seja, quantas maneiras podemos escolher 'r' itens de 'n'.
    if r > n:
        return 0
    return factorial(n) // (factorial(r) * factorial(n - r))

def main():
    answer = 0
    sign = 1  # Alterna entre positivo e negativo para o princípio da inclusão-exclusão

    # Itera sobre o número de primos distintos a serem considerados, começando de 4
    for num_primes in range(4, len(primes) + 1):
        base_product = 1
        # Calcula o produto base dos primeiros 'num_primes' primos
        for i in range(num_primes):
            base_product *= primes[i]
        if base_product > N:
            # Se o produto base já é maior que N, não faz sentido continuar
            break
        
        # Conta quantos números são divisíveis por produtos de 'num_primes' primos
        local_count = count_multiples(num_primes, 0, 1)
        
        # Calcula o coeficiente combinatório necessário
        coefficient = choose(num_primes - 1, 3)
        
        # Atualiza a resposta usando o princípio da inclusão-exclusão
        answer += sign * local_count * coefficient
        
        # Alterna o sinal para a próxima iteração
        sign *= -1

    print("Answer:", answer)

# Executa a função principal
main()