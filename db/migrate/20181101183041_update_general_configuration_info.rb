class UpdateGeneralConfigurationInfo < ActiveRecord::Migration
  def change
    general_configuration = GeneralConfiguration.current

    general_configuration.copyright_name = 'Softagon Sistemas'
    general_configuration.support_freshdesk = 'https://softagon.freshdesk.com'
    general_configuration.support_url = 'https://softagon.com.br'

    general_configuration.without_auditing do
      general_configuration.save(validate: false)
    end
  end
end
