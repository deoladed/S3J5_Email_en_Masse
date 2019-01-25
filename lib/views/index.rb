# require 'app/emailer.rb'
require 'app/scrapper.rb'

class Index # Un petit menu pour laisser un peu le choix. Beaucoup de texte, desole

  def initialize
    puts 'Hey salut! On pompe les emails des mairies de France'
    launcher(menu) # On lance le menu
  end

	def menu # Un peu de choix, humour de tres bas niveau, 3 semaines a THP ca ne fait pas que du bien...
    puts 'Je te les enregistre en quoi ?'
    puts '1 - Json power'
    puts '2 - Google spreadshIt'
    puts '3 - CSV style'
    puts '4 - Je suis gourmand(e), je veux les 3 !'
    puts '5 - On les envois aux mairies de France'
    puts "99 - R, niet, nada de quepouic, ca ne m'interesse pas ton truc"
    reponse = gets.chomp.to_i
  end

  def launcher(reponse) # Et la fonction qui lance le choix, on coupe parce que ca faisait plus de 10 lignes #face_d'ange
    scrap = Scrapper.new # Allez, on appelle la classe scrapper
    case reponse # Et on lui applique les methodes en fonction du choix utilisateur
    when 1
    	# 3.times do 
    	scrap.get_townhall_email(scrap.get_townhall_urls) && scrap.save_as_json
    	# end #Je lance la recuperation des emails a chaque fois car si l'utilisateur quiite il ne les chargera pas pour rien
    when 2
      # scrap.get_townhall_email(scrap.get_townhall_urls) && scrap.save_as_spreadsheet # Mise en commentaire pour raisons evidentes
    when 3
      scrap.get_townhall_email(scrap.get_townhall_urls) && scrap.save_as_csv
    when 4
      scrap.get_townhall_email(scrap.get_townhall_urls) && scrap.save_as_json #&& scrap.save_as_spreadsheet
      scrap.save_as_csv
     when 5
     	puts "Fonctionnalite en cours"
    else
     puts "Job. Done."
     return
    end
    puts "\nT'en veux encore ?!"
    launcher(menu) #On boucle sur le menu
  end
end