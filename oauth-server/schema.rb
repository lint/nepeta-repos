DB.create_table :users do
  primary_key :id

  String :username, :size => 255, :unique => true, :null => false
  String :password, :size => 255, :null => false
  String :role, :default => 'user', :null => false

  Timestamp :created_at, default: Sequel::CURRENT_TIMESTAMP
  Timestamp :updated_at
end

DB.create_table :apps do
  primary_key :id

  String :name, :size => 255, :unique => true, :null => false
  String :secret, :size => 64, :unique => true, :null => false
  Boolean :private, :default => false

  Timestamp :created_at, default: Sequel::CURRENT_TIMESTAMP
  Timestamp :updated_at
end

DB.create_table :sessions do
  String :token, :size => 64, :primary_key => true, :null => false
  foreign_key :user_id, :users, :null => false
  String :ip, :size => 45

  Timestamp :created_at, default: Sequel::CURRENT_TIMESTAMP
  Timestamp :updated_at
end

DB.create_table :tokens do
  String :token, :size => 64, :primary_key => true, :null => false
  String :code, :size => 64, :unique => true
  foreign_key :user_id, :users, :null => false
  foreign_key :app_id, :apps, :null => false
  String :role, :default => 'user', :null => false

  Timestamp :created_at, default: Sequel::CURRENT_TIMESTAMP
  Timestamp :updated_at

  unique [:user_id, :app_id]
end

DB.create_table :invites do
  String :token, :size => 64, :primary_key => true, :null => false
  foreign_key :user_id, :users
  String :role, :default => 'user', :null => false

  Timestamp :created_at, default: Sequel::CURRENT_TIMESTAMP
  Timestamp :updated_at
end

DB.create_table :app_invites do
  String :token, :size => 64, :primary_key => true, :null => false
  foreign_key :user_id, :users, :null => false

  Timestamp :created_at, default: Sequel::CURRENT_TIMESTAMP
  Timestamp :updated_at
end