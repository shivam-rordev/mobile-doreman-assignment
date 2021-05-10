class WelcomesController < ApplicationController

  def index; end

  def users_json
    user_object = UserDataTransformationService.new.call
    send_data user_object.valid_users.to_json, type: 'application/json; header=present',
                                                  disposition: 'attachment; filename=users_data.json'
  end
end
