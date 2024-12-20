class Person < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  has_many :emails, dependent: :destroy
  has_many :phonenumbers, dependent: :destroy
  has_many :personnotes, dependent: :destroy
  has_many :personlinks, dependent: :destroy
  has_many :personcompanies, dependent: :destroy

  validates :name, presence: true
end
