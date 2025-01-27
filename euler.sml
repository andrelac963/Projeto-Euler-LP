(* Lista de números primos menores que 100 *)
val primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97]

(* Limite superior para os números que estamos considerando, construído incrementalmente para evitar erros de literal grande *)
val limit = IntInf.* (IntInf.fromInt 100000000, IntInf.fromInt 100000000)

(* Função para calcular o fatorial usando IntInf para lidar com grandes números *)
fun factorial 0 = IntInf.fromInt 1
| factorial n = IntInf.* (IntInf.fromInt n, factorial (n - 1))

(* Função para calcular combinações (n escolhe r) usando IntInf *)
fun choose (n, r) =
  if r > n then IntInf.fromInt 0
  else IntInf.div (factorial n, IntInf.* (factorial r, factorial (n - r)))

(* Função recursiva para contar múltiplos de produtos de 'n' primos distintos usando IntInf *)
fun countMultiples (0, _, product) = IntInf.div (limit, product)
| countMultiples (n, minIndex, currentProduct) =
    let
      (* Função auxiliar para iterar sobre os primos e acumular o total *)
      fun loop i total =
          if i >= length primes - n + 1 then total
          else
              let
                val prime = List.nth (primes, i)  (* Pega o primo na posição i *)
                val nextProduct = IntInf.* (currentProduct, IntInf.fromInt prime)  (* Calcula o próximo produto *)
              in
                if IntInf.> (nextProduct, limit) then total  (* Se o produto excede o limite, para *)
                else loop (i + 1) (IntInf.+ (total, countMultiples (n - 1, i + 1, nextProduct)))  (* Continua a busca *)
              end
    in
      loop minIndex (IntInf.fromInt 0)  (* Inicia o loop com índice mínimo e total zero *)
    end

(* Função principal para calcular a resposta usando IntInf *)
fun main () =
  let
    (* Função auxiliar para aplicar o princípio da inclusão-exclusão *)
    fun loop numPrimes sign answer =
        if numPrimes > length primes then answer  (* Se usamos todos os primos, retorna a resposta acumulada *)
        else
            let
              (* Calcula o produto base dos primeiros 'numPrimes' primos *)
              val baseProduct = List.foldl (fn (p, acc) => IntInf.* (IntInf.fromInt p, acc)) (IntInf.fromInt 1) (List.take (primes, numPrimes))
              val localCount = countMultiples (numPrimes, 0, IntInf.fromInt 1)  (* Conta os múltiplos para este número de primos *)
              val coefficient = choose (numPrimes - 1, 3)  (* Calcula o coeficiente combinatório necessário *)
              (* Atualiza a resposta usando o sinal alternado do princípio da inclusão-exclusão *)
              val newAnswer = IntInf.+ (answer, IntInf.* (IntInf.fromInt sign, IntInf.* (localCount, coefficient)))
            in
              if IntInf.> (baseProduct, limit) then answer  (* Se o produto base já excede o limite, retorna a resposta *)
              else loop (numPrimes + 1) (~sign) newAnswer  (* Continua para o próximo número de primos, alternando o sinal *)
            end
  in
    loop 4 1 (IntInf.fromInt 0)  (* Inicia o loop com 4 primos, sinal positivo e resposta inicial zero *)
  end

(* Executa a função principal e imprime o resultado *)
val _ = print ("Answer: " ^ IntInf.toString (main ()) ^ "\n")