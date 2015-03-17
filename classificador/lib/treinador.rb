class Treinador
	attr_reader :publicacoes_de_treino, :publicacoes_de_teste, :dicionario_de_termos

	def initialize
		@publicacoes_de_treino = []
	end

	def carregar_publicacoes_de_treino caminho
		CSV.open(caminho) do |csv|
			csv.each do |linha|
				@publicacoes_de_treino << Publicacao.new(linha, self)
			end
		end
		criar_dicionario_de_termos
	end

	def criar_dicionario_de_termos
		@dicionario_de_termos = @publicacoes_de_treino.map do |publicacao| 
			publicacao.termos
		end.flatten.uniq.sort
	end

	def classes
		@publicacoes_de_treino.map { |publicacao| publicacao.linha_csv[6].to_i }
	end

	def vetores_de_treino
		@publicacoes_de_treino.map { |publicacao| publicacao.vetor }
	end
end