require 'twitter'

class Twitter
	def initialize
		@cliente = Twitter::REST::Client.new do |config|
		  config.consumer_key        = "DbT8fYWR2jq1TIXvxVtiZzFno"
		  config.consumer_secret     = "3mT9JcwgaWs5gTJqOihbGAlRplHTKQapJMNQtnAWufYMVyUmle"
		  config.access_token        = "42659961-4wDJCea7t1KVf1FMqUK5H2k2zgBaE26GpI5kjC3CK"
		  config.access_token_secret = "OjhVszJ3Dyivaz0gGhHUuKn5N7cYqE0jUinoaFiWK7FjY"
		end
	end

	def buscar data_limite, expressao, caminho_arquivo
		data_publicacao = Time.now
		id_maximo = nil

		while publication_date > data_limite
			publicacaoes = @cliente.search(expressao, lang: "pt", max_id: id_maximo).to_a
			data_publicacao = publicacaoes.last.created_at
			id_maximo = publicacoes.last[:id] - 1
			CSV.open(caminho_arquivo, "a+") do |csv|
				publicacoes.each do |publicacao| 
					csv << [publicacao[:id], publicacao.created_at, publicacao.text, publicacao.geo.latitude, publicacao.geo.longitude, publicacao.user.location]
				end
			end
		end
	end
end