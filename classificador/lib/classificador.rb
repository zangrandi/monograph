require 'csv'
require 'libsvm'

class Classificador
	attr_reader :problema, :parametro, :termos_excecao, :treinador, :modelo, :publicacoes

	def initialize
		@problema = Libsvm::Problem.new
		@parametro = Libsvm::SvmParameter.new
		@treinador = Treinador.new
		@publicacoes = []
		inicializa_parametros
	end

	def inicializa_parametros
		@parametro.c = 0.1
		@parametro.cache_size = 1
		@parametro.eps = 0.001
	end

	def carregar_publicacoes_de_treino caminho
		@treinador.carregar_publicacoes_de_treino caminho
	end

	def definir_modelo
		@problema.set_examples(@treinador.classes, @treinador.vetores_de_treino)
		@modelo = Libsvm::Model.train(@problema, @parametro)
	end

	def carregar_publicacoes caminho
		CSV.open(caminho) do |csv|
			csv.each do |linha|
				@publicacoes << Publicacao.new(linha, @treinador)
			end
		end
	end

	def testar_modelo caminho_saida
		definir_modelo
		CSV.open(caminho_saida, "w") do |csv|
			@publicacoes.each do |publicacao|
				linha_csv = publicacao.linha_csv
				classe = @modelo.predict(publicacao.vetor)
				linha_csv[6] = classe
				linha_csv[7] = publicacao.cidade
				linha_csv[8] = publicacao.estado
				csv << linha_csv
			end
		end
	end

	def frequencia_de_palavras
		frequencia = Hash.new(0)
		@publicacoes.each do |publicacao|
			publicacao.termos.each { |termo| frequencia[termo] += 1 }
		end
		frequencia
	end
end