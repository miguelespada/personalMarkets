Before do
  Market.index_name('test_' + Market.model_name.plural)
  create(:category, name: "Uncategorized")
end