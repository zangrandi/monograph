class Medidor
	def self.taxa_de_acerto caminho
		CSV.open(caminho) do |csv|
			num_positivas = 70
			acertos_positivas, erros_positivas = 0, 0 
			acertos_negativas, erros_negativas = 0, 0
			contador = 0
			
			csv.each do |linha|
				contador += 1
				if contador <= num_positivas
					linha[6] == "1.0" ? acertos_positivas+=1 : erros_positivas+=1
				else
					linha[6] == "-1.0" ? acertos_negativas+=1 : erros_negativas+=1
				end
			end

			taxa_de_acerto_positivas = (1 - erros_positivas.to_f/acertos_positivas.to_f).round(2) * 100
			taxa_de_acerto_negativas = (1 - erros_negativas.to_f/acertos_negativas.to_f).round(2) * 100
			taxa_de_acerto_geral = (taxa_de_acerto_positivas + taxa_de_acerto_negativas) / 2

			result = "Acertos positivas: #{acertos_positivas} \n"
			result << "Erros positivas: #{erros_positivas} \n"
			result << "Taxa de acertos positivas: #{taxa_de_acerto_positivas}% \n"
			result << "Acertos negativas: #{acertos_negativas} \n"
			result << "Erros negativas: #{erros_negativas} \n"
			result << "Taxa de acertos negativas: #{taxa_de_acerto_negativas}% \n"
			result << "----------------------------------------------------- \n"
			result << "Taxa de acertos geral: #{taxa_de_acerto_geral}% \n"
		end
	end

	def self.taxa_com_cidade caminho
		com = 0
		total = 0
		CSV.open(caminho) do |csv|
			csv.each do |row|
				total += 1
				com += 1 unless row[8].nil? 
			end
		end

		percentage = "#{(com.to_f / total.to_f) * 100}%"
		result = "#{total}\n"
		result << "#{com}\n"
		result << "#{percentage}"
	end

	def self.taxa_com_geolocalizacao caminho
		rows_with_geo = []
		rows = []
		CSV.open(caminho) do |csv|
			csv.each do |row|
				rows << row
				rows_with_geo << [row[3], row[4]] unless row[3].nil? || row[4].nil?
			end
		end

		percentage = "#{(rows_with_geo.length.to_f / rows.length.to_f) * 100}%"
		result = "#{rows.length}\n"
		result << "#{rows_with_geo.length}\n"
		result << "#{percentage}"
	end
end