class CreateTeachingPlanAttachments < ActiveRecord::Migration
  def change
    create_table :teaching_plan_attachments do |t|
      t.references :teaching_plan, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
