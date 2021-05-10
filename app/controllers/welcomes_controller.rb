class WelcomesController < ApplicationController

  def index; end

  def users_json
    # users = User.new.users_data
    # send_data users.to_json, type: 'application/json; header=present', disposition: 'attachment; filename=transformed_users.json'

    service_object = UserDataTransformationService.new.call
    send_data service_object.valid_users.to_json, type: 'application/json; header=present',
                                                  disposition: 'attachment; filename=users_data.json'
  end
end
