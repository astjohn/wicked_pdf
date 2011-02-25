module WickedPdf

  # Responsible for providing the ability to save a pdf to a file 
  class << self

    # save pdf file
    def save_to_file(pdf, path)
      File.open(path, 'wb') {|file| file << pdf.content } 
    end

  end
  
  

end
