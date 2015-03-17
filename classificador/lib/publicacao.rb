class Publicacao
  attr_reader :termos, :vetor, :linha_csv, :texto, :horario, :latitude, 
  	:longitude, :cidade, :localizacao_no_perfil

	def initialize linha, treinador = nil
		@linha_csv = linha
		@id = @linha_csv[0]
		@horario = @linha_csv[1]
		@texto = @linha_csv[2]
		@latitude = @linha_csv[3]
		@longitude = @linha_csv[4]
		@localizacao_no_perfil = @linha_csv[5]
		@treinador = treinador
		@termos = @texto.tokenizar
		@cidade = extrair_cidade
	end

	def extrair_cidade
		cidade = ""
		@termos.each do |termo|
			if String::LISTA_DE_CIDADES.include?(termo)
				cidade = termo
			end
		end
		if cidade == "" && @localizacao_no_perfil
			@localizacao_no_perfil.tokenizar.each do |termo|
				if String::LISTA_DE_CIDADES.include?(termo)
					cidade = termo
				end
			end
		end
		cidade
	end

	def estado
		String::ESTADOS_E_CIDADES[@cidade]
	end

	def vetor
		if @treinador
			vetor = @treinador.dicionario_de_termos.map do |termo| 
				@termos.include?(termo) ? 1 : 0
			end
			Libsvm::Node.features(vetor)
		end
	end
end