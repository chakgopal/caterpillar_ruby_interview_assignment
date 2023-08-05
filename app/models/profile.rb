require 'openssl'
class Profile < ApplicationRecord
  validates :name, presence: true
  validates :age, presence: true

  def webhook_signature(secret_key)
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'),secret_key)
  end
end
