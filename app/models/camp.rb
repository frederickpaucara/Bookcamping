# Camp
# Es un camping dentro de bookcamping. Originalmente fueron
# dos: bookcamping y videocamping. En la actualidad hay más y se
# pueden crear sobre la marcha.
#
class Camp < ActiveRecord::Base
  has_many :shelves
  has_many :camp_shelves
  has_many :curated_shelves
  has_many :user_shelves
  has_many :shelf_items
  has_many :books
  has_many :comments
  has_many :bookmarks
  has_many :memberships
  has_many :users, through: :memberships
  has_many :versions

  validates :name, presence: true
  validates :model_name, presence: true

  def self.boolean_accessor(keys) 
    keys.each do |key|
      define_method("#{key}?") do
        send(key) != '0'
      end
    end
  end

  store :settings, accessors: [ :has_blog, :lock_camp_shelves ]
  boolean_accessor [:has_blog, :lock_camp_shelves ]


  module Scopes
    def by_camp(camp)
      where(camp_id: camp.id)
    end
  end
  extend Scopes


end
