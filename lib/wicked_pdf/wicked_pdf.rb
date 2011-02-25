module WickedPdf

  class << self
    # To store configuration settings from rails initializer
    @@config = {}
    cattr_accessor :config
  end

end
