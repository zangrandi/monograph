class CSVHandler
	def self.filtrar_arquivo_de_classificacoes caminho_entrada, caminho_saida, valor
		CSV.open(caminho_entrada) do |csv_entrada|
			CSV.open(caminho_saida, 'w') do |csv_saida|
				csv_entrada.each do |linha_entrada|
					csv_saida << linha_entrada if linha_entrada[6] == valor
				end
			end
		end
	end

	def self.salvar_geolocalizacao entrada, entrada_2, saida
		linhas = []
		cidades = []

		CSV.open(entrada) do |csv|
			csv.each do |linha|
				linhas << linha
			end
		end		

		CSV.open(entrada_2) do |csv|
			csv.each do |linha|
				cidades << linha
			end
    end

    resultados = []
    linhas.each do |linha|
    	encontrada = cidades.find do |cidade|
    		cidade[0] == linha[7]
    	end

    	if encontrada
    		linha[3] = encontrada[1] if linha[3].nil?
    		linha[4] = encontrada[2] if linha[4].nil?
    	end

    	resultados << linha
    end

    CSV.open(saida, "w") do |csv|
    	resultados.each do |resultado|
    		csv << resultado
    	end
    end
	end

	def self.filtrar_textos entrada, saida
		CSV.open(entrada) do |csv|
			CSV.open(saida, "w") do |csv_saida|
				csv.each do |row|
					# row[2] = row[2].gsub(/https*:\/\/t.co.+/,"")
					unless row[2].include?("https://t.co") || row[2].include?("http://t.co")
						csv_saida << row
					end
				end
			end
		end
	end

	def self.salvar_cidade_estado entrada, saida
		CSV.open(entrada) do |csv|
			CSV.open(saida, "w") do |csv_saida|
				csv.each do |row|
					publicacao = Publicacao.new(row)
					row[7] = publicacao.cidade
					row[8] = publicacao.estado
					csv_saida << row
				end
			end
		end
	end
end