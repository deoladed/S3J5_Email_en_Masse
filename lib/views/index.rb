require 'app/emailer.rb'
require 'app/scrapper.rb'

class Index # Un petit menu pour laisser un peu le choix. Beaucoup de texte, desole

	attr_accessor :scrap

  def initialize
  	@scrap = Scrapper.new # Allez, on appelle la classe scrapper
    puts 'Hey salut! On pompe les emails des mairies de France'
    puts 'Allez, on prend trois departements au pif'
    launcher(menu) # On lance le menu
  end

	def menu # Un peu de choix, humour de tres bas niveau, 3 semaines a THP ca ne fait pas que du bien...
    puts 'Je te les enregistre en quoi ?'
    puts '1 - Json power'
    puts '3 - CSV style'
    puts '4 - Je suis gourmand(e), je veux les 2 !'
    puts '5 - On les enregistre, puis on leur ecrit aussi!'
    puts "99 - R, niet, nada de quepouic, ca ne m'interesse pas ton truc"
    reponse = gets.chomp.to_i
  end

  def launcher(reponse) # Et la fonction qui lance le choix, on coupe parce que ca faisait plus de 10 lignes #face_d'ange
    
    case reponse # Et on lui applique les methodes en fonction du choix utilisateur
    when 1
    	# 3.times do 
    	@scrap.get_townhall_email(@scrap.get_townhall_urls) && @scrap.save_as_json
    	# end #Je lance la recuperation des emails a chaque fois car si l'utilisateur quiite il ne les chargera pas pour rien
    when 3
      @scrap.get_townhall_email(@scrap.get_townhall_urls) && @scrap.save_as_csv
    when 4
      @scrap.get_townhall_email(@scrap.get_townhall_urls) && @scrap.save_as_json
      @scrap.save_as_csv
     when 5
     	puts "On envoie un petit email aux mairies de : "
     	puts Scrapper.all[0..2]
     	print "Nombre d'email a envoyer : "
     	puts Scrapper.all[3] 
      p @scrap.hash_emails
     	# Emailer.new.send_message(Scrapper.all[4])
    	when 99
     puts "Job. Done."
     return
    else
    	puts "Choix inexistant"
    end
    puts "\nT'en veux encore ?!"
    launcher(menu) #On boucle sur le menu
  end
end