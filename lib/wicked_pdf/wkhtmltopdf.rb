require 'open3'
require 'active_support/core_ext/class/attribute_accessors'

module WickedPdf

  # Responsible for interacting with Wkhtmltopdf
  class Wkhtmltopdf
    include WickedPdf::WickedOptions

    def initialize(config, wkhtmltopdf_binary_path = nil)
      @exe_path = wkhtmltopdf_binary_path
      @exe_path ||= config[:exe_path] unless config.nil? || config.empty?
      @exe_path ||= `which wkhtmltopdf`.chomp
      raise "Location of wkhtmltopdf unknown" if @exe_path.empty?
      raise "Bad wkhtmltopdf's path" unless File.exists?(@exe_path)
      raise "Wkhtmltopdf is not executable" unless File.executable?(@exe_path)
    end

    # generate pdf file from string input using wkhtmltopdf    
    def pdf_from_string(string, options={})
      # -q for no errors on stdout
      command_for_stdin_stdout = "#{@exe_path} #{parse_pdf_options(options)} -q - - " 
      p "*"*15 + command_for_stdin_stdout + "*"*15 unless defined?(Rails) and Rails.env != 'development'
      pdf, err = begin
        Open3.popen3(command_for_stdin_stdout) do |stdin, stdout, stderr|
          stdin.write(string)
          stdin.close
          [stdout.read, stderr.read]
        end
      rescue Exception => e
        raise "Failed to execute #{@exe_path}: #{e}"
      end

      raise "PDF could not be generated!\n#{err}" if pdf and pdf.length == 0
      pdf
    end
      
  end

end
