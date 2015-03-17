require 'json'

class String
	JSON_CIDADES = JSON.parse(IO.read("support/cidades_do_brasil.json"))
	ESTADOS_E_CIDADES = JSON_CIDADES.each_with_object({}) do |(k,v), h|
		h[k.downcase] = v.downcase
	end
	LISTA_DE_CIDADES = ESTADOS_E_CIDADES.keys.sort_by { |c| c.length }.reverse
	CIDADES_UNIDAS = LISTA_DE_CIDADES.map { |city| "(\\b#{city}\\b)" }.join("\|")
	CIDADES_EXPREG = Regexp.new "#{CIDADES_UNIDAS}|\\s"
	EXCECOES = [
		"a", "e", "o", "de", "do", "da", "dos", "das", 
		"os", "as", "se", "meu", "que", "teu", "ou", "eu",
		"é", "à", "um", "uma", "uns", "umas", "RT"
	]

	def tokenizar
		termos = self.downcase.split(CIDADES_EXPREG).map! { |termo| termo.gsub(/\p{^Alnum}\s/, '') }
		termos.delete_if do |termo| 
		  termo == "" || EXCECOES.include?(termo) || termo.include?("http") || 
		  termo.include?("@") || termo.include?("kk") || termo.include?("haha")
		end
	end
end