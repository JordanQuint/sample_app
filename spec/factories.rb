Factory.define :user do |user|
  user.name "Jordan Quint"
  user.email "jordanquint@hotmail.com"
  user.password "apples"
  user.password_confirmation "apples"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end