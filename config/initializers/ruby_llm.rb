RubyLLM.configure do |config|
  config.openai_api_key = ENV["OPENAI_API_KEY"] # If you use this, comment lines 3 and 4
  # config.openai_api_key = ENV["GITHUB_TOKEN"]
  # config.openai_api_base = "https://models.inference.ai.azure.com"
  config.default_model = "gpt-4o-mini"
  config.default_embedding_model = "text-embedding-3-small"
  config.openai_use_system_role = true

  # Use the new association-based acts_as API (recommended)
  config.use_new_acts_as = true
end
