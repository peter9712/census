class DropIsbNs < ActiveRecord::Migration[5.1]
  def change
    drop_table :isbns
  end
end
