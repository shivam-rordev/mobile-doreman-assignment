# frozen_string_literal: true

class User
  include ActiveModel::Model
  BASE_URL = Rails.application.config.api_base_url
  AUTHORIZATION_TOKEN = 'abc123'

  EMAIL_REGEX_PATTERN =  /^(.+)@(.+)$/.freeze

  attr_accessor :firstName, :lastName, :email, :phone, :moreData

  validates :firstName, :lastName, presence: true

  validate :contact

  def contact
    is_email_valid? || valid_phone?
  end

  def is_email_valid?
    email =~ EMAIL_REGEX_PATTERN
  end

  def valid_phone?
    phone.length == 10
  end

  # To format the phone number like (nnn) nnn-nnnn
  def format_phone
    phone.sub(/(\d{3})(\d{3})(\d{4})/, '(\\1) \\2-\\3')
  end
end
