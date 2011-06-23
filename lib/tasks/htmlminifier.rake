require "nokogiri"
task :htmlminifier => :environment do

  viewfolderpath = RAILS_ROOT+ "/app/views"
  publicfolderpath = RAILS_ROOT + "/public"
  minify_html(viewfolderpath)
  minify_html(publicfolderpath)

end

  def minify_html(folder)

    Dir.foreach(folder) do |entry|

      if entry != "." and entry != ".." && entry != "$Recycle.Bin" && entry != ".rnd"

        if File::directory?(folder + "/" + entry)

          minify_html(folder + "/" + entry)

        else

            ext = File.extname(folder + "/" + entry)

            case ext

              when ".html", ".erb"

                  # yes we got a file to minify it
                                    
                  if File.readable?(folder + "/" + entry) and File.writable?(folder + "/" + entry)

                    doc = IO.read(folder + "/" + entry)

                    File.delete(folder + "/" + entry)

                    file = File.open(folder + "/" + entry,"w+")

                    doc = Nokogiri::HTML(doc)

                    splitandwrite(file,doc)

                    #doc.scan(/<[^>]+>/).each do |tag|
                    #  file.write(tag + "\n")
                    #end
                    file.close

                  end
              
            end

        end

      end

    end

  end

  def splitandwrite(file,doc)

    if doc.xpath('*').count > 0

      doc.xpath('*').each do |tag|

          begin
            splitandwrite(file,Nokogiri::HTML(tag))
          rescue
            splitandwrite(file,tag)
          end

      end

    else

      writetofile(file,doc)

    end

  end

  def writetofile(file,str)
      file.write(str.to_s + "\n")
      puts "-------"
      puts str.to_s
      puts "-------"
  end