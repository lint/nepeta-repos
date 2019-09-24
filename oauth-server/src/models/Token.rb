class Token < Sequel::Model
  many_to_one :app
  many_to_one :user
end