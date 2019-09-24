class App < Sequel::Model
  many_to_many :users, join_table: :tokens
  many_to_many :admins, join_table: :tokens, class: :User, right_key: :user_id, conditions: {Sequel.qualify(:tokens, :role) => 'admin'}
end