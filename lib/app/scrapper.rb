require 'open-uri'
# frozen_string_literal: true

class Scrapper
  attr_accessor :hash_emails, :urls, :urlsdep
  @@quellemairieestscrappee = []
  
  def initialize
    @hash_emails = []
    @urls = []
    @urlsdep = []
    # @@quellemairieestscrappee = []
    @email = []
    @ville = []
  end
##laisser choix ud departement?
  def get_townhall_urls
    
    doc2 = Nokogiri::HTML(open('http://annuaire-des-mairies.com/')) # recuperation des urls
    doc2.xpath('//p/map/area').each.with_index { |node| @urlsdep << node['href'] }
    @urlsdep.map! { |url| "http://www.annuaire-des-mairies.com/" + url } && @urlsdep.pop(5) && @urlsdep.delete_if { |url| url.include?("#") } # restructuration des urls
    # p @urlsdep
    3.times do |i|
      nomdelamairie = @urlsdep[rand(95)]
      puts "#{i+1}. Recuperation des adresses des mairies de #{nomdelamairie[36..-6].capitalize}..."
      @@quellemairieestscrappee << nomdelamairie
      doc = Nokogiri::HTML(open(nomdelamairie)) # recuperation des urls
      doc.xpath('//p/a[@class = "lientxt"]').each { |node| @urls << node['href'][1..-1]}
    end
    puts "On scrappe ces mairies cette fois ci :"
    @@quellemairieestscrappee.each do |mairie|
      puts "> #{mairie[36..-6].capitalize}"
    end
    # @urlsdep.each do |urlsdepartement| toutes les mairies de france
    #   doc = Nokogiri::HTML(open(urlsdepartement)) # recuperation des urls
    #   doc.xpath('//p/a[@class = "lientxt"]').each { |node| @urls << node['href'][1..-1] }
    # end
    @urls.map! {|url| "https://www.annuaire-des-mairies.com" + url } # restructuration des @urls
   end
 
  def get_townhall_email(urls)
    compteur = urls.count # creation d'un compteur
    urls.each.with_index do |townhall_url, i| # recuperation nom de ville et emails
      break if i == 5
      doc = Nokogiri::HTML(open(townhall_url))
      doc.xpath('//html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]').each { |node| @email << node.text }
      puts "Collection des emails en cours.. Numero : #{compteur -= 1}\n #{townhall_url[40..-6].capitalize}"
      doc.xpath('//strong/a[@class = "lientxt4"]').each { |node| @ville << node.text.capitalize }
    end
    @ville.size.times { |i| @hash_emails << { @ville[i] => @email[i] } } # creation du hash
  end

  def self.all
    return @@quellemairieestscrappee
  end

  def save_as_json
    File.open('db/urls.json', 'w') do |f|
      f.write(@urls.to_json)
    end

    File.open('db/urlsdep.json', 'w') do |f|
      f.write(@urlsdep.to_json)
    end

    File.open('db/emails.json', 'w') do |f|
      f.write(@hash_emails.to_json)
    end
    puts "\nEmails des mairies de #{@@quellemairieestscrappee[0][36..-6].capitalize}, #{@@quellemairieestscrappee[1][36..-6].capitalize} et #{@@quellemairieestscrappee[2][36..-6].capitalize} enregistrees au format CSV dans 'db/emails.json'"
  end

  def save_as_csv
    CSV.open('db/emails.csv', 'w') do |csv| # On ouvre le fichier csv
      @hash_emails.each.with_index { |haash, i| csv << [i + 1, haash.keys.to_s[2..-3], haash.values.to_s[2..-3]] } # Et on stock nos valeurs sans leurs guillemets, avec un numero de ligne devant
    end
    puts "\nEmails des mairies de #{@@quellemairieestscrappee[0][36..-6].capitalize}, #{@@quellemairieestscrappee[1][36..-6].capitalize} et #{@@quellemairieestscrappee[2][36..-6].capitalize} enregistrees au format CSV dans 'db/emails.csv'"
  end
end



# /html/body/div/main/section[1]/div/div/div/p[5]/map/area[49]
# 
# scrap = Scrapper.new('http://annuaire-des-mairies.com/val-d-oise.html')
# scrap.

# # Gets content of A2 cell.
# p ws[2, 1]  #==> "hoge"

# # Changes content of cells.
# # Changes are not sent to the server until you call ws.save().
# ws[2, 1] = "foo"
# ws[2, 2] = "bar"
# ws.save

# # Dumps all cells.
# (1..ws.num_rows).each do |row|
#   (1..ws.num_cols).each do |col|
#     p ws[row, col]
#   end
# end

# # Yet another way to do so.
# p ws.rows  #==> [["fuga", ""], ["foo", "bar]]

#        # Reloads the worksheet to get changes by other clients.
#      ws.reload

#      # Uploads a local file.
#      session.upload_from_file("/path/to/hello.txt", "hello.txt", convert: false)
# #
# #     # Gets list of remote files.
#     session.files.each do |file|
#       p file.title
#     end
# #         # Downloads to a local file.
#     file = session.file_by_title("Mairies")
#     file.export_as_file("/home/deo/THP/S3J2_save_data/db/Mairies.ods")
#     file.export_as_file("/home/deo/THP/S3J2_save_data/db/Mairies.pdf")
#
