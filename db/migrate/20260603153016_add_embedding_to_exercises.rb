class AddEmbeddingToExercises < ActiveRecord::Migration[8.1]
  def change
    add_column :exercises, :embedding, :vector, limit: 1536 # 1536 dimensions matches OpenAI text-embedding-3-small output
  end
end
