require 'open-uri'
# frozen_string_literal: true

class Scrapper
  attr_accessor :urlsdepartement, :ville, :email
  @@ensemble = []
  @@urls = []
  def initialize
    @urlsdepartement = []
    @ville = []
    @email = []
  end
#revoir variables @ et @@
#envoyer to json(mavaraible) --> nom et fichier
##laisser choix ud departement?
#ressortir nom des mairires scrappees?
  def get_townhall_urls
    @urlsdep = []
    doc2 = Nokogiri::HTML(open('http://annuaire-des-mairies.com/')) # recuperation des urls
    doc2.xpath('//p/map/area').each.with_index { |node| @urlsdep << node['href'] }
    @urlsdep.map! { |url| "http://www.annuaire-des-mairies.com/" + url } && @urlsdep.pop(5) # restructuration des urls
    save_as_json

    quellemairieestscrappee = []
    3.times do 
      nomdelamairie = @urlsdep[rand(95)]
      quellemairieestscrappee << nomdelamairie
      doc = Nokogiri::HTML(open(nomdelamairie)) # recuperation des urls
      doc.xpath('//p/a[@class = "lientxt"]').each { |node| @@urls << node['href'][1..-1]}
    end
    puts "On scrappe ces mairies cette fois ci : #{quellemairieestscrappee}"
    # urlsdep.each do |urlsdepartement|
    #   doc = Nokogiri::HTML(open(urlsdepartement)) # recuperation des urls
    #   doc.xpath('//p/a').each { |node| @@urls << node['href'][1..-1] }
    # end
    @@urls.map! {|url| "https://www.annuaire-des-mairies.com" + url } # restructuration des @@urls
    save_as_json
    @@urls
   end
 
  def get_townhall_email(urls)
    p urls
    compteur = urls.count # creation d'un compteur pour le fun, plus visuel et interactif
    urls.each.with_index do |townhall_url, i| # recuperation nom de ville et emails
      # break if i == 20
      doc = Nokogiri::HTML(open(townhall_url))
      doc.xpath('//html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]').each { |node| @email << node.text }
      puts "Collection des emails en cours.. Numero : #{compteur -= 1}"
      doc.xpath('//strong/a[@class = "lientxt4"]').each { |node| @ville << node.text.capitalize }
     end

    @ville.size.times { |i| @@ensemble << { @ville[i] => @email[i] } } # creation du hash
  end


  def save_as_json
    File.open('db/urls.json', 'w') do |f|
      f.write(@@urls.to_json)
    end

    File.open('db/urlsdep.json', 'w') do |f|
      f.write(@urlsdep.to_json)
    end

    File.open('db/emails.json', 'w') do |f|
      f.write(@@ensemble.to_json)
    end
  end

  def perform
    get_townhall_email(get_townhall_urls)
    save_as_json
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
