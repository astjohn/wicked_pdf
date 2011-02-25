# -*- encoding: utf-8 -*-
require File.expand_path("../lib/wicked_pdf/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "wicked_pdf"
  s.version     = WickedPdf::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Miles Z. Sterrett", "Jonathan Chang", "Adam St. John"]
  s.email       = ["miles.sterrett@gmail.com", "unknown", "astjohn@gmail.com"]
  s.homepage    = "https://github.com/astjohn/wicked_pdf"
  s.summary     = "Easy pdf creation using rails' views."
  s.description = "Wicked PDF uses the wkhtmltopdf library to generate pdf documents from views."

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency "bundler", "~> 1.0.0"
  s.add_dependency "rails", ">= 3.0.1"
  s.add_development_dependency "rspec", ">= 2.1.0"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
