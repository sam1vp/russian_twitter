class CreateLanguageTables < ActiveRecord::Migration
  def self.up
    create_table :languages do |t|
      t.string :iso_lang_code
      t.integer :tweet_id
      t.boolean :is_reliable?
      t.float :confidence
    end
  end

  def self.down
    drop_table :languages
  end
end
