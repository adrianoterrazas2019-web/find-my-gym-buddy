class AddPairScoreToPairings < ActiveRecord::Migration[8.1]
  def change
    add_column :pairings, :pair_score, :integer
  end
end
