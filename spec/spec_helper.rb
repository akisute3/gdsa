# coding: utf-8
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.order = :random

  # seed-fu
  config.before(:suite) do
    SeedFu.seed
  end

  # FactoryGirl
  require 'factory_girl_rails'
  config.include FactoryGirl::Syntax::Methods
end
