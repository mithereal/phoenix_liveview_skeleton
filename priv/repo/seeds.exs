{:ok, admin} =
  Api.Accounts.register_admin(%{
    email: "admin@company.com",
    password: "123456789abc",
    password_confirmation: "123456789abc",
    username: "admin"
  })

{:ok, user_1} =
  Api.Accounts.register_user(%{
    email: "user1@company.com",
    password: "123456789abc",
    password_confirmation: "123456789abc",
    username: "user1"
  })

{:ok, user_2} =
  Api.Accounts.register_user(%{
    email: "user2@company.com",
    password: "123456789abc",
    password_confirmation: "123456789abc",
    username: "user2"
  })
