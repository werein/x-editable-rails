class Page < ActiveRecord::Base
  translates :title
  accepts_nested_attributes_for :translations, allow_destroy: true
  validates :name, length: { minimum: 5 }, allow_blank: true
end
