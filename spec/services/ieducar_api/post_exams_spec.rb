require 'spec_helper'

RSpec.describe IeducarApi::PostExams, type: :service do
  let(:url) { 'https://test.ieducar.com.br' }
  let(:access_key) { '8IOwGIjiHvbeTklgwo10yVLgwDhhvs' }
  let(:secret_key) { '5y8cfq31oGvFdAlGMCLIeSKdfc8pUC' }
  let(:unity_id) { 1 }
  let(:resource) { 'notas' }
  let(:etapa) { 1 }
  let(:notas) { '1' }

  subject do
    IeducarApi::PostExams.new(
      url: url,
      access_key: access_key,
      secret_key: secret_key,
      unity_id: unity_id
    )
  end

  describe '#send_post' do
    it 'returns message' do
      skip

      VCR.use_cassette('post_exams') do
        result = subject.send_post(
          etapa: etapa,
          notas: notas,
          resource: resource
        )

        expect(result.keys).to include 'msgs'
        expect(result['any_error_msg']).to be false
      end
    end

    it 'necessary to inform scores' do
      expect {
        subject.send_post(
          unity_id: 1,
          etapa: etapa,
          resource: resource
        )
      }.to raise_error('É necessário informar as notas')
    end

    it 'necessary to inform etapa' do
      expect {
        subject.send_post(
          unity_id: 1,
          notas: notas,
          resource: resource
        )
      }.to raise_error('É necessário informar a etapa')
    end

    it 'necessary to inform resource' do
      expect {
        subject.send_post(
          unity_id: 1,
          notas: notas,
          etapa: etapa
        )
      }.to raise_error('É necessário informar o recurso')
    end
  end
end
