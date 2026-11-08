class AddActiveToMocks < ActiveRecord::Migration[8.0]
  def change
    add_column :mocks, :active, :boolean, default: true, null: false
  end
end
