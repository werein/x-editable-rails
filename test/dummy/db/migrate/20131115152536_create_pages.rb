class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.boolean :active
      t.string :name
      t.text :description

      t.timestamps
    end

    create_table :page_translations do |t|
      t.references :page, index: true
      t.string  :locale, null: false
      t.string  :title
      t.timestamps
    end

    add_index :page_translations, :locale
  end
end
