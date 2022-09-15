FactoryGirl.define do
  factory :discipline_teaching_plan do
    teaching_plan
    discipline

    trait :with_teacher_discipline_classroom do
      teaching_plan { build(:teaching_plan, :with_teacher_discipline_classroom, discipline: discipline) }
    end
  end
end
