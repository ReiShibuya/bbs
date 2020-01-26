class AddReidToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :reid, :integer
  end
end
