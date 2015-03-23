class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  after_create :prepare_user

  before_create :set_subdomain

  def self.find_for_authentication(warden_conditions)
    where(email: warden_conditions[:email], subdomain: warden_conditions[:subdomain]).first
  end

  private

  def prepare_user
    create_schema
    load_tables
  end

  def set_subdomain
    temp_array = email.split('@')
    self.subdomain = temp_array[0].downcase
  end

  def create_schema
    PgTools.create_schema subdomain unless PgTools.schemas.include? id.to_s
  end

  def load_tables
    return if Rails.env.test?
    PgTools.set_search_path subdomain, false
    load "#{Rails.root}/db/schema.rb"
    PgTools.restore_default_search_path
  end

end
