class RenameBibliograpyColumnToPapers < ActiveRecord::Migration[5.2]
  def change
    rename_column :papers, :bibliograpy, :bibliography
  end
end
