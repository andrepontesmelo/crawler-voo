require 'capybara'
require 'capybara/dsl'
require 'pry'

QTD_ITENS_POR_LINHA = 4

Capybara.run_server = false
Capybara.current_driver = :selenium
Capybara.app_host = "http://www.voeazul.com.br"

require 'capybara/poltergeist'
  Capybara.current_driver = Capybara.javascript_driver = :poltergeist
  Capybara.run_server = false
  options = { js_errors: false }
  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, options)
  end

module MyCapybara
  class Crawler
    include Capybara::DSL
    def inicia
      visit("/para-sua-viagem/passagens-aereas-promocionais")
      itens = page.all(:xpath, "//td[@class='az-inst__promo-list__cell az-inst__spacing__pv8']")
      total = (itens.count / QTD_ITENS_POR_LINHA) - 1
      for idx in 0..total do
          base = idx * QTD_ITENS_POR_LINHA;
          valor = itens[base + 2].text.split(' ')[3]
          puts "De #{itens[base].text} Para #{itens[base + 1].text} Valor: #{valor}"
      end
    end
  end
end


crawler = MyCapybara::Crawler.new
crawler.inicia
