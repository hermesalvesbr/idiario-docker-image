require 'rails_helper'

RSpec.describe Api::V2::ContentRecordsController, type: :controller do
  describe '#sync' do
    let(:teacher_discipline_classroom) {
      create(
        :teacher_discipline_classroom,
        :with_classroom_semester_steps
      )
    }

    around(:each) do |example|
      Entity.find_by(domain: 'test.host').using_connection do
        example.run
      end
    end

    before do
      User.current = create(:user, admin: true)
      request.env['REQUEST_PATH'] = '/api/v2/content_records/sync'
    end

    it 'destroys content record when content was not in the params' do
      content_record = create(
        :content_record,
        :with_contents,
        teacher: teacher_discipline_classroom.teacher,
        classroom_id: teacher_discipline_classroom.classroom_id
      )
      content_record.not_validate_columns = true

      create(
        :discipline_content_record,
        content_record: content_record,
        discipline_id: teacher_discipline_classroom.discipline_id,
        teacher_id: teacher_discipline_classroom.teacher_id
      )

      params = {
        record_date: content_record.record_date.to_s,
        classroom_id: teacher_discipline_classroom.classroom_id,
        teacher_id: teacher_discipline_classroom.teacher_id,
        discipline_id: teacher_discipline_classroom.discipline_id,
        contents: nil,
        format: 'json',
        locale: 'en'
      }

      expect {
        xhr :post, :sync, params
      }.to change { ContentRecord.count }.to(0)
    end

    it 'creates content' do
      content_record = create(
        :content_record,
        :with_contents,
        teacher: teacher_discipline_classroom.teacher,
        classroom_id: teacher_discipline_classroom.classroom_id
      )
      content_record.not_validate_columns = true

      create(
        :discipline_content_record,
        content_record: content_record,
        discipline_id: teacher_discipline_classroom.discipline_id,
        teacher_id: teacher_discipline_classroom.teacher_id
      )

      content1 = { id: Content.first.id }
      content2 = { description: 'algebra linear para crian??as de at?? um ano' }

      params = {
        record_date: content_record.record_date.to_s,
        classroom_id: teacher_discipline_classroom.classroom_id,
        teacher_id: teacher_discipline_classroom.teacher_id,
        discipline_id: teacher_discipline_classroom.discipline_id,
        contents: [content1, content2],
        format: 'json',
        locale: 'en'
      }

      content_record.contents << content_record.contents.first

      xhr :post, :sync, params

      expect(content_record.reload.contents.pluck(:description)).
        to match_array [Content.first.description, content2[:description]]
    end
  end
end
