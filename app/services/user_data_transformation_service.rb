# frozen_string_literal: true

class UserDataTransformationService
  BASE_URL = Rails.application.config.api_base_url
  AUTHORIZATION_TOKEN = 'abc123'

  attr_accessor :users, :valid_users

  def initialize
    @users = collect_data
  end

  def call
    valid_users = []
    users.each do |user|
      user =  build_user_data(user)
      user_object = User.new(user)
      if user_object.valid?
        user['phone'] = user_object.format_phone
        valid_users << user
      end
    end
    @valid_users = valid_users.sort_by { |hash| hash['lastName'] }
    self
  end

  def build_user_data(user)
    user_hash = {}
    user_hash["firstName"] = user["firstName"]
    user_hash["lastName"] = user["lastName"]
    user_hash["email"] = user["email"]
    if user['moreData'] && user['moreData']['phone']
      user_hash["phone"] = (user['moreData']['phone']).delete('^0-9')
      user['moreData'].delete('phone')
    end
    user_hash["moreData"] = user['moreData']
    user_hash
  end

  # Get data from API and parse to json
  def users_data
    response = RestClient.get(BASE_URL + '/users', Authorization: AUTHORIZATION_TOKEN )
    if response.code == 200
      JSON.parse response.body
    else
      []
    end
  end

   # Collate the data
  def collect_data
    # select data if it has first name and last name and remove duplicate
    user_list = []
    grouped_data = users_data.group_by { |user| [user['firstName'], user['lastName']] }
    grouped_data.keys.each do |key|
      user_hash = {}
      grouped_data[key].each_with_index do |data, index|
        if index == 0
          user_hash = data
        else
          merged_data = user_hash.merge(data)
          merged_data['moreData'].merge!(user_hash['moreData'])
          user_hash = merged_data
        end
      end
      user_list << user_hash
    end
    user_list
  end
end
