class ChangeColumnOldRecordToDefaultFalse < ActiveRecord::Migration
  def change
    change_column :conceptual_exams, :old_record, :boolean, default: false
  end
end
