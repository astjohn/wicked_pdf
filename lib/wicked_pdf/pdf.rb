module WickedPdf

  # This class renders the string content for the pdf and then uses
  # Wkhtmltopdf to generate the pdf content.  Temporary files generated throughout the process
  # are also removed.
  class Pdf
    attr_accessor :content
  
    def initialize(options, main_body)
      options[:wkhtmltopdf] ||= nil

      make_pdf(options, main_body)
      delete_tmp_files(options)     
    end
    
    # Remove temporary files created by rendering process
    def delete_tmp_files(options)
      files_to_delete = options[:files_to_delete]
      if files_to_delete && files_to_delete.count > 0
        files_to_delete.each do |fpath|
          File.delete(fpath) if File.exists?(fpath)
        end
      end
    end

    # Given the set of options, create the pdf document content using Wkhtmltopdf
    def make_pdf(options = {}, main_body)
      w = Wkhtmltopdf.new(WickedPdf.config, options[:wkhtmltopdf])
      @content = w.pdf_from_string(main_body, options)
    end
    
    
  
  end


end
