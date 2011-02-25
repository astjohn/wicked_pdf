module WickedPdf

  # This module is responsible for providing the ability to render a pdf to a user's browser 
  module WickedPdfRender 
    
    # Render the pdf if the option is provided, otherwise fall back on rails
    def render(options = nil, *args, &block)
      if options.is_a?(Hash) && options.has_key?(:pdf)
        # logger.info '*'*15 + 'WICKED' + '*'*15
        html_string = render_pdf( (WickedPdf.config || {}).merge(options) )
        pdf = Pdf.new(options, html_string)
        if options[:save_only]
          WickedPdf.save_to_file(pdf, options[:save_to_file])
          # TODO: render nothing?
        else
          WickedPdf.save_to_file(pdf, options[:save_to_file]) if options[:save_to_file]
          show_pdf(pdf, options)
        end
      else
        # rails default render
        super
      end
    end
    
    # send pdf to browser
    def show_pdf(pdf, options)   
      options[:disposition] ||= "inline"

      if options[:show_as_html]
        render :template => options[:template], :layout => options[:layout], :content_type => "text/html"
      else
        send_data(pdf.content, :filename => options[:pdf] + '.pdf', :type => 'application/pdf', :disposition => options[:disposition])
      end
    end
    
    # render the pdf sections and generate pdf
    # returns the html string of the main body
    # TODO: Maybe instead of passing the main body string to wk, we make another temp file
    # to keep things consistant?  Then refactor method to make temp files...
    def render_pdf(options = {})
      # render specific options
      options[:layout] ||= false
      options[:template] ||= File.join(controller_path, action_name)
      
      # render header and footer to separate files
      options = prerender_header_and_footer(options)
      # render main body string
      externals_to_absolute_path(render_to_string(:template => options[:template], :layout => options[:layout]))
    end
    
    
    #######
    private
    #######
    
    # Given an options hash, prerenders content for the header and footer sections
    # to temp files and return a new options hash including the URLs to these files.
    # TODO: perhaps move File operations to wicked_pdf_file...
    def prerender_header_and_footer(options)
      files_to_delete = []
      [:header, :footer].each do |hf|
        if options[hf] && options[hf][:html] && options[hf][:html][:template]
          File.open("/tmp/wicked_pdf_hf_#{rand}.html", "w") do |f|
            
            options_for_render = {
              :template => options[hf][:html][:template],
              :layout => options[:layout]
            }

            options_for_render[:layout] = options[hf][:html][:layout] if options[hf][:html].has_key?(:layout)

            html_string = externals_to_absolute_path(
                            render_to_string(options_for_render)
                          )
  
            f << html_string
            f.flush

            options[hf][:html].delete(:template)
            options[hf][:html][:url] = "file://#{f.path}"
            
            files_to_delete << f.path

          end
        end
      end

      options[:files_to_delete] = files_to_delete
      return options
    end

    def externals_to_absolute_path(html) 
      html.gsub(/(src|href)=('|")\//) { |s| "#{$1}=#{$2}#{request.protocol}#{request.host_with_port}/" }
    end
    

    

  end
  

end
