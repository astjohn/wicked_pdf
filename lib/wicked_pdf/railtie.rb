require 'wicked_pdf'
require 'rails'

module WickedPdf
  
  class WickedRailtie < Rails::Railtie
    initializer "wicked_pdf.register" do |app|
      ActionView::Base.send :include, WickedPdfHelpers
      ActionController::Base.send :include, WickedPdf::WickedPdfRender

      Mime::Type.register 'application/pdf', :pdf
    end
  end
end
