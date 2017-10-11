# QBMinesweeper

Esta aplicação é parte de uma avaliação do desenvolvimento de um miniprojeto de Game Engine por um mero estagiário, use por sua conta e risco!
A documentação a seguir tem o propósito maior de ser um log de desenvolvimento, portanto qualquer dúvida em relação a funcionamento é bem vinda.

## Quick Usage

Para um rápido uso sem muita conversa da Game Engine, instale as seguintes gems:

* colorize
* sinatra
* sinatra-flash
* pry

Abra a pasta /src e rode o cli_app.rb ou o email_usage.rb com o comando

```ruby cli_app.rb``` ou ```ruby email_usage.rb```

Como alternativa, você pode rodar a versão com interface gráfica na pasta /sinatra_minesweeper com

```ruby app.rb```

e abrindo o navegador em localhost:4567. Use o botão esquerdo para descobrir uma célula e o botão direito para colocar/remover flag


## A Game Engine

O QBMinesweeper é uma Game Engine do jogo popular conhecido como [Campo Minado (Minesweeper)]
(https://pt.wikipedia.org/wiki/Campo_minado).

Conforme os requisitos pedidos no projeto, a Engine fornece uma interface de métodos que podem ser chamados pelo cliente para interagir com o jogo: clicar em uma célula, saber o status do tabuleiro, saber se o jogo já acabou etc.


## Requisitos do Projeto (Resumo)

	* Aplicação na linguagem Ruby com uma interface no terminal para interagir com o usuário
	* Receber altura, largura e numero de bombas do usuário
	* Métodos que implementem as seguintes features:
		* Clicar na célula
		* Marcar céula com uma flag
		* Retornar se o jogo ainda está em andamento
		* Retorna se o usuário venceu o jogo
		* Estado do tabulerio
	* As células descobertas devem exibir o número de bombas adjacentes
	* Duas classes de impressao (Simple Printer e Pretty Printer)
	* Encerrar o jogo caso uma célula sem bandeira for clicada e ela for uma bomba
	* Não é necessária uma interface gráfica
	* Demonstrar que o projeto funciona conforme a especificação, da forma que achar conveniente
	* Os requisitos detalhados do projeto podem ser encontrados [aqui] (http://dontpad.com/qbminesweep)

## Algumas alterações nos requisitos
	* Alterei o nome dos seguintes metodos:
		* Minesweeper#play -> Minesweeper#game_check_cell
		* Minesweeper#flag -> Minesweeper#game_set_flag
		* Minesweeper#Printer.print -> Minesweeper#Printer.print_state
	* Celula sem bombas em volta são indicadas com 0


## Features Extra-requisitos

Além dos requisitos especificados no escopo do projeto, o QBMinesweeper fornece os seguintes recursos para otimizar a experiência do usuário

	* Interface gráfica: Permite a utilização do mouse usando o lado esquerdo para descobrir uma célula e lado direito para inserir/remover uma bandeira
	* Recurso de Salvar e Carregar jogo anterior: Utilizando arquivos json, a Engine permite armazenar o estado atual e poder utilizar o mesmo estado em um novo jogo


## Aplicaçöes no Projeto

Alguns cuidados foram tomados para o desenvolvimento do projeto (talvez não com perfecção, mas tentei aplicar sabendo a importância ;) )

	* Versionamento no Github - não cheguei a utilizar branches, mas estive sempre commitando a cada novo recurso o hotfix
	* Código em inglês
	* Convenções do ruby - utilizei a gem rubocop para tentar manter o código alinhado o máximo possível com as boas práticas da linguagem
	* Testes de unidade - utilizei o minitest para poder realizar os testes. Utilizei um arquivo de teste.json para poder fazer as asserções
	* Modularização - separei as classes em vários arquivos para ter maior controle
	* Debug - utilização da gem pry para debugar durante o desenvolvimento do projeto
	* Sinatra - apesar de não estar no escopo do projeto, julguei importante a aprendizagem no framework por estar mais próximo ao rails

## Dificuldades

	* Linguagens, gems e frameworks nao familiares: Javascript, Sinatra, Shoes, CSS, catpix, rubocop, minitest
	* Manter as boas praticas com a ajuda do rubocop
	* Criacao de testes de unidades
	* Adaptação do código para o console no framework Sinatra
	* Projetar a arquitetura do projeto
	* Bugs aparecendo sobre demanda conforme testava

## Bugs
	* O numero de colunas maxima que ele suporta no terminal eh 17 senao ele quebra a impressao (isso pode ser facilmente resolvido removendo o \t mas vai ficar mais feio)

## Log e tempo de desenvolvimento

	Esse log reflete apenas uma aproximação no tempo de execução de cada tarefa, não necessariamente sobre essa ordem. Inclusive muitos deles foram realizados paralelamente. Tentei aproveitar o máximo de tempo para desenvolver o projeto, em média 4 horas por dia

	1. Criação do repositório no Github
	2. Implementação da lógica básica do jogo no terminal (1 dia, ~4 horas)
		* Nessa etapa toda lógica da Engine estava montada, com uma representação básica de impressão no terminal
		* O Minesweeper já estava jogável
	3. Estudo de interfaces gráficas - Shoes (2 dias, ~2 horas)
		* Como estava difícil de jogar pelo terminal, resolvi tentar criar uma interface gráfica. Comecei tentando pela ferramenta Shoes, mas sem muito sucesso devido a algumas limitacoes do framework
	4. Identificação e correção de alguns bugs (7 dias ~2 horas)
		* Bugs como clicar em local que já tem flag, erros na hora de criar linha diferente de coluna surgiram.
	5. Estudo de interfaces gráficas - Sinatra (4 dias ~3 horas)
		* Estudei como funciona o sinatra baseado em algumas aplicaçöes já realizadas dentro do setor
		* Tive que estudar um pouco de javascript para conseguir fazer a ponte entre o código ruby e a view
		* Adaptaçao de todo o código ruby puro para sinatra
	6. Refatoração de código (1 dia ~3 horas)
		* Modularizãção das classes em vários arquivos. Antes só existia apenas um único arquivo .rb
		* Com muita ajuda da gem rubocop refatorei o meu código para remover os code-smells e tentar alinhar às convenções de ruby
		* A partir dessa etapa utilizei o rubocop para todo o resto do processo de desenvolvimento
	7. Criação dos testes de unidade (1 dia ~3 horas)
		* Estudo do minitest
		* Apesar de não utilizar para TDD adaptei para um teste de assertividade baseado em um estado já existente
	8. Extras
		* Redigir este README no github!

