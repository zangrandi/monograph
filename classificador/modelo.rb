["classificador", "publicacao", "string", "treinador", "medidor", "csv_handler"].each do |file|
	require "./lib/#{file}.rb"
end

classificador = Classificador.new
classificador.carregar_publicacoes_de_treino "support/publicacoes_de_treino.csv"
classificador.carregar_publicacoes "support/publicacoes.csv"
classificador.testar_modelo "support/publicacoes_classificadas.csv"