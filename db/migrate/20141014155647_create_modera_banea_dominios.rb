class CreateModeraBaneaDominios < ActiveRecord::Migration
  def change
    create_table :modera_banea_dominios do |t|
      t.string :dominio, null: false
      t.string :updated_usuario, null: false
      t.timestamps
    end

    add_index :modera_banea_dominios, :dominio, unique: true
  end
end
