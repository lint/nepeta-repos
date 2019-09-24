class User < Sequel::Model
  many_to_many :authorized_apps, class: :App, right_key: :app_id, join_table: :tokens
  one_to_many :sessions
  many_to_many :apps, join_table: :tokens, conditions: {:role => 'admin'}
end