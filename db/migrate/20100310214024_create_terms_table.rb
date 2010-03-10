class CreateTermsTable < ActiveRecord::Migration
  def self.up
    create_table :terms do |t|
      t.string :term
      t.integer :latest_status_id, :limit => 8
    end
  end

  def self.down
    drop_table :terms
  end
end
